import 'package:flutter_test/flutter_test.dart';
import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'package:dam_music_streaming/domain/models/artist_data.dart';
import 'package:dam_music_streaming/domain/models/album_data.dart';
import 'package:dam_music_streaming/data/dto/song_dto.dart';
import 'package:dam_music_streaming/data/dto/artist_dto.dart';
import 'package:dam_music_streaming/data/dto/album_dto.dart';

void main() {
  group('SongData', () {

    test('deve criar data a partir de DTO', () {

      final artistDto = ArtistDto(
        id: 1, 
        name: 'Test Artist', 
        pictureBig: 'https://example.com/artist.jpg'
      );

      final albumDto = AlbumDto(
        id: 1, 
        title: 'Test Album', 
        numSongs: 10
      );

      final songDto = SongDto(
        id: 1,
        deezerId: 12345,
        title: 'Test Song',
        urlCover: 'https://example.com/cover.jpg',
        artist: artistDto,
        album: albumDto,
      );

      final songData = SongData.fromDto(songDto);

      expect(songData.id, equals(1));
      expect(songData.deezerId, equals(12345));
      expect(songData.title, equals('Test Song'));
      expect(songData.urlCover, equals('https://example.com/cover.jpg'));
      expect(songData.artist?.id, equals(1));
      expect(songData.artist?.name, equals('Test Artist'));
      expect(songData.album?.id, equals(1));
      expect(songData.album?.title, equals('Test Album'));
    });
  });
}
