import 'package:dio/dio.dart';
import 'package:dam_music_streaming/data/services/api_service.dart';
import 'package:dam_music_streaming/data/dto/genre_detail_dto.dart';

class GenreMiniDto {
  final int id;
  final String name;
  GenreMiniDto({required this.id, required this.name});

  factory GenreMiniDto.fromMap(Map<String, dynamic> m) =>
      GenreMiniDto(id: m['id'] ?? -1, name: m['name'] ?? '');
}

class GenreApiService {
  final Dio _dio;
  GenreApiService({ApiClient? apiClient})
      : _dio = apiClient?.dio ?? ApiClient().dio;

  Future<GenreMiniDto?> fetchBySong(int songId) async {
    final r = await _dio.get('/genres/by-song/$songId');
    if (r.statusCode == 200 && r.data != null) {
      return GenreMiniDto.fromMap(r.data as Map<String, dynamic>);
    }
    return null;
  }

  Future<GenreDetailDto> fetchGenreDetail(int genreId) async {
    final r = await _dio.get('/genres/$genreId');
    if (r.statusCode == 200 && r.data != null) {
      return GenreDetailDto.fromMap(r.data as Map<String, dynamic>);
    }
    throw Exception('Erro ao carregar detalhes do gênero');
  }
}
