import '../../data/dto/song_dto.dart';
import 'album_data.dart';
import 'artist_data.dart';

class SongData {
  int? id;
  String? title;
  String? urlCover;

  ArtistData? artist;
  AlbumData? album;

  SongData({this.id, this.title, this.artist, this.album, this.urlCover});

  factory SongData.fromDto(SongDto dto) {
    return SongData(
      id: dto.id ?? 0,
      title: dto.title,
      artist: dto.artist != null
          ? ArtistData.fromDto(dto.artist!)
          : ArtistData(),
      album: dto.album != null ? AlbumData.fromDto(dto.album!) : AlbumData(),
      urlCover: dto.urlCover,
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
}
