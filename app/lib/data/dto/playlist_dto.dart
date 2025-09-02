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
  List<SongDto> songs;

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
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      urlCover: map['urlCover'] ?? '',
      numSongs: map['numSongs'],
      author: map['author'] != null
          ? UsuarioDto.fromMap(map['author'])
          : null,
      duration: map['duration'] != null ? parseIso8601Duration(map['duration']) : null,
      songs: (map['songs'] as List<dynamic>?)
          ?.map((song) => SongDto.fromMap(song as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  factory PlaylistDto.fromData(PlaylistData data) {
    return PlaylistDto(
      id: data.id, 
      title: data.title,
      description: data.description,
      urlCover: data.urlCover,
      
      numSongs: data.songs?.length ?? 0,
      
      author: data.author != null 
          ? UsuarioDto.fromData(data.author!) 
          : null,
          
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
      'author': author?.toMap(),
      'duration': duration,
      'songs': songs?.map((song) => song.toMap()).toList() ?? [],
    };
  }
}