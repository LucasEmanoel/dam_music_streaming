import 'package:dam_music_streaming/domain/models/user_data_l.dart';

class UsuarioDto {
  final int id;
  final String? fullName;
  final String username;
  final String email;
  final String role;
  final String? profilePicUrl;

  UsuarioDto({
    required this.id,
    this.fullName,
    required this.username,
    required this.email,
    required this.role,
    this.profilePicUrl,
  });

  factory UsuarioDto.fromMap(Map<String, dynamic> map) {
    return UsuarioDto(
      id: map['id'] ?? -1,
      fullName: map['fullName'] ?? null,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      profilePicUrl: map['profilePictureUrl'] ?? '',
    );
  }

  factory UsuarioDto.fromData(UsuarioData data) {
    return UsuarioDto(
      id: data.id ?? -1,
      fullName: data.fullName ?? null,
      username: data.username ?? '',
      email: data.email ?? '',
      role: data.role ?? '',
      profilePicUrl: data.profilePicUrl ?? '',
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

  Map<String, dynamic> toProfileMap() {
    String? full_name = fullName == null || fullName!.isEmpty ? null : fullName;
    String? user_name = username.isEmpty ? null : username;
    String? profile_pic_url = profilePicUrl == null || profilePicUrl!.isEmpty
        ? null
        : profilePicUrl;

    return {
      'fullName': full_name,
      'username': user_name,
      'profilePictureUrl': profile_pic_url,
    };
  }
}
