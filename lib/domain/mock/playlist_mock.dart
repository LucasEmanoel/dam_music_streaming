import '../models/playlist_data.dart';

class MockPlaylists {
  static List<PlaylistData> playlists = [
    PlaylistData(
      id: 1,
      title: 'Rock Clássico',
      urlCover: 'https://www.udiscovermusic.com/wp-content/uploads/2015/09/rock_playlist_final.jpg',
      numSongs: 42,
      author: 'Spotify',
    ),
    PlaylistData(
      id: 2,
      title: 'Indie BR',
      urlCover: 'https://akamai.sscdn.co/uploadfile/letras/playlists/3/5/9/a/359a6ec667a7462bac230b3245792004.jpg',
      numSongs: 25,
      author: 'Você',
    ),
    PlaylistData(
      id: 3,
      title: 'Eletrônica para Focar',
      urlCover: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGN3xMiDc8lSUAF6BYja3yZb78E-LT2hHKBQ&s',
      numSongs: 128,
      author: 'HarmonyApp',
    ),
    PlaylistData(
      id: 4,
      title: 'Acústico',
      urlCover: 'https://discografia.discosdobrasil.com.br/storage/capas/DI00990.jpg',
      numSongs: 33,
      author: 'Você',
    ),
    PlaylistData(
      id: 5,
      title: 'Top 50 Brasil',
      urlCover: 'https://www.tupi.fm/wp-content/uploads/2024/02/WhatsApp-Image-2024-02-06-at-13.33.39-1.jpeg',
      numSongs: 50,
      author: 'Spotify',
    ),
  ];

}