import 'package:dam_music_streaming/data/repositories/suggestion_repository.dart';
import 'package:dam_music_streaming/data/repositories/weather_repository.dart';
import 'package:dam_music_streaming/domain/models/enum_weather.dart';
import 'package:dam_music_streaming/domain/models/playlist_data.dart';
import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'package:flutter/material.dart';
import 'package:dam_music_streaming/data/repositories/playlist_repository.dart';

class SuggestionsViewModel extends ChangeNotifier {
  //final AlbumRepository _albumRepository = AlbumRepository(); //vou colocar albunms depois só, se der tempo agr o foco é as playlists por tempo
  final SuggestionsRepository _suggestionRepository = SuggestionsRepository();
  final WeatherRepository _weatherRepository = WeatherRepository();

  String? _currentWeather = null;
  String? get currentWeather => _currentWeather;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  final List<SongData> _songs = [];
  List<SongData> get songs => _songs;

  final List<PlaylistData> _playlists = [];
  List<PlaylistData> get playlists => _playlists;

  Future<void> getSuggestionsByWeather() async {
    _isLoading = true;
    notifyListeners();

    List<PlaylistData> fetchedPlaylists = [];
    List<SongData> fetchedSongs = [];

    try {
      final weather = await _weatherRepository.getCurrentWeather();

      if (weather != null) {
        final condition = weather.weatherMain?.toUpperCase() ?? '';
        final weatherEnum = EnumWeather.values.byName(condition);
        _currentWeather = weatherEnum.name;

        final suggestionData = await _suggestionRepository
            .fetchPlaylistsAndSongsByWeather(weatherEnum.name);

        fetchedPlaylists = suggestionData.playlists;
        fetchedSongs = suggestionData.songs;
      } else {
        fetchedPlaylists = [];
        fetchedSongs = []; // pegar o top10
      }
    } catch (e) {
      print(e);
      fetchedPlaylists = [];
      fetchedSongs = []; 
    } finally {
      _playlists.clear();
      _playlists.addAll(fetchedPlaylists);

      _songs.clear();
      _songs.addAll(fetchedSongs);

      _isLoading = false;
      notifyListeners();
    }
  }

  void clearItemsBeingViewed() {
    _playlists.clear();
    _songs.clear();
    _currentWeather = null;
    _isLoading = false;
    notifyListeners();
  }
}
