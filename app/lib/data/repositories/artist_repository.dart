import 'package:dam_music_streaming/data/dto/artist_dto.dart';
import 'package:dam_music_streaming/data/services/artist_service.dart';


import '../../domain/models/artist_data.dart';

class ArtistRepository {
  final ArtistApiService api = ArtistApiService();

  Future<ArtistData> fetchById(int id) async {
    final ArtistDto dto = await api.getById(id);
    return ArtistData.fromDto(dto);
  }
}