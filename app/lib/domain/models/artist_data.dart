import '../../data/dto/artist_dto.dart';

class ArtistData {
  int? id;
  String? name;
  String? pictureBig;

  ArtistData({
    this.id,
    this.name,
    this.pictureBig,
  });

  factory ArtistData.fromDto(ArtistDto dto) {
    return ArtistData(
      id: dto.id ?? 0,
      name: dto.name,
      pictureBig: dto.pictureBig,
    );
  }
}