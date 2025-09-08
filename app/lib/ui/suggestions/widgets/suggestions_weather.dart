import 'package:dam_music_streaming/domain/models/playlist_data.dart';
import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'package:dam_music_streaming/ui/core/ui/album_tile.dart';
import 'package:dam_music_streaming/ui/core/ui/info_tile.dart';
import 'package:dam_music_streaming/ui/core/ui/loading.dart';
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
              appBar: AppBar(),
              body: const Center(child: CustomLoadingIndicator()),
            );
          }

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
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
        return _buildClearHeader();
      case 'CLOUDS':
        return _buildCloudsHeader();
      case 'SNOW':
        return _buildChillHeader();
      case 'RAIN':
        return _buildChillHeader();
      case 'DRIZZLE':
        return _buildChillHeader();
      case 'THUNDERSTORM': 
        return _buildHeavyMetalHeader();
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
                'assets/animations/foggy.json',
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

  Widget _buildChillHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Center(
              child: Lottie.asset(
                'assets/animations/storm.json',
                width: 150,
                height: 150,
                fit: BoxFit.fill,
                options: LottieOptions(enableMergePaths: true),
              ),
            ),
          ),
          Center(
            child: Text(
              "Está chovendo lá fora?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              "Relaxe com essas playlists",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClearHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Center(
              child: Lottie.asset(
                'assets/animations/foggy.json',
                width: 150,
                height: 150,
                fit: BoxFit.fill,
                options: LottieOptions(enableMergePaths: true),
              ),
            ),
          ),
          Center(
            child: Text(
              "O céu está limpo!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              "Aproveite o dia com essas playlists",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Center(
              child: Icon(
                Icons.wb_sunny,
                size: 150,
                color: Colors.orangeAccent,
              ),
            ),
          ),
          Center(
            child: Text(
              "O sol está brilhando!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              "Aproveite o dia com essas playlists",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeavyMetalHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Center(
              child: Icon(
                Icons.flash_on,
                size: 150,
                color: Colors.purpleAccent,
              ),
            ),
          ),
          Center(
            child: Text(
              "Tempestade chegando?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              "Prepare-se com essas playlists pesadas",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylists(BuildContext context, List<PlaylistData> playlists) {
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
                  print('Clicou na música:');
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
