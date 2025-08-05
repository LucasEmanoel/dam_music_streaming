import '../models/playlist_data.dart';

class MockPlaylists {
  static List<PlaylistData> playlists = [
    PlaylistData(
      id: 1,
      title: 'Rock Clássico',
      urlCover: 'https://placehold.co/300x300/E94560/FFFFFF?text=Rock',
      numSongs: 42,
      author: 'Spotify',
    ),
    PlaylistData(
      id: 2,
      title: 'Indie BR',
      urlCover: 'https://placehold.co/300x300/6C63FF/FFFFFF?text=Indie',
      numSongs: 25,
      author: 'Você',
    ),
    PlaylistData(
      id: 3,
      title: 'Eletrônica para Focar',
      urlCover: 'https://placehold.co/300x300/03DAC6/000000?text=Focus',
      numSongs: 128,
      author: 'HarmonyApp',
    ),
    PlaylistData(
      id: 4,
      title: 'Acústico',
      urlCover: 'https://placehold.co/300x300/FFC107/000000?text=Violão',
      numSongs: 33,
      author: 'Você',
    ),
    PlaylistData(
      id: 5,
      title: 'Top 50 Brasil',
      urlCover: 'https://placehold.co/300x300/4CAF50/FFFFFF?text=Top+BR',
      numSongs: 50,
      author: 'Spotify',
    ),
  ];

}