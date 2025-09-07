import '../../data/dto/user_dto_l.dart';

class UsuarioData {
  int? id;
  String? fullName;
  String? username;
  String? email;
  String? role;
  String? profilePicUrl;

  UsuarioData({
    this.id,
    this.fullName,
    this.username,
    this.email,
    this.role,
    this.profilePicUrl,
  });

  factory UsuarioData.fromDto(UsuarioDto dto) {
    return UsuarioData(
      id: dto.id,
      fullName: dto.fullName != null && dto.fullName!.isNotEmpty
          ? dto.fullName
          : null,
      username: dto.username,
      email: dto.email,
      role: dto.role,
      profilePicUrl: dto.profilePicUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'role': role,
      'profilePicUrl': profilePicUrl,
    };
  }

  @override
  String toString() {
    return 'UsuarioData{id: $id, fullName: $fullName, username: $username, email: $email, role: $role, profilePicUrl: $profilePicUrl}';
  }
}
