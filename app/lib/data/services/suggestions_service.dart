import 'package:dam_music_streaming/data/dto/suggestion_dto.dart';
import 'package:dam_music_streaming/data/services/api_service.dart';
import 'package:dio/dio.dart';


class SuggestionsService {
  final Dio _dio;

  SuggestionsService({ApiClient? apiClient}) : _dio = apiClient?.dio ?? ApiClient().dio;

  Future<SuggestionWeatherResponseDto> fetchPlaylistsAndSongsByWeather(
    String weather,
  ) async {
    final response = await _dio.get(
      '/suggestions',
      queryParameters: {'weather': weather},
    );

    return SuggestionWeatherResponseDto.fromMap(
      response.data as Map<String, dynamic>,
    );
  }
}
