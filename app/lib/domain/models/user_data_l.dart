import '../../data/dto/user_dto_l.dart';

class UsuarioData {
  final int? id;
  final String username;
  final String email;
  final String role;

  UsuarioData({
    this.id,
    required this.username,
    required this.email,
    required this.role,
  });

  factory UsuarioData.fromDto(UsuarioDto dto) {
    return UsuarioData(
      id: dto.id,
      username: dto.username.isNotEmpty ? dto.username : 'Usuário desconhecido',
      email: dto.email,
      role: dto.role.isNotEmpty ? dto.role : 'USER',
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