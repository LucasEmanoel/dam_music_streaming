import 'package:dam_music_streaming/data/dto/album_dto.dart';
import 'package:dam_music_streaming/data/dto/artist_dto.dart';
import 'package:dam_music_streaming/utils/duration_conversor.dart';
import '../../domain/models/song_data.dart';

class SongDto {
  int? id;
  String? title;
  ArtistDto? artist;
  String? urlCover;
  AlbumDto? album;
  Duration? duration;

  SongDto({
    this.id,
    this.title,
    this.artist,
    this.album,
    this.urlCover,
    this.duration
  });

  factory SongDto.fromData(SongData data) {
    return SongDto(
      id: data.id,
      title: data.title ?? '',
      artist: data.artist != null
          ? ArtistDto.fromData(data.artist!)
          : ArtistDto(),
      album: data.album != null
          ? AlbumDto.fromData(data.album!)
          : AlbumDto(),
      urlCover: data.urlCover ?? '',
    );
  }

  factory SongDto.fromMap(Map<String, dynamic> map) {
    return SongDto(
      id: map['id'] ?? -1,
      title: map['title'] ?? '',
      duration: map['duration'] != null 
        ? parseIso8601Duration(map['duration']) 
        : Duration(seconds: 0),
      artist: map['artist'] != null
          ? ArtistDto.fromMap(map['artist'] as Map<String, dynamic>)
          : ArtistDto(),
      album: map['album'] != null
          ? AlbumDto.fromMap(map['album'] as Map<String, dynamic>)
          : AlbumDto(),
      urlCover: map['url_cover'] ?? '',
    );
  }

}