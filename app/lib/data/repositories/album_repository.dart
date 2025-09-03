import 'package:dam_music_streaming/data/dto/album_dto.dart';
import 'package:dam_music_streaming/data/services/album_service.dart';
import 'package:dam_music_streaming/domain/models/album_data.dart';

class AlbumRepository {
  final AlbumApiService api = AlbumApiService();

  Future<AlbumData> fetchById(int id) async {
    final AlbumDto dto = await api.getById(id);
    return AlbumData.fromDto(dto);
  }
}