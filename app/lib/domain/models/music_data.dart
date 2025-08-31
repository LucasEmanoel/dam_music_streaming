import 'package:dam_music_streaming/data/dto/song_dto.dart';

class SongData {
  String? id;
  String? apiId;
  String? title;
  String? genre;
  String? artist;
  String? album;
  String? coverUrl;

  SongData({
    this.id,
    this.apiId,
    this.title,
    this.genre,
    this.artist,
    this.album,
    this.coverUrl,
  });

  factory SongData.fromDto(SongDto dto) {
    return SongData(
        id: dto.id,
        apiId: dto.apiId,
        title: dto.title,
        genre: dto.genre,
        artist: dto.artist,
        album: dto.album,
        coverUrl: dto.coverUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'apiId': apiId,
      'title': title,
      'genre': genre,
      'artist': artist,
      'album': album,
      'coverUrl': coverUrl,
    };
  }

}