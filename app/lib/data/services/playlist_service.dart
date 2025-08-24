import 'package:dio/dio.dart';

import 'package:dam_music_streaming/data/dto/playlist_dto.dart';

import '../../config/api_config.dart';
import '../../config/token_manager.dart';



class PlaylistApiService {

  final Dio _dio;
  final String baseUrl;

  PlaylistApiService({Dio? dio, this.baseUrl = ApiConfig.baseUrl})
    : _dio = dio ??
    Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10)
      )
    ) 
    {
      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          final _token = await getToken();
          if (_token != null && _token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          handler.next(options);
        }
      ));
    }

    Future<List<PlaylistDto>> fetchPlaylists() async{
    final response = await _dio.get('/playlists');
    final List<dynamic> jsonList = response.data;
    print(jsonList);
    return jsonList
        .map((map) => PlaylistDto.fromMap(map as Map<String, dynamic>))
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
    print('SERVICE');
    print(playlist.toMap());
    final response = await _dio.put('/playlists/$id', data: playlist.toMap());
    return PlaylistDto.fromMap(response.data);
  }

  Future<void> delete(int id) async {
    await _dio.delete('/playlists/$id');
  }
}