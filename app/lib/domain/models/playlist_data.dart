import 'package:dam_music_streaming/domain/models/music_data.dart';
import 'package:dam_music_streaming/domain/models/user_data_l.dart';

import '../../data/dto/playlist_dto.dart';

class PlaylistData {
   int? id;
   String? title;
   String? description;
   String? urlCover;
   int? numSongs;
   UsuarioData? author;
   String? duration;
   List<SongData>? songs;

  PlaylistData({
    this.id,
    this.title,
    this.description,
    this.urlCover,
    this.numSongs,
    this.author,
    this.duration,
    this.songs = const [],
  });

  factory PlaylistData.fromDto(PlaylistDto dto) {
    return PlaylistData(
      id: dto.id,
      title: dto.title,
      numSongs: dto.songs.length,
      songs: dto.songs.map((songDto) => SongData.fromDto(songDto)).toList(),
      description: dto.description ?? 'Descrição não disponível',
      urlCover: dto.urlCover ?? '',
        author: dto.author != null
            ? UsuarioData.fromDto(dto.author!)
            : UsuarioData(id: null, username: 'Autor desconhecido', email: '', role: ''),

        duration: dto.duration ?? '0'
    );
  }

   Map<String, dynamic> toMap() {
     return {
       'id': id,
       'title': title,
       'description': description,
       'urlCover': urlCover,
       'numSongs': numSongs,
       'author': author,
       'duration': duration,
       'songs': songs?.map((song) => song.toMap()).toList(),
     };
   }
}