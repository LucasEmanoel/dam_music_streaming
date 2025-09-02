import 'package:flutter/material.dart';

import '../../../domain/models/song_data.dart';


class SearchViewModel extends ChangeNotifier {

  final Set<SongData> _selectedSongs = {};
  Set<SongData> get selectedSongs => _selectedSongs;

  void toggleSongSelection(SongData song) { //isso adiciona ou remove a musica, só preciso pegar o estado e mostrar
    if (_selectedSongs.contains(song)) {
      _selectedSongs.remove(song);
    } else {
      _selectedSongs.add(song);
      print(_selectedSongs);
    }
    //
    notifyListeners();
  }

  void clearSelection() {
    _selectedSongs.clear();
    notifyListeners();
  }
}