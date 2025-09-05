import 'package:dam_music_streaming/data/services/storage_service.dart';
import 'package:dam_music_streaming/domain/models/playlist_data.dart';
import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../../../data/repositories/playlist_repository.dart';

class PlaylistViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final StorageService storageService = StorageService();
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
    final playlistToSave = entityBeingEdited;
    if (playlistToSave == null) {
      return;
    }

    _isLoading = true;

    try {
      if (playlistToSave.id == null) {
        print(entityBeingEdited.toString());
        var createdPlaylist = await repository.createPlaylist(playlistToSave);
        print(createdPlaylist.toString());

        if (_pickedImageFile != null && createdPlaylist.id != null) {
          final imageUrl = await storageService.uploadPlaylistCover(
            playlistId: createdPlaylist.id!,
            imageFile: _pickedImageFile!,
          );

          createdPlaylist.urlCover = imageUrl;
          await repository.updatePlaylist(createdPlaylist.id!, createdPlaylist);
        }
      } else {
        if (_pickedImageFile != null) {
          final imageUrl = await storageService.uploadPlaylistCover(
            playlistId: playlistToSave.id!,
            imageFile: _pickedImageFile!,
          );
          playlistToSave.urlCover = imageUrl;
        }
        await repository.updatePlaylist(playlistToSave.id!, playlistToSave);
      }

      await loadPlaylists();
    } catch (e, s) {
      print('Erro ao salvar playlist: $e\n$s');
    } finally {
      _pickedImageFile = null;
      setStackIndex(0);
      _isLoading = false;
    }
  }

  Future<void> addSongsToCurrentPlaylist(int id, Set<SongData> songs) async {
    _isLoading = true;
    try {
      final musicApiIds = songs.map((song) => song.id!).toList();
      PlaylistData updated = await repository.addSongsToPlaylist(
        id,
        musicApiIds,
      );
      entityBeingVisualized = updated;
    } catch (e) {
      print('Erro ao adicionar músicas: $e');
    } finally {
      _isLoading = false;
    }
  }

  Future<void> deletePlaylist(int id) async {
    _isLoading = true;
    try {
      await storageService.deletePlaylistCover(id);
      await repository.deletePlaylist(id);
      await loadPlaylists();
    } catch (e) {
      print('Erro ao deletar playlist: $e');
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

  void startView({required int id}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final playlistComMusicas = await repository.getPlaylistWithSongs(id);
      entityBeingVisualized = playlistComMusicas;
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setPickedImage(File? file) {
    _pickedImageFile = file;
    notifyListeners();
  }
}
