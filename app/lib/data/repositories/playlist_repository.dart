import 'package:dam_music_streaming/data/services/playlist_service.dart';

import '../../domain/models/playlist_data.dart';
import '../dto/playlist_dto.dart';

class PlaylistRepository {
  final PlaylistApiService api = PlaylistApiService();

  Future<List<PlaylistData>> getPlaylists() async {
    final List<PlaylistDto> playlists = await api.fetchPlaylists();
    return playlists.map((dto) => PlaylistData.fromDto(dto)).toList();
  }

  Future<PlaylistData> getPlaylistById(int id) async {
    final PlaylistDto dto = await api.getById(id);
    print('OQ VEM DO BAK');
    print(dto.toMap());
    return PlaylistData.fromDto(dto);
  }

  // Future<PlaylistData> createPlaylist(PlaylistData playlist) async {
  //   final PlaylistDto playlistDto = PlaylistDto.fromData(playlist);
  //   final PlaylistDto createdDto = await api.create(playlistDto);
  //   return PlaylistData.fromDto(createdDto);
  // }
  //
  // Future<PlaylistData> updatePlaylist(int id, PlaylistData playlist) async {
  //   final PlaylistDto playlistDto = PlaylistDto.fromData(playlist);
  //   final PlaylistDto updatedDto = await api.update(id, playlistDto);
  //   return PlaylistData.fromDto(updatedDto);
  // }

  Future<PlaylistData> addSongsToPlaylist(int id, List<int> songsIds) async{
    final PlaylistDto updatedDto = await api.postSongs(id, songsIds);
    return PlaylistData.fromDto(updatedDto);

  }

  Future<PlaylistData> getPlaylistWithSongs(int id) async{
    final PlaylistDto dto = await api.getById(id);
    print(dto.toMap());
    return PlaylistData.fromDto(dto);
  }

  Future<void> deletePlaylist(int id) async {
    await api.delete(id);
  }

}