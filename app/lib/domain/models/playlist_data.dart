import 'song_data.dart';
import 'user_data_l.dart';
import '../../data/dto/playlist_dto.dart';

class PlaylistData {
  int? id;
  String? title;
  String? description;
  String? urlCover;
  int? numSongs;
  UsuarioData? author;
  Duration? duration;
  List<SongData>? songs;

  PlaylistData({
    this.id,
    this.title,
    this.description,
    this.urlCover,
    this.numSongs,
    this.author,
    this.duration,
    this.songs,
  });

  factory PlaylistData.fromDto(PlaylistDto dto) {
    return PlaylistData(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      urlCover: dto.urlCover,
      numSongs: dto.songs?.length,
      duration: dto.duration,
      author: dto.author != null ? UsuarioData.fromDto(dto.author!) : null,
      songs: dto.songs?.map((s) => SongData.fromDto(s)).toList(),
    );
  }
}
