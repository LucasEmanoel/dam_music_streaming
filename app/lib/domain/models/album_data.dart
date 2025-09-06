import 'package:dam_music_streaming/data/dto/album_dto.dart';
import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'artist_data.dart';

class AlbumData {
  int? id;
  String? title;
  String? urlCover;
  int? numSongs;

  Duration? duration;
  DateTime? releaseDate;
  ArtistData? artist;
  List<SongData>? songs;

  AlbumData({
    this.id,
    this.title,
    this.urlCover,
    this.numSongs,
    this.duration,
    this.releaseDate,
    this.artist,
    this.songs,
  });

  factory AlbumData.fromDto(AlbumDto dto) {
    return AlbumData(
      id: dto.id,
      title: dto.title,
      urlCover: dto.urlCover,
      numSongs: dto.numSongs,
      duration: dto.duration,
      releaseDate: dto.releaseDate,
      artist: dto.artist != null ? ArtistData.fromDto(dto.artist!) : null,
      songs: dto.songs?.map((s) => SongData.fromDto(s)).toList(),
    );
  }
}
