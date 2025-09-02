import 'package:dam_music_streaming/domain/models/artist_data.dart';

class ArtistDto {
  int? id;
  String? name;
  String? pictureBig;

  ArtistDto({
    this.id,
    this.name,
    this.pictureBig,
  });

  factory ArtistDto.fromData(ArtistData data) {
    return ArtistDto(
      id: data.id,
      name: data.name,
      pictureBig: data.pictureBig,
    );
  }

  factory ArtistDto.fromMap(Map<String, dynamic> map) {
    return ArtistDto(
      id: map['id'],
      name: map['name'],
      pictureBig: map['picture_big'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Chave consistente com o 'fromMap'
      'name': name,
      'picture_big': pictureBig,
    };
  }
}