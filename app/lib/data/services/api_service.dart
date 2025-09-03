import 'package:dio/dio.dart';
import '../../config/api_config.dart';
import '../../config/token_manager.dart';

class ApiClient {
  final Dio dio;

  ApiClient._internal()
      : dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    sendTimeout: const Duration(seconds: 20),
  )) {

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {

        final token = await getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() {
    return _instance;
  }
}