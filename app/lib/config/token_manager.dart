import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorage = FlutterSecureStorage();

Future<void> saveToken(String token) async {
  await secureStorage.write(key: 'jwt', value: token);
}

Future<String?> getToken() async {
  return await secureStorage.read(key: 'jwt');
}

Future<void> deleteToken() async {
  await secureStorage.delete(key: 'jwt');
}

Future<Map<String, dynamic>> getTokenData(String token) async {
  String? token = await getToken();

  if (token == null) return {};

  final jwt = JWT.decode(token);
  print(jwt.payload);
  return jwt.payload;
}
