import 'album_data.dart';
import 'song_data.dart';
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
    this.songs,
  });

  factory ArtistData.fromDto(ArtistDto dto) {
    return ArtistData(
      id: dto.id,
      name: dto.name,
      pictureBig: dto.pictureBig,
      albums: dto.albums?.map((a) => AlbumData.fromDto(a)).toList(),
      songs: dto.songs?.map((s) => SongData.fromDto(s)).toList(),
    );
  }
}
