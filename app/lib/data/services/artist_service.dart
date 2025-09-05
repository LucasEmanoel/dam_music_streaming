
import 'package:dam_music_streaming/data/dto/artist_dto.dart';
import 'package:dam_music_streaming/data/services/api_service.dart';
import 'package:dio/dio.dart';

class ArtistApiService {
  final Dio _dio;

  ArtistApiService({ApiClient? apiClient}) : _dio = apiClient?.dio ?? ApiClient().dio;

  Future<ArtistDto> getById(int id) async {
    final response = await _dio.get('/artists/$id');
    return ArtistDto.fromMap(response.data);
  }

  Future<ArtistDto> getDetailedById(int id) async {
    final response = await _dio.get('/artists/$id/items');
    return ArtistDto.fromMap(response.data);
  }

}