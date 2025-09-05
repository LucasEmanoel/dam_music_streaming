
import 'package:dam_music_streaming/data/dto/album_dto.dart';
import 'package:dam_music_streaming/data/services/api_service.dart';
import 'package:dio/dio.dart';

class AlbumApiService {
  final Dio _dio;

  AlbumApiService({ApiClient? apiClient}) : _dio = apiClient?.dio ?? ApiClient().dio;

  Future<AlbumDto> getById(int id) async {
    final response = await _dio.get('/albums/$id');
    return AlbumDto.fromMap(response.data);
  }

  Future<AlbumDto> getDetailedById(int id) async {
    final response = await _dio.get('/albums/$id/songs');
    return AlbumDto.fromMap(response.data);
  }

}