import 'package:dam_music_streaming/data/dto/album_dto.dart';
import 'package:dam_music_streaming/data/dto/song_dto.dart';
import 'package:dam_music_streaming/domain/models/artist_data.dart';

class ArtistDto {
  int? id;
  String? name;
  String? pictureBig;
  List<AlbumDto>? albums;
  List<SongDto>? songs;


  ArtistDto({
    this.id,
    this.name,
    this.pictureBig,
    this.albums = const [],
    this.songs = const []
  });

  factory ArtistDto.fromData(ArtistData data) {
    return ArtistDto(
      id: data.id,
      name: data.name,
      pictureBig: data.pictureBig,
      albums: data.albums?.map((s) => AlbumDto.fromData(s)).toList(),
      songs: data.songs?.map((s) => SongDto.fromData(s)).toList(),
    );
  }

  factory ArtistDto.fromMap(Map<String, dynamic> map) {
    return ArtistDto(
      id: map['id'] ?? -1,
      name: map['name'] ?? '',
      pictureBig: map['picture_big'] ?? '',
      albums: (map['albums'] as List<dynamic>?)
          ?.map((s) => AlbumDto.fromMap(s as Map<String, dynamic>))
          .toList() ?? [],
      songs: (map['songs'] as List<dynamic>?)
          ?.map((s) => SongDto.fromMap(s as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}