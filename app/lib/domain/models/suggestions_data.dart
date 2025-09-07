import 'package:dam_music_streaming/domain/models/playlist_data.dart';
import 'package:dam_music_streaming/domain/models/song_data.dart';

class SuggestionWeatherData {
  final List<PlaylistData> playlists;
  final List<SongData> songs;

  SuggestionWeatherData({
    required this.playlists,
    required this.songs,
  });
}