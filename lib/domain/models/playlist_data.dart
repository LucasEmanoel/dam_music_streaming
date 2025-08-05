import 'package:dam_music_streaming/domain/models/music_data.dart';

import '../../data/dto/playlist_dto.dart';

class PlaylistData {
  final int? id;
  final String title;
  final String description;
  final String urlCover;
  final int? numSongs;
  final String author;
  final List<SongData> songs;

  PlaylistData({
    this.id,
    required this.title,
    required this.description,
    required this.urlCover,
    this.numSongs,
    required this.author,
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
      author: dto.author ?? 'Autor desconhecido',
    );
  }
}