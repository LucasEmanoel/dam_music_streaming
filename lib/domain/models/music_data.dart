import 'package:dam_music_streaming/data/dto/song_dto.dart';

class SongData {
  int? id;
  String apiId;
  String title;
  String artist;
  String album;
  String coverUrl;
  String localPath;

  SongData({
    this.id,
    required this.apiId,
    required this.title,
    required this.artist,
    required this.album,
    required this.coverUrl,
    required this.localPath,
  });

  factory SongData.fromDto(SongDto dto) {
    return SongData(
        id: dto.id,
        apiId: dto.apiId,
        title: dto.title,
        artist: dto.artist,
        album: dto.album,
        coverUrl: dto.coverUrl,
        localPath: dto.localPath
    );
  }
}