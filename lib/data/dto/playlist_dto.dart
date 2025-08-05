import '../../domain/models/playlist_data.dart';

class PlaylistDto {
  final String id;
  final String title;
  final String urlCover;
  final int numSongs;
  final String author;

  const PlaylistDto({
    required this.id,
    required this.title,
    required this.urlCover,
    required this.numSongs,
    required this.author,
  });

  factory PlaylistDto.fromMap(Map<String, dynamic> map) {
    return PlaylistDto(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      urlCover: map['urlCover'] ?? '',
      numSongs: map['numSongs'] ?? 0,
      author: map['author'] ?? '',
    );
  }
}