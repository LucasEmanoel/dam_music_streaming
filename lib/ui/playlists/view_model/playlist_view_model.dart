import 'package:dam_music_streaming/data/dto/playlist_dto.dart';
import 'package:dam_music_streaming/data/services/playlist_service.dart';
import 'package:dam_music_streaming/domain/models/playlist_data.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PlaylistViewModel extends ChangeNotifier {
  int _stackIndex = 0;
  List<PlaylistData> _playlists = [];
  List<PlaylistDto> _playlistsDto = [];
  PlaylistData? entityBeingVisualized;
  PlaylistData? entityBeingEdited;
  final Directory docsDir;

  PlaylistViewModel(this.docsDir);

  Future<void> loadPlaylists() async {
    try{
      _playlistsDto = await PlaylistApiService.listAll();
      _playlists = _playlistsDto.map((dto) => PlaylistData.fromDto(dto)).toList();

    } catch (e) {
      print('error');
    } finally {
      notifyListeners();
    }
  }

  int get stackIndex => _stackIndex;
  List<PlaylistData> get playlists => _playlists;


  void setStackIndex(int index) {
    _stackIndex = index;
    notifyListeners();
  }

  void startEditing({PlaylistData? playlist}){
    entityBeingEdited = playlist ?? PlaylistData(title: '', author: '', urlCover: '', numSongs: 0, description: '');
    notifyListeners();
  }

  void startView({PlaylistData? playlist}){
    entityBeingVisualized = playlist ?? PlaylistData(title: '', author: '', urlCover: '', numSongs: 0, description: '');
    notifyListeners();
  }

  void triggerRebuild() {
    notifyListeners();
  }
}