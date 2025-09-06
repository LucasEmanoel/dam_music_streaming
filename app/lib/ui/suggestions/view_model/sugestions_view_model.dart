import 'package:dam_music_streaming/data/repositories/weather_repository.dart';
import 'package:dam_music_streaming/domain/models/enum_weather.dart';
import 'package:dam_music_streaming/domain/models/playlist_data.dart';
import 'package:flutter/material.dart';
import 'package:dam_music_streaming/data/repositories/playlist_repository.dart';

class SuggestionsViewModel extends ChangeNotifier {
  //final AlbumRepository _albumRepository = AlbumRepository(); //vou colocar albunms depois só, se der tempo agr o foco é as playlists por tempo
  final PlaylistRepository _playlistRepository = PlaylistRepository();
  final WeatherRepository _weatherRepository = WeatherRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<PlaylistData> _playlists = [];
  List<PlaylistData> get playlists => _playlists;

  Future<void> getSuggestionsByWeather() async {
    _isLoading = true;
    notifyListeners();

    List<PlaylistData> fetchedPlaylists = [];

    try {
      final weather = await _weatherRepository.getCurrentWeather();

      if (weather != null) {
        final condition = weather.weatherMain?.toUpperCase() ?? '';
        final weatherEnum = EnumWeather.values.byName(condition);

        fetchedPlaylists = await _playlistRepository.fetchPlaylistsByWeather(
          weatherEnum.name,
        );
      } else {
        fetchedPlaylists = await _playlistRepository.getPlaylists(); // pegar o top10
      }
    } catch (e) {
      print(e);
      fetchedPlaylists = await _playlistRepository.getPlaylists(); // pegar o top10, TODO: mudar para uma lista de playlists padrão
    } finally {
      _playlists.clear();
      _playlists.addAll(fetchedPlaylists);
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearItemsBeingViewed() {
    _playlists.clear();
    _isLoading = false;
    notifyListeners();
  }
}
