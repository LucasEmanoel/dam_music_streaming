class GenreListDto {
  final int id;
  final String name;
  final String? coverUrl;
  GenreListDto({required this.id, required this.name, this.coverUrl});

  factory GenreListDto.fromMap(Map<String, dynamic> m) => GenreListDto(
    id: m['id'] ?? -1,
    name: m['name'] ?? '',
    coverUrl: m['cover_url'] ?? m['urlCover'],
  );
}
