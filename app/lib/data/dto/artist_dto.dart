import 'package:dam_music_streaming/data/dto/album_dto.dart';
import 'package:dam_music_streaming/data/dto/song_dto.dart';
import 'package:dam_music_streaming/domain/models/artist_data.dart';

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
      pictureBig: map['artistImage'] ?? '',
      albums: (map['albums'] as List<dynamic>?)
          ?.map((s) => AlbumDto.fromMap(s as Map<String, dynamic>))
          .toList(),
      songs: (map['songs'] as List<dynamic>?)
          ?.map((s) => SongDto.fromMap(s as Map<String, dynamic>))
          .toList(),
    );
  }
  factory ArtistDto.fromData(ArtistData data) {
    return ArtistDto(
      id: data.id ?? -1,
      name: data.name ?? '',
      pictureBig: data.pictureBig ?? '',
      albums: data.albums?.map((s) => AlbumDto.fromData(s)).toList(),
      songs: data.songs?.map((s) => SongDto.fromData(s)).toList(),
    );
  }
}
