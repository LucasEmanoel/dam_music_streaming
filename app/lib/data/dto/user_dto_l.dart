class UsuarioDto {
  int id;
  String username;
  String email;
  String role;

  UsuarioDto({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });

  factory UsuarioDto.fromMap(Map<String, dynamic> map) {
    return UsuarioDto(
      id: map['id'] ?? -1,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
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
