import 'package:dam_music_streaming/domain/mock/playlist_mock.dart';
import 'package:dam_music_streaming/domain/models/playlist_data.dart';
import 'package:collection/collection.dart';

class PlaylistRepository {
  static late final PlaylistRepository db;

  Future<PlaylistData?> get(int id) async {
    try{
      return MockPlaylists.playlists.firstWhere((playlist) => playlist.id == id);
    } catch(e) {
      return PlaylistData(title: '', urlCover: '', author: '');
    }
  }
}