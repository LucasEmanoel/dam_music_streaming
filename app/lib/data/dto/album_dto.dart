import 'package:dam_music_streaming/data/dto/artist_dto.dart';
import 'package:dam_music_streaming/data/dto/song_dto.dart';
import 'package:dam_music_streaming/domain/models/album_data.dart';
import 'package:dam_music_streaming/utils/duration_conversor.dart';

class AlbumDto {
  int id;
  String title;
  int numSongs;

  Duration? duration;
  DateTime? releaseDate;
  String? urlCover;
  ArtistDto? artist;
  List<SongDto>? songs;

  AlbumDto({
    required this.id,
    required this.title,
    required this.numSongs,
    this.duration,
    this.releaseDate,
    this.urlCover,
    this.artist,
    this.songs,
  });

  factory AlbumDto.fromMap(Map<String, dynamic> map) {
    return AlbumDto(
      id: map['id'] ?? -1,
      title: map['title'] ?? '',
      numSongs: map['nb_songs'] ?? 0,

      duration: map['duration'] != null
          ? parseIso8601Duration(map['duration'])
          : null,

      releaseDate: map['release_date'] != null
          ? DateTime.parse(map['release_date'])
          : null,

      urlCover: map['url_cover'],

      artist: map['artist'] != null
          ? ArtistDto.fromMap(map['artist'] as Map<String, dynamic>)
          : null,

      songs: (map['songs'] as List<dynamic>?)
          ?.map((s) => SongDto.fromMap(s as Map<String, dynamic>))
          .toList(),
    );
  }

  factory AlbumDto.fromData(AlbumData data) {
    return AlbumDto(
      id: data.id ?? -1,
      title: data.title ?? '',
      urlCover: data.urlCover,
      numSongs: data.numSongs ?? 0,
      duration: data.duration,
      releaseDate: data.releaseDate,
      artist: data.artist != null ? ArtistDto.fromData(data.artist!) : null,
      songs: data.songs?.map((s) => SongDto.fromData(s)).toList(),
    );
  }
}
