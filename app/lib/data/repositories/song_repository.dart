import 'package:dam_music_streaming/data/dto/song_dto.dart';
import 'package:dam_music_streaming/data/services/playlist_service.dart';
import 'package:dam_music_streaming/domain/models/song_data.dart';

class SongRepository {
  final PlaylistApiService api = PlaylistApiService();

  Future<List<SongData>> searchSongs(String query) async {
    if (query.isEmpty) return [];

    List<SongDto> songs = await api.searchSongs(query);
    return songs.map((dto) => SongData.fromDto(dto)).toList();
  }
}