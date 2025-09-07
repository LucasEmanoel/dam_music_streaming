import 'package:dam_music_streaming/data/dto/album_dto.dart';
import 'package:dam_music_streaming/data/dto/artist_dto.dart';
import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'package:dam_music_streaming/utils/duration_conversor.dart';

class SongDto {
  int id;
  String title;

  ArtistDto? artist;
  String? urlCover;
  AlbumDto? album;
  Duration? duration;

  SongDto({
    required this.id,
    required this.title,
    this.artist,
    this.album,
    this.urlCover,
    this.duration,
  });

  factory SongDto.fromMap(Map<String, dynamic> map, {String? albumCoverUrl}) {
    
    String? coverFromAlbum = (map['album'] as Map<String, dynamic>?)?['url_cover'] as String?;

    final finalCoverUrl = coverFromAlbum ?? albumCoverUrl;
    
    return SongDto(
      id: map['id'] ?? -1,
      title: map['title'] ?? '',
      duration: map['duration'] != null
          ? parseIso8601Duration(map['duration'])
          : null,
      urlCover: finalCoverUrl,
      artist: map['artist'] != null
          ? ArtistDto.fromMap(map['artist'] as Map<String, dynamic>)
          : null,
      album: map['album'] != null
          ? AlbumDto.fromMap(map['album'] as Map<String, dynamic>)
          : null,
    );
  }

  factory SongDto.fromData(SongData data) {
    return SongDto(
      id: data.id ?? -1,
      title: data.title ?? '',
      artist: data.artist != null ? ArtistDto.fromData(data.artist!) : null,
      album: data.album != null ? AlbumDto.fromData(data.album!) : null,
      urlCover: data.urlCover ?? '',
    );
  }
}
