import 'package:dam_music_streaming/domain/models/artist_data.dart';
import 'package:dam_music_streaming/ui/core/ui/album_tile.dart';
import 'package:dam_music_streaming/ui/core/ui/info_tile.dart';
import 'package:dam_music_streaming/ui/core/ui/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/artist_view_model.dart';

class ArtistDetailView extends StatelessWidget {
  final int artistId;

  const ArtistDetailView({super.key, required this.artistId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = ArtistViewModel();
        vm.viewArtist(artistId);
        return vm;
      },
      child: Consumer<ArtistViewModel>(
        builder: (context, vm, child) {
          final artist = vm.artistBeingViewed;

          if (vm.isLoading || artist == null) {
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
                  _buildHeader(context, artist),
                  _buildStats(context, artist),
                  _buildAlbums(context, artist),
                  _buildTopSongs(context, vm, artist),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ArtistData artist) {
    return Column(
      children: [
        Center(
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0, 6),
                  blurRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                artist.pictureBig ?? '',
                width: 180,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(width: 180, height: 180, color: Colors.grey),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Center(
            child: Text(
              artist.name ?? 'Artista Desconhecido',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Center(
            child: Text(
              'Descricao do artista',
              textAlign: TextAlign.start,
            ), //TODO: retornar na api
          ),
        ),
      ],
    );
  }

  Widget _buildStats(BuildContext context, ArtistData artist) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            '123.000 ouvintes mensais', //TODO: Nao entra no escopo
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            '14 álbums - 136 músicas lançadas',
          ), //TODO: retornar quantidade de albums / musicas.
        ],
      ),
    );
  }

  Widget _buildTopSongs(
    BuildContext context,
    ArtistViewModel vm,
    ArtistData artist,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Top Músicas",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: artist.songs?.length ?? 0,
            itemBuilder: (context, index) {
              final song = artist.songs?[index];

              if (song == null) {
                return Container();
              }

              return InfoTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    song.urlCover ?? '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.music_note),
                    ),
                  ),
                ),
                title: song.title ?? 'Música desconhecida',
                subtitle: 'Single', //TODO: alguma informacao util que nao seja o nome do artista
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => print('oi'),
                ),
                onTap: () {},
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAlbums(BuildContext context, ArtistData artist) {
    if (artist.albums == null || artist.albums!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Álbuns",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Ver todos',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: artist.albums?.length ?? 0,
              itemBuilder: (context, index) {
                final album = artist.albums?[index];

                if(album == null) {
                  return Container();
                }

                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 16.0),
                  child: MediaTile(
                    imageUrl: album.urlCover ?? '',
                    title: album.title ?? 'Álbum desconhecido',
                    subtitle: album.releaseDate?.year.toString() ?? '',
                    onTap: () {
                      print('Clicou no álbum:');
                    }
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
