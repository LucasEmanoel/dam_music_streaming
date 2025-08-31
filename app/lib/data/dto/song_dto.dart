import '../../domain/models/music_data.dart';

class SongDto {
  String? id;
  String? apiId;
  String? title;
  String? genre;
  String? artist;
  String? album;
  String? coverUrl;

  SongDto({
    this.id,
    this.apiId,
    this.title,
    this.genre,
    this.artist,
    this.album,
    this.coverUrl,
  });

  factory SongDto.fromMap(Map<String, dynamic> map) {
    return SongDto(
      id: map['id'] ?? '0',
      apiId: map['apiId'] ?? '',
      title: map['title'] ?? '',
      genre: map['genre'] ?? '',
      artist: map['artist'] ?? '',
      album: map['album'] ?? '',
      coverUrl: map['coverUrl'] ?? '',
    );
  }

  factory SongDto.fromData(SongData data) {
    return SongDto(
      id: data.id ?? '',
      title: data.title ?? '',
      artist: data.artist ?? '',
      album: data.album ?? '',
      coverUrl: data.coverUrl ?? '',
      apiId: data.apiId ?? '',
      genre: data.genre ?? '',
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