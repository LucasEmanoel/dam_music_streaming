import 'package:dam_music_streaming/data/dto/artist_dto.dart';
import 'package:dam_music_streaming/data/dto/song_dto.dart';
import 'package:dam_music_streaming/utils/duration_conversor.dart';

import '../../domain/models/album_data.dart';

class AlbumDto {
  int? id;
  String? title;
  String? urlCover;
  int? numTracks;

  Duration? duration;
  DateTime? releaseDate;
  ArtistDto? artist;

  List<SongDto>? tracks;

  AlbumDto({
    this.id,
    this.title,
    this.urlCover,
    this.numTracks,
    this.duration,
    this.releaseDate,
  });

  factory AlbumDto.fromData(AlbumData data) {
    return AlbumDto(
      id: data.id,
      title: data.title,
      urlCover: data.urlCover,
      numTracks: data.numTracks,
      duration: data.duration,
      releaseDate: data.releaseDate,
    );
  }

  factory AlbumDto.fromMap(Map<String, dynamic> map) {
    return AlbumDto(
      id: map['id'],
      title: map['title'],
      urlCover: map['url_cover'],
      numTracks: map['nb_tracks'],
      duration: map['duration'] != null ? parseIso8601Duration(map['duration']) : null,
      releaseDate: map['release_date'] != null
          ? DateTime.parse(map['release_date'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'cover_big': urlCover,
      'nb_tracks': numTracks,
      'duration': duration,
      'release_date': releaseDate,
    };
  }
}