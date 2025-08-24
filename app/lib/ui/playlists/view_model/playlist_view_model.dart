import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_music_streaming/domain/models/playlist_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../../../data/repositories/playlist_repository.dart';

class PlaylistViewModel extends ChangeNotifier {

  final FirebaseStorage  _firestore = FirebaseStorage.instance;
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
    try {
      _playlists = await repository.getPlaylists();
      print(_playlists);
    } catch (e) {
      print('error: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> savePlaylist() async {
    print('EN?TIDADE');
    print(entityBeingEdited?.toMap());
    print('IMAGEMMMM');
    print(_pickedImageFile);

    if (entityBeingEdited == null) return;



    try {
      final savedPlaylist = (entityBeingEdited!.id == null)
          ? await repository.createPlaylist(entityBeingEdited!)
          : await repository.updatePlaylist(entityBeingEdited!.id!, entityBeingEdited!);

      if (_pickedImageFile != null) {
        final playlistId = savedPlaylist.id ?? FirebaseFirestore.instance.collection('temp').doc().id;

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
      _pickedImageFile = null;
      setStackIndex(0);
    }
  }

  Future<void> deletePlaylist(int id) async {
    if (entityBeingVisualized == null) return;

    try {
      final ref = _firestore.ref('playlist_covers/$id.jpg');
      await ref.delete().catchError((e) => print("Imagem não encontrada para deletar: $e"));
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
    entityBeingEdited = playlist ??
        PlaylistData(
            title: '', urlCover: '', numSongs: 0, description: '');
    notifyListeners();
  }

  void startView({PlaylistData? playlist}) {
    entityBeingVisualized = playlist ??
        PlaylistData(
            title: '', urlCover: '', numSongs: 0, description: '');
    notifyListeners();
  }

  void setPickedImage(File? file) {
    _pickedImageFile = file;
  }

  void triggerRebuild() {
    notifyListeners();
  }
}