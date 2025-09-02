import 'package:dam_music_streaming/data/dto/artist_dto.dart';
import 'package:dam_music_streaming/data/dto/song_dto.dart';
import 'package:dam_music_streaming/utils/duration_conversor.dart';

import '../../domain/models/album_data.dart';

class AlbumDto {
  int? id;
  String? title;
  String? urlCover;
  int? numSongs;

  Duration? duration;
  DateTime? releaseDate;
  ArtistDto? artist;

  List<SongDto>? songs;

  AlbumDto({
    this.id,
    this.title,
    this.urlCover,
    this.numSongs,
    this.duration,
    this.releaseDate,
    this.songs
  });

  factory AlbumDto.fromData(AlbumData data) {
    return AlbumDto(
      id: data.id,
      title: data.title,
      urlCover: data.urlCover,
      numSongs: data.numSongs,
      duration: data.duration,
      releaseDate: data.releaseDate,
      songs: data.songs?.map((s) => SongDto.fromData(s)).toList(),
    );
  }

  factory AlbumDto.fromMap(Map<String, dynamic> map) {
    return AlbumDto(
      id: map['id'],
      title: map['title'],
      urlCover: map['url_cover'],
      numSongs: map['nb_songs'],
      duration: map['duration'] != null ? parseIso8601Duration(map['duration']) : null,
      releaseDate: map['release_date'] != null
          ? DateTime.parse(map['release_date'])
          : null,
      songs: (map['songs'] as List<dynamic>?)
          ?.map((s) => SongDto.fromMap(s as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'cover_big': urlCover,
      'nb_songs': numSongs,
      'duration': duration,
      'release_date': releaseDate,
      'songs': songs
    };
  }
}