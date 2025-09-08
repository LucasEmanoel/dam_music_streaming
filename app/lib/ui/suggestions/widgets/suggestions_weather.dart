import 'package:dam_music_streaming/domain/models/playlist_data.dart';
import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'package:dam_music_streaming/ui/album/widgets/album_detail.dart';
import 'package:dam_music_streaming/ui/artist/widgets/artist_detail.dart';
import 'package:dam_music_streaming/ui/core/player/view_model/player_view_model.dart';
import 'package:dam_music_streaming/ui/core/ui/album_tile.dart';
import 'package:dam_music_streaming/ui/core/ui/button_sheet.dart';
import 'package:dam_music_streaming/ui/core/ui/custom_snack.dart';
import 'package:dam_music_streaming/ui/core/ui/info_tile.dart';
import 'package:dam_music_streaming/ui/core/ui/loading.dart';
import 'package:dam_music_streaming/ui/playlists/view_model/playlist_view_model.dart';
import 'package:dam_music_streaming/ui/playlists/widgets/playlist_songs.dart';
import 'package:dam_music_streaming/ui/profile/widgets/profile_show_view.dart';
import 'package:dam_music_streaming/ui/suggestions/view_model/sugestions_view_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class WeatherSuggestionsView extends StatelessWidget {
  const WeatherSuggestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = SuggestionsViewModel();
        vm.getSuggestionsByWeather();
        return vm;
      },

      child: Consumer<SuggestionsViewModel>(
        builder: (context, vm, child) {
          final playlists = vm.playlists;

          if (vm.isLoading) {
            return Scaffold(
              appBar: AppBar(
                leading: Container(),
                backgroundColor: Colors.transparent
              ),
              body: const Center(child: CustomLoadingIndicator()),
            );
          }

          return Scaffold(
            appBar: AppBar(
              leading: Container(),
              title: Center(
                child: Text(
                  'Sugestões do Clima',
                  style: TextStyle(color: Color(0xFFB7B0B0), fontSize: 18),
                ),
              ),
              actions: [Container(width: 48, height: 48)],
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, vm),
                  _buildPlaylists(context, playlists),
                  _buildSongs(context, vm.songs),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, SuggestionsViewModel vm) {
    if (vm.currentWeather == null) {
      return Container();
    }

    switch (vm.currentWeather) {
      case 'CLEAR':
        return _buildWeatherHeader('assets/animations/foggy.json', 'Dia ensolarado', 'Aproveite o sol com essas playlists!');
      case 'CLOUDS':
        return _buildWeatherHeader('assets/animations/windy.json', 'Dia nublado', 'Um dia perfeito para relaxar com música.');
      case 'SNOW':
        return _buildWeatherHeader('assets/animations/snow.json', 'Dia de neve', 'Aqueça-se com essas músicas aconchegantes.');
      case 'RAIN':
        return _buildWeatherHeader('assets/animations/rain.json', 'Dia de chuva', 'Perfeito para ouvir músicas calmas.');
      case 'DRIZZLE':
        return _buildWeatherHeader('assets/animations/rain.json', 'Dia de garoa', 'Uma trilha sonora suave para um dia tranquilo.');
      case 'THUNDERSTORM':
        return _buildWeatherHeader('assets/animations/storm.json', 'Dia de tempestade', 'Aproveite a intensidade com essas músicas.');
      default:
        return Container();
    }
  }

  Widget _buildCloudsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Center(
              child: Lottie.asset(
                'assets/animations/snow.json',
                width: 150,
                height: 150,
                fit: BoxFit.fill,
                options: LottieOptions(enableMergePaths: true),
              ),
            ),
          ),
          Center(
            child: Text(
              "Que clima agradavel!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              "Aproveite o dia com essas playlists e músicas",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherHeader(String animationFile, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Center(
              child: Lottie.asset(
                animationFile,
                width: 150,
                height: 150,
                fit: BoxFit.fill,
                options: LottieOptions(enableMergePaths: true),
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              subtitle,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPlaylists(BuildContext context, List<PlaylistData> playlists) {

    if (playlists.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Playlists para você",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                "Nenhuma playlist disponível para o clima atual.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sugestões para você",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];

                if (playlist == null) {
                  return Container();
                }

                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 16.0),
                  child: MediaTile(
                    imageUrl: playlist.urlCover ?? '',
                    title: playlist.title ?? 'Playlist desconhecida',
                    subtitle: playlist.description ?? '',
                    onTap: () {
                      print('Clicou na playlist:');
                      _showPlaylistActions(context, playlist);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongs(BuildContext context, List<SongData> songs) {

    if (songs.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Músicas para você",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                "Nenhuma música disponível para o clima atual.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Músicas para você",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];

              if (song == null) {
                return Container();
              }

              return InfoTile(
                imageUrl: song.urlCover ?? '',
                title: song.title ?? 'Música desconhecida',
                subtitle: song.title ?? '',
                onTap: () {
                  _showSongActions(context, song);
                  print('Clicou na música:');
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _showPlaylistActions(BuildContext context, PlaylistData playlist) {
    
    

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        //final playlistViewModel = context.read<PlaylistViewModel>();
        
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InfoTile(
                imageUrl: playlist.urlCover ?? '',
                title: playlist.title ?? '',
                subtitle: playlist.description ?? '',
              ),
              SizedBox(height: 20),
              ButtonCustomSheet(
                icon: 'Profile',
                text: 'Ver Author',
                onTap: () => {},
                /* // chamar tela de visualizar perfil
                onTap: () {
                  Navigator.pop(context);
                  if (playlist.author != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            //ProfileShowView(artistId: playlist.author!.id ?? -1),
                      ),
                    );
                  }
                },*/
              ),
              ButtonCustomSheet(
                icon: 'Music',
                text: 'Ver Musicas',
                onTap: () {
                  if (playlist.id != null) {
                    //playlistViewModel.entityBeingVisualized = playlist;
                    
                    //Navigator.push(
                    //  context,
                    //  MaterialPageRoute(
                    //    builder: (context) => const PlaylistSongs(),
                    //  ),
                    //);
                  }
                },
              ),
              ButtonCustomSheet(
                icon: 'Fila',
                iconColor: Colors.green,
                text: 'Adicionar a fila de reprodução',
                onTap: () {
                  for (var song in playlist.songs ?? []) {
                    print(' SONGGGGGGSSS ${song.deezerId}');
                  }
                  Navigator.pop(context);
                  if (playlist.songs != null && playlist.songs!.isNotEmpty) {
                    final vm = Provider.of<PlayerViewModel>(
                      context,
                      listen: false,
                    );

                    vm.addListToQueue(list: playlist.songs!);
                    vm.play(playlist.songs![0]);
                  } else {
                    showCustomSnackBar( // acho que nunca vai acontecer
                      context: context,
                      message: 'A playlist está vazia.',
                      backgroundColor: Colors.red,
                      icon: Icons.error,
                    );

                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSongActions(BuildContext context, SongData song) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InfoTile(
                imageUrl: song.urlCover ?? '',
                title: song.title ?? '',
                subtitle: song.artist?.name ?? '',
              ),
              SizedBox(height: 20),

              ButtonCustomSheet(
                icon: 'Song',
                iconColor: Colors.green,
                text: 'Tocar agora',
                onTap: () {
                  if (song != null) {
                    final vm = Provider.of<PlayerViewModel>(
                      context,
                      listen: false,
                    );
                    vm.playOneSong(song);
                    Navigator.pop(context);
                  }
                },
              ),
              ButtonCustomSheet(
                icon: 'Profile',
                text: 'Ver Author', // chamar tela de visualizar perfil
                onTap: () {
                  Navigator.pop(context);
                  if (song.artist != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ArtistDetailView(artistId: song.artist!.id ?? -1),
                      ),
                    );
                  }
                },
              ),
              ButtonCustomSheet(
                icon: 'Album',
                text: 'Ver Álbum',
                onTap: () {
                  Navigator.pop(context);
                  if (song.album != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AlbumDetailView(albumId: song.album!.id ?? -1),
                      ),
                    );
                  }
                },
              ),
              ButtonCustomSheet(
                icon: 'Fila',
                iconColor: Colors.green,
                text: 'Adicionar a fila de reprodução',
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}
