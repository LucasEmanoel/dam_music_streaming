import 'package:dam_music_streaming/data/dto/song_dto.dart';
import 'package:dam_music_streaming/data/dto/user_dto_l.dart';
import 'package:dam_music_streaming/domain/models/playlist_data.dart';
import 'package:dam_music_streaming/utils/duration_conversor.dart';

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
    this.songs,
  });

  factory PlaylistDto.fromMap(Map<String, dynamic> map) {
    return PlaylistDto(
      id: map['id'] ?? -1,
      title: map['title'] ?? '',
      description: map['description'],
      urlCover: map['url_cover'],
      numSongs: map['nb_songs'],
      author: map['author'] != null ? UsuarioDto.fromMap(map['author']) : null,
      duration: map['duration'] != null
          ? parseIso8601Duration(map['duration'])
          : null,
      songs: (map['songs'] as List<dynamic>?)
          ?.map((e) => SongDto.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url_cover': urlCover
    };
  }

  factory PlaylistDto.fromData(PlaylistData data) {
    return PlaylistDto(
      id: data.id,
      title: data.title ?? '',
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
}
