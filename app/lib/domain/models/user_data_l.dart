import '../../data/dto/user_dto_l.dart';

class UsuarioData {
  int? id;
  String? fullName;
  String username;
  String email;
  String role;

  UsuarioData({
    this.id,
    this.fullName,
    required this.username,
    required this.email,
    required this.role,
  });

  factory UsuarioData.fromDto(UsuarioDto dto) {
    return UsuarioData(
      id: dto.id,
      fullName: dto.fullName != null && dto.fullName!.isNotEmpty
          ? dto.fullName
          : null,
      username: dto.username.isNotEmpty ? dto.username : 'Usuário desconhecido',
      email: dto.email,
      role: dto.role.isNotEmpty ? dto.role : 'USER',
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

  @override
  String toString() {
    return 'UsuarioData{id: $id, fullName: $fullName, username: $username, email: $email, role: $role}';
  }
}
