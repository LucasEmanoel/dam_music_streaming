import 'package:dam_music_streaming/data/dto/song_dto.dart';
import 'package:dam_music_streaming/data/dto/user_dto_l.dart';
import 'package:dam_music_streaming/utils/duration_conversor.dart';

class PlaylistDto {
  int id;
  String title;

  String? description;
  String? urlCover;
  int? numSongs;
  UsuarioDto? author;
  Duration? duration;
  List<SongDto>? songs;

  PlaylistDto({
    required this.id,
    required this.title,
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
      author: map['author'] != null
          ? UsuarioDto.fromMap(map['author'])
          : null,
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
      'url_cover': urlCover,
      'num_songs': numSongs,
      'duration': duration?.inSeconds, // exemplo
    };
  }
}
