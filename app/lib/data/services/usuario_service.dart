import 'package:dam_music_streaming/config/token_manager.dart';
import 'package:dam_music_streaming/data/dto/user_dto_l.dart';
import 'package:dam_music_streaming/data/services/api_service.dart';
import 'package:dio/dio.dart';

class UserApiService {
  final Dio _dio;

  UserApiService({ApiClient? apiClient})
    : _dio = apiClient?.dio ?? ApiClient().dio;

  Future<UsuarioDto> updateProfile(int id, UsuarioDto user) async {
    String token = await getToken() ?? '';

    final response = await _dio.patch(
      '/user/$id',
      data: user.toProfileMap(),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return UsuarioDto.fromMap(response.data);
  }

  Future<UsuarioDto> getProfile(int id) async {
    String token = await getToken() ?? '';

    final response = await _dio.get(
      '/user/profile/$id',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return UsuarioDto.fromMap(response.data);
  }

  Future<void> deleteUser(int id) async {
    String token = await getToken() ?? '';

    await _dio.delete(
      '/user/$id',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
