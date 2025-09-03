import 'package:dam_music_streaming/domain/models/album_data.dart';
import 'package:dam_music_streaming/domain/models/song_data.dart';

import '../../data/dto/artist_dto.dart';

class ArtistData {
  int? id;
  String? name;
  String? pictureBig;
  List<AlbumData>? albums;
  List<SongData>? songs;

  ArtistData({
    this.id,
    this.name,
    this.pictureBig,
    this.albums,
    this.songs
  });

  factory ArtistData.fromDto(ArtistDto dto) {
    return ArtistData(
      id: dto.id ?? 0,
      name: dto.name,
      pictureBig: dto.pictureBig,
      albums: dto.albums?.map((a) => AlbumData.fromDto(a)).toList(),
      songs: dto.songs?.map((song) => SongData.fromDto(song)).toList(),
    );
  }
}