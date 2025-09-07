

import 'package:dam_music_streaming/data/dto/playlist_dto.dart';
import 'package:dam_music_streaming/data/dto/song_dto.dart';

class SuggestionWeatherResponseDto {
  final List<PlaylistDto> playlists;
  final List<SongDto> songs;

  SuggestionWeatherResponseDto({
    required this.playlists,
    required this.songs,
  });

  factory SuggestionWeatherResponseDto.fromMap(Map<String, dynamic> map) {
    
    return SuggestionWeatherResponseDto(

      playlists: (map['playlists'] as List<dynamic>?)
              ?.map((p) => PlaylistDto.fromMap(p as Map<String, dynamic>))
              .toList() ??
          [],

      songs: (map['songs'] as List<dynamic>?)
              ?.map((s) => SongDto.fromMap(s as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
