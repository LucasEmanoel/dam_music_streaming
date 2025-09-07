// lib/domain/repository/suggestions_repository.dart
import 'package:dam_music_streaming/data/services/suggestions_service.dart';
import 'package:dam_music_streaming/domain/models/playlist_data.dart';
import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'package:dam_music_streaming/domain/models/suggestions_data.dart';

class SuggestionsRepository {
  final SuggestionsService suggestionsService = SuggestionsService();

  SuggestionsRepository();

  Future<SuggestionWeatherData> fetchPlaylistsAndSongsByWeather(
    String weather,
  ) async {
    final responseDto = await suggestionsService.fetchPlaylistsAndSongsByWeather(
      weather,
    );

    final playlists = responseDto.playlists
        .map((dto) => PlaylistData.fromDto(dto))
        .toList();

    final songs = responseDto.songs
        .map((dto) => SongData.fromDto(dto))
        .toList();

    return SuggestionWeatherData(
      playlists: playlists,
      songs: songs,
    );
  }
}