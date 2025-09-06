import 'package:dio/dio.dart';
import '../../config/api_config.dart';
import '../../config/token_manager.dart';

class ApiClient {
  final Dio dio;

  ApiClient._internal()
      : dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  )) {
    dio.interceptors.add(LogInterceptor(
      request: true, requestHeader: true, requestBody: true,
      responseHeader: false, responseBody: true, error: true,
    ));

    // Injeta Authorization só quando precisar
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final needsAuth = options.extra['auth'] != false;
        if (needsAuth) {
          final token = await getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        } else {
          options.headers.remove('Authorization'); // garantir que não vai
        }
        handler.next(options);
      },
    ));
  }

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
}
