import 'package:dam_music_streaming/domain/models/user_data_l.dart';

class UsuarioDto {
  final int? id;
  final String? username;
  final String? email;
  final String? role;

  UsuarioDto({
    this.id,
    this.username,
    this.email,
    this.role,
  });

  factory UsuarioDto.fromMap(Map<String, dynamic> map) {
    return UsuarioDto(
      id: map['id'] ?? -1,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
    );
  }

  factory UsuarioDto.fromData(UsuarioData data) {
    return UsuarioDto(
      id: data.id ?? -1,
      username: data.username ?? '',
      email: data.email ?? '',
      role: data.role ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
    };
  }
  
}