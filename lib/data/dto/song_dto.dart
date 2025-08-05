class SongDto {
  final int id;
  final String apiId;
  final String title;
  final String artist;
  final String album;
  final String coverUrl;
  final String localPath;

  const SongDto({
    required this.id,
    required this.apiId,
    required this.title,
    required this.artist,
    required this.album,
    required this.coverUrl,
    required this.localPath,
  });

  factory SongDto.fromMap(Map<String, dynamic> map) {
    return SongDto(
      id: map['id'] ?? 0,
      apiId: map['apiId'] ?? '',
      title: map['title'] ?? '',
      artist: map['artist'] ?? '',
      album: map['album'] ?? '',
      coverUrl: map['coverUrl'] ?? '',
      localPath: map['localPath'] ?? '',
    );
  }
}