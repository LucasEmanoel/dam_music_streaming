import 'package:dam_music_streaming/domain/models/user_data_l.dart';

class UsuarioDto {
  final int? id;
  final String? fullName;
  final String username;
  final String email;
  final String role;

  UsuarioDto({
    this.id,
    this.fullName,
    required this.username,
    required this.email,
    required this.role,
  });

  factory UsuarioDto.fromMap(Map<String, dynamic> map) {
    return UsuarioDto(
      id: map['id'],
      fullName: map['fullName'] ?? null,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
    );
  }

  factory UsuarioDto.fromData(UsuarioData data) {
    return UsuarioDto(
      id: data.id,
      fullName: data.fullName ?? null,
      username: data.username,
      email: data.email ?? '',
      role: data.role ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'role': role,
    };
  }
}
