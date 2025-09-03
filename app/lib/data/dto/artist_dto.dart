import 'package:dam_music_streaming/data/dto/album_dto.dart';
import 'package:dam_music_streaming/data/dto/song_dto.dart';

class ArtistDto {
  int id;
  String name;
  String pictureBig;

  List<AlbumDto>? albums;
  List<SongDto>? songs;

  ArtistDto({
    required this.id,
    required this.name,
    required this.pictureBig,
    this.albums,
    this.songs,
  });

  factory ArtistDto.fromMap(Map<String, dynamic> map) {
    return ArtistDto(
      id: map['id'] ?? -1,
      name: map['name'] ?? '',
      pictureBig: map['picture_big'] ?? '',
      albums: (map['albums'] as List<dynamic>?)
          ?.map((s) => AlbumDto.fromMap(s as Map<String, dynamic>))
          .toList(),
      songs: (map['songs'] as List<dynamic>?)
          ?.map((s) => SongDto.fromMap(s as Map<String, dynamic>))
          .toList(),
    );
  }
}
