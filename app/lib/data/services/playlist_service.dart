import 'package:dam_music_streaming/data/dto/song_dto.dart';
import 'package:dam_music_streaming/data/services/api_service.dart';
import 'package:dio/dio.dart';

import 'package:dam_music_streaming/data/dto/playlist_dto.dart';

class PlaylistApiService {
  final Dio _dio;

  PlaylistApiService({ApiClient? apiClient})
    : _dio = apiClient?.dio ?? ApiClient().dio;

  Future<List<PlaylistDto>> fetchPlaylists() async {
    final response = await _dio.get('/playlists');
    final List<dynamic> jsonList = response.data;
    return jsonList
        .map((map) => PlaylistDto.fromMap(map as Map<String, dynamic>))
        .toList();
  }

  Future<List<SongDto>> searchSongs(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final response = await _dio.get(
      '/songs/search',
      queryParameters: {'q': query},
    );

    final List<dynamic> jsonList = response.data;

    return jsonList
        .map((map) => SongDto.fromMap(map as Map<String, dynamic>))
        .toList();
  }

  Future<PlaylistDto> getById(int id) async {
    final response = await _dio.get('/playlists/$id');
    return PlaylistDto.fromMap(response.data);
  }

  Future<PlaylistDto> create(PlaylistDto playlist) async {
    final response = await _dio.post('/playlists', data: playlist.toMap());
    return PlaylistDto.fromMap(response.data);
  }

  Future<PlaylistDto> update(int id, PlaylistDto playlist) async {
    final response = await _dio.put('/playlists/$id', data: playlist.toMap());
    return PlaylistDto.fromMap(response.data);
  }

  Future<void> delete(int id) async {
    await _dio.delete('/playlists/$id');
  }

  Future<void> removeSong(int playlistId, int songId) async {
    await _dio.delete('/playlists/$playlistId/songs/$songId');
  }

  Future<PlaylistDto> postSongs(int id, List<int> songsIds) async {
    final response = await _dio.post(
      '/playlists/$id/songs',
      data: {'songs_ids': songsIds},
    );

    return PlaylistDto.fromMap(response.data);
  }

  Future<List<PlaylistDto>> fetchPlaylistsByWeather(String weather) async {
    final response = await _dio.get(
      '/suggestions',
      queryParameters: {'weather': weather},
    );
    final List<dynamic> jsonList = response.data;
    return jsonList
        .map((map) => PlaylistDto.fromMap(map as Map<String, dynamic>))
        .toList();
  }
}
