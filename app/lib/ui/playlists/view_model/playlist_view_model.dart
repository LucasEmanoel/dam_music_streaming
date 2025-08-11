import 'package:dam_music_streaming/data/dto/playlist_dto.dart';
import 'package:dam_music_streaming/data/services/playlist_service.dart';
import 'package:dam_music_streaming/domain/models/playlist_data.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import "package:path/path.dart";

class PlaylistViewModel extends ChangeNotifier {
  int _stackIndex = 0;
  List<PlaylistData> _playlists = [];
  List<PlaylistDto> _playlistsDto = [];
  PlaylistData? entityBeingVisualized;
  PlaylistData? entityBeingEdited;
  final Directory docsDir;

  PlaylistViewModel(this.docsDir);

  Future<void> loadPlaylists() async {
    try{
      _playlistsDto = await PlaylistApiService.listAll();
      _playlists = _playlistsDto.map((dto) => PlaylistData.fromDto(dto)).toList();

    } catch (e) {
      print('error: $e');
    } finally {
      notifyListeners();
    }
  }
  // serve para update e tbm para create
  Future<void> savePlaylist() async {
    if (entityBeingEdited == null) return;
    print(entityBeingEdited!.toMap());
    var dto = PlaylistDto.fromData(entityBeingEdited!);

    if (dto.id == null || dto.id!.isEmpty) {
      print('criar');
      var res = await PlaylistApiService.create(dto);

      _renameTempCover(res.id!);
    } else {
      print('atualizar');
      var res = await PlaylistApiService.update(dto.id!, dto);
      _renameTempCover(res.id!);
    }

    await loadPlaylists();
    setStackIndex(0);

  }
  Future<void> deletePlaylist(String id) async {
    if(entityBeingVisualized == null) return;

    try {
      final avatarFile = File(join(docsDir.path, id.toString()));
      if (avatarFile.existsSync()) avatarFile.deleteSync();

      await PlaylistApiService.delete(id);
      await loadPlaylists();

    } catch (e) {
        print('error: $e');
    } finally {
      notifyListeners();
      setStackIndex(0);
    }
  }

  int get stackIndex => _stackIndex;
  List<PlaylistData> get playlists => _playlists;
  void setStackIndex(int index) {
    _stackIndex = index;
    notifyListeners();
  }
  void startEditing({PlaylistData? playlist}){
    entityBeingEdited = playlist ?? PlaylistData(title: '', author: '', urlCover: '', numSongs: 0, description: '');
    notifyListeners();
  }
  void startView({PlaylistData? playlist}){
    entityBeingVisualized = playlist ?? PlaylistData(title: '', author: '', urlCover: '', numSongs: 0, description: '');
    notifyListeners();
  }
  void _renameTempCover(String id) {
    final coverFile = File(join(docsDir.path, "playlist_cover"));
    if (coverFile.existsSync()) {
      coverFile.renameSync(join(docsDir.path, id.toString()));
    }
  }
  void triggerRebuild() {
    notifyListeners();
  }
}