import 'package:dam_music_streaming/data/repositories/playlist_repository.dart';
import 'package:dam_music_streaming/domain/mock/playlist_mock.dart';
import 'package:dam_music_streaming/domain/models/playlist_data.dart';
import 'package:flutter/material.dart';

class PlaylistViewModel extends ChangeNotifier {
  int _stackIndex = 0;
  List<PlaylistData> _playlists = [];

  Future<void> loadPlaylists() async {
    _playlists = await MockPlaylists.playlists;
    notifyListeners();
  }

  int get stackIndex => _stackIndex;
  List<PlaylistData> get playlists => _playlists;

  void setStackIndex(int index) {
    _stackIndex = index;
    notifyListeners();
  }
}