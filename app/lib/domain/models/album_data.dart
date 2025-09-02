import 'package:dam_music_streaming/domain/models/artist_data.dart';

import '../../data/dto/album_dto.dart';
import 'song_data.dart';

class AlbumData {
  int? id;
  String? title;
  String? urlCover;
  int? numSongs;
  ArtistData? artist;
  Duration? duration;
  DateTime? releaseDate;
  List<SongData>? songs;

  AlbumData({
    this.id,
    this.title,
    this.urlCover,
    this.numSongs,
    this.artist,
    this.duration,
    this.releaseDate,
    this.songs,
  });

  factory AlbumData.fromDto(AlbumDto dto) {
    return AlbumData(
      id: dto.id ?? -1,
      title: dto.title,
      urlCover: dto.urlCover,
      numSongs: dto.numSongs,
      duration: dto.duration != null ? dto.duration! : null,
      releaseDate: dto.releaseDate != null ? dto.releaseDate! : null,
      songs: dto.songs?.map((song) => SongData.fromDto(song)).toList(),
    );
  }

}