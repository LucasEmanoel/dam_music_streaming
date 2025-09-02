
import 'package:dam_music_streaming/data/dto/album_dto.dart';
import 'package:dam_music_streaming/data/dto/artist_dto.dart';
import 'package:dam_music_streaming/data/services/api_service.dart';
import 'package:dam_music_streaming/domain/models/artist_data.dart';
import 'package:dio/dio.dart';

class ArtistApiService {
  final Dio _dio;

  ArtistApiService({ApiClient? apiClient}) : _dio = apiClient?.dio ?? ApiClient().dio;

  Future<ArtistDto> getById(int id) async {
    final response = await _dio.get('/albums/$id');
    return ArtistDto.fromMap(response.data);
  }

}