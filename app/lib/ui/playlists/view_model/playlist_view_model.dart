import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_music_streaming/domain/models/playlist_data.dart';
import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../../../data/repositories/playlist_repository.dart';

class PlaylistViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final FirebaseStorage _firestore = FirebaseStorage.instance;
  //final storageRef = FirebaseStorage.instance.ref();

  final PlaylistRepository repository = PlaylistRepository();

  int _stackIndex = 0;

  List<PlaylistData> _playlists = [];
  PlaylistData? entityBeingVisualized;
  PlaylistData? entityBeingEdited;
  File? _pickedImageFile;
  final Directory docsDir;

  PlaylistViewModel(this.docsDir);

  Future<void> loadPlaylists() async {
    _isLoading = true;
    notifyListeners();

    try {
      _playlists = await repository.getPlaylists();
    } catch (e) {
      print('error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> savePlaylist() async {
    _isLoading = true;
    notifyListeners();

    if (entityBeingEdited == null) return;

    try {
      final savedPlaylist = (entityBeingEdited!.id == null)
          ? await repository.createPlaylist(entityBeingEdited!)
          : await repository.updatePlaylist(
              entityBeingEdited!.id!,
              entityBeingEdited!,
            );

      if (_pickedImageFile != null) {
        final playlistId =
            savedPlaylist.id ??
            FirebaseFirestore.instance.collection('temp').doc().id;

        final ref = _firestore.ref('playlist_covers/$playlistId.jpg');
        final uploadTask = await ref.putFile(_pickedImageFile!);

        final imageUrl = await uploadTask.ref.getDownloadURL();
        savedPlaylist.urlCover = imageUrl;
      }

      await repository.updatePlaylist(savedPlaylist.id!, savedPlaylist);
      await loadPlaylists();
    } catch (e) {
      print('error ao salvar: $e');
    } finally {
      _isLoading = false;
      _pickedImageFile = null;
      setStackIndex(0);
    }
  }

  Future<void> addSongsToCurrentPlaylist(int id, Set<SongData> songs) async {
    try {
      final musicApiIds = songs.map((song) => song.id!).toList();
      PlaylistData updated = await repository.addSongsToPlaylist(
        id,
        musicApiIds,
      );
      entityBeingVisualized = updated;

      triggerRebuild();
    } catch (e) {
      print('error ao deletar: $e');
    } finally {
      print('ok');
    }
  }

  Future<void> deletePlaylist(int id) async {
    if (entityBeingVisualized == null) return;

    try {
      final ref = _firestore.ref('playlist_covers/$id.jpg');
      await ref.delete().catchError(
        (e) => print("Imagem não encontrada para deletar: $e"),
      );
      await repository.deletePlaylist(id);
      await loadPlaylists();
    } catch (e) {
      print('error ao deletar: $e');
    } finally {
      setStackIndex(0);
    }
  }

  int get stackIndex => _stackIndex;
  List<PlaylistData> get playlists => _playlists;
  File? get pickedImageFile => _pickedImageFile;

  void setStackIndex(int index) {
    _stackIndex = index;
    if (index == 0) {
      entityBeingEdited = null;
      _pickedImageFile = null;
    }
    notifyListeners();
  }

  void startEditing({PlaylistData? playlist}) {
    _pickedImageFile = null;
    entityBeingEdited =
        playlist ??
        PlaylistData(title: '', urlCover: '', numSongs: 0, description: '');
    notifyListeners();
  }

  void startView({int? id}) async {
    print('ID QUE TO PASSANDO LIST -> VIEW = $id');

    if (id == null) {
      print('ID NULL');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      print('antes');
      final playlistComMusicas = await repository.getPlaylistWithSongs(
        id,
      );
      print('depois');
      if(playlistComMusicas.songs?.isEmpty ?? true){
        print('vazia');
      } else {
        entityBeingVisualized = playlistComMusicas;
      }


      
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setPickedImage(File? file) {
    _pickedImageFile = file;
  }

  void triggerRebuild() {
    notifyListeners();
  }
}
