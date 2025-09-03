import 'package:dam_music_streaming/data/dto/song_dto.dart';
import 'package:dam_music_streaming/data/dto/user_dto_l.dart';
import 'package:dam_music_streaming/utils/duration_conversor.dart';

import '../../domain/models/playlist_data.dart';

class PlaylistDto {
  int? id;
  String? title;
  String? description;
  String? urlCover;
  int? numSongs;
  UsuarioDto? author;
  Duration? duration;
  List<SongDto>? songs;

  PlaylistDto({
    this.id,
    this.title,
    this.description,
    this.urlCover,
    this.numSongs,
    this.author,
    this.duration,
    this.songs = const [],
  });

  factory PlaylistDto.fromMap(Map<String, dynamic> map) {
    return PlaylistDto(
      id: map['id'] ?? -1,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      urlCover: map['urlCover'] ?? '',
      numSongs: map['numSongs'] ?? -1,
      author: map['author'] != null
          ? UsuarioDto.fromMap(map['author'])
          : UsuarioDto(),
      duration: map['duration'] != null 
          ? parseIso8601Duration(map['duration']) 
          : Duration(seconds: 0),
      songs: (map['songs'] as List<dynamic>?)
        ?.map((e) => SongDto.fromMap(e))
        .toList() 
        ?? []
    );
  }

  factory PlaylistDto.fromData(PlaylistData data) {
    return PlaylistDto(
      id: data.id , 
      title: data.title,
      description: data.description,
      urlCover: data.urlCover,
      numSongs: data.songs?.length ?? 0,
      
      author: data.author != null 
          ? UsuarioDto.fromData(data.author!) 
          : UsuarioDto(),
          
      duration: data.duration,
      songs: data.songs != null
          ? data.songs!.map((songData) => SongDto.fromData(songData)).toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'urlCover': urlCover,
      'numSongs': numSongs,
      'duration': duration,
    };
  }
}