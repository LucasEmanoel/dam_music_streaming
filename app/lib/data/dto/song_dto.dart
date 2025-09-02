import 'package:dam_music_streaming/data/dto/album_dto.dart';
import 'package:dam_music_streaming/data/dto/artist_dto.dart';
import 'package:dam_music_streaming/utils/duration_conversor.dart';
import '../../domain/models/song_data.dart';

class SongDto {
  int? id;
  String? title;
  ArtistDto? artist;
  String? md5Image;
  AlbumDto? album;
  Duration? duration;

  SongDto({
    this.id,
    this.title,
    this.artist,
    this.album,
    this.md5Image,
    this.duration
  });

  factory SongDto.fromData(SongData data) {
    return SongDto(
      id: data.id,
      title: data.title ?? '',
      artist: data.artist != null
          ? ArtistDto.fromData(data.artist!)
          : null,
      album: data.album != null
          ? AlbumDto.fromData(data.album!)
          : null,
      md5Image: data.md5Image ?? '',
    );
  }

  factory SongDto.fromMap(Map<String, dynamic> map) {
    final imageHash = map['album']?['md5_image'] ?? map['md5_image'];

    return SongDto(
      id: map['id'],
      title: map['title'],
      duration: map['duration'] != null ? parseIso8601Duration(map['duration']) : null,
      artist: map['artist'] != null
          ? ArtistDto.fromMap(map['artist'] as Map<String, dynamic>)
          : null,
      album: map['album'] != null
          ? AlbumDto.fromMap(map['album'] as Map<String, dynamic>)
          : null,
      md5Image: imageHash,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'artist': artist?.toMap(),
      'album': album?.toMap(),
      'md5_image': md5Image,
    };
  }

  @override
  String toString() {
    return 'SongDto(apiId: $id, title: "$title", artist: "${artist?.name}")';
  }
}