
import 'package:dam_music_streaming/data/dto/artist_dto.dart';
import 'package:dam_music_streaming/data/services/api_service.dart';
import 'package:dio/dio.dart';

class ArtistApiService {
  final Dio _dio;

  ArtistApiService({ApiClient? apiClient}) : _dio = apiClient?.dio ?? ApiClient().dio;

  Future<ArtistDto> getById(int id) async {
    print('ARTIST ID $id');
    final response = await _dio.get('/artists/$id');
    return ArtistDto.fromMap(response.data);
  }
}