import '../../data/dto/song_dto.dart';
import 'album_data.dart';
import 'artist_data.dart';

class SongData {
  int? id;
  String? title;
  String? md5Image;

  ArtistData? artist;
  AlbumData? album;

  SongData({
    this.id,
    this.title,
    this.artist,
    this.album,
    this.md5Image
  });

  factory SongData.fromDto(SongDto dto) {
    return SongData(
      id: dto.id ?? 0,
      title: dto.title,
      artist: dto.artist != null ? ArtistData.fromDto(dto.artist!) : null,
      album: dto.album != null ? AlbumData.fromDto(dto.album!) : null,
        md5Image: dto.md5Image
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'md5_image': md5Image,
      'artist_api_id': artist?.id,
      'album_api_id': album?.id,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SongData &&
              runtimeType == other.runtimeType &&
              title == other.title &&
              artist == other.artist;

  @override
  int get hashCode => title.hashCode;
}