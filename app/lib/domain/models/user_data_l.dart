import '../../data/dto/user_dto_l.dart';

class UsuarioData {
  int? id;
  String? username;
  String? email;
  String? role;

  UsuarioData({
    this.id,
    this.username,
    this.email,
    this.role,
  });

  factory UsuarioData.fromDto(UsuarioDto dto) {
    return UsuarioData(
      id: dto.id,
      username: dto.username,
      email: dto.email,
      role: dto.role,
    );
  }
}
