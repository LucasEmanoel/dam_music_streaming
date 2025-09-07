// lib/data/dto/genre_detail_dto.dart
import 'album_dto.dart';
import 'artist_dto.dart';
import 'song_dto.dart';

class GenreDetailDto {
  final GenreDto genre;
  final List<ArtistDto> topArtists;
  final List<AlbumDto> recentAlbums;
  final List<SongDto> topSongs;

  GenreDetailDto({
    required this.genre,
    required this.topArtists,
    required this.recentAlbums,
    required this.topSongs,
  });

  factory GenreDetailDto.fromMap(Map<String, dynamic> map) {
    final genreObj =
    (map['genre'] is Map) ? (map['genre'] as Map<String, dynamic>) : map;

    final artistsList = (map['topArtists'] ??
        map['artists'] ??
        const <dynamic>[]) as List<dynamic>;
    final albumsList = (map['recentAlbums'] ??
        map['recent_albums'] ??
        map['albums'] ??
        const <dynamic>[]) as List<dynamic>;
    final songsList = (map['topSongs'] ??
        map['top_songs'] ??
        map['songs'] ??
        const <dynamic>[]) as List<dynamic>;

    return GenreDetailDto(
      genre: GenreDto.fromMap(genreObj),
      topArtists: artistsList
          .map((a) => ArtistDto.fromMap(a as Map<String, dynamic>))
          .toList(),
      recentAlbums: albumsList
          .map((a) => AlbumDto.fromMap(a as Map<String, dynamic>))
          .toList(),
      topSongs: songsList
          .map((s) => SongDto.fromMap(s as Map<String, dynamic>))
          .toList(),
    );
  }
}

class GenreDto {
  final int id;
  final String name;
  final String? coverUrl;

  GenreDto({required this.id, required this.name, this.coverUrl});

  factory GenreDto.fromMap(Map<String, dynamic> map) {
    return GenreDto(
      id: map['id'] ?? -1,
      name: map['name'] ?? '',
      coverUrl: (map['coverUrl'] ?? map['url_cover']) as String?,
    );
  }
}
