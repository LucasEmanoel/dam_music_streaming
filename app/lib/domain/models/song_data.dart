import 'album_data.dart';
import 'artist_data.dart';
import '../../data/dto/song_dto.dart';

class SongData {
  int? id;
  String? title;
  String? urlCover;

  ArtistData? artist;
  AlbumData? album;

  SongData({
    this.id,
    this.title,
    this.urlCover,
    this.artist,
    this.album,
  });

  factory SongData.fromDto(SongDto dto) {
    return SongData(
      id: dto.id,
      title: dto.title,
      urlCover: dto.urlCover,
      artist: dto.artist != null ? ArtistData.fromDto(dto.artist!) : null,
      album: dto.album != null ? AlbumData.fromDto(dto.album!) : null,
    );
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

  get duration => null;
}
