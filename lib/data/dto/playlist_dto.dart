import 'package:dam_music_streaming/data/dto/song_dto.dart';

class PlaylistDto {
  final int id;
  final String title;
  final String description;
  final String urlCover;
  final int numSongs;
  final String author;
  final List<SongDto> songs;

  const PlaylistDto({
    required this.id,
    required this.title,
    required this.description,
    required this.urlCover,
    required this.numSongs,
    required this.author,
    this.songs = const [],
  });

  factory PlaylistDto.fromMap(Map<String, dynamic> map) {
    return PlaylistDto(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      urlCover: map['urlCover'] ?? '',
      numSongs: map['numSongs'] ?? 0,
      author: map['author'] ?? '',
      songs: (map['songs'] as List<dynamic>?)
          ?.map((song) => SongDto.fromMap(song as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}