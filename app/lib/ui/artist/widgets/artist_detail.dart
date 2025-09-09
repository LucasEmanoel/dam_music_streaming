import 'package:dam_music_streaming/data/services/genre_service.dart';
import 'package:dam_music_streaming/domain/models/artist_data.dart';
import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'package:dam_music_streaming/ui/album/view_model/album_view_model.dart';
import 'package:dam_music_streaming/ui/album/widgets/album_detail.dart';
import 'package:dam_music_streaming/ui/core/player/view_model/player_view_model.dart';
import 'package:dam_music_streaming/ui/core/ui/album_tile.dart';
import 'package:dam_music_streaming/ui/core/ui/button_sheet.dart';
import 'package:dam_music_streaming/ui/core/ui/custom_snack.dart';
import 'package:dam_music_streaming/ui/core/ui/info_tile.dart';
import 'package:dam_music_streaming/ui/core/ui/loading.dart';
import 'package:dam_music_streaming/ui/core/user/view_model/user_view_model.dart';
import 'package:dam_music_streaming/ui/genre/widgets/genre_detail.dart';
import 'package:dam_music_streaming/ui/player/widgets/player_view.dart';
import 'package:dam_music_streaming/ui/playlists/view_model/playlist_view_model.dart';
import 'package:dam_music_streaming/ui/playlists/widgets/playlist_add_song.dart';
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
        vm.viewDetailedArtist(artistId);
        return vm;
      },
      child: Consumer<ArtistViewModel>(
        builder: (context, vm, child) {
          final artist = vm.artistBeingViewed;
          final PlayerViewModel playerVM = context.watch<PlayerViewModel>();

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
                  _buildTopSongs(context, vm, playerVM, artist),
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
            '${artist.albums?.length ?? 0} álbums - ${artist.songs?.length ?? 0} músicas lançadas',
          ), //TODO: retornar quantidade de albums / musicas.
        ],
      ),
    );
  }

  Widget _buildTopSongs(
    BuildContext context,
    ArtistViewModel vm,
    PlayerViewModel playerVM,
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
                imageUrl: song.urlCover ?? '',
                title: song.title ?? 'Música desconhecida',
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _showSongActions(context, playerVM, song),
                ),
                onTap: () {
                  playerVM.playOneSong(song);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PlayerView()),
                  );
                },
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

                if (album == null) {
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
                      if (album.id != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AlbumDetailView(albumId: album.id!),
                          ),
                        );
                      }
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
}

void _showSongActions(
  BuildContext context,
  PlayerViewModel playerVM,
  SongData song,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InfoTile(
              imageUrl: song.urlCover ?? '',
              title: song.title ?? '',
              subtitle: song.artist?.name ?? '',
            ),
            const SizedBox(height: 20),
            ButtonCustomSheet(
              icon: 'Playlist',
              text: 'Adicionar a uma playlist',
              onTap: () {
                Navigator.pop(context);
                if (song.id == null) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider(
                      create: (context) {
                        final UserViewModel userViewModel = context
                            .read<UserViewModel>();
                        final playlistVm = PlaylistViewModel(userViewModel);
                        playlistVm.setSongToInsert(song.id!);
                        return playlistVm;
                      },
                      child: const AddSongToPlaylistView(),
                    ),
                  ),
                );
              },
            ),
            ButtonCustomSheet(
              icon: 'Genre',
              text: 'Ver gênero',
              onTap: () async {
                Navigator.pop(context);

                if (song.id == null) {
                  showCustomSnackBar(
                    context: context,
                    message: "Id da música inválido.",
                    backgroundColor: Colors.red,
                    icon: Icons.error,
                  );

                  return;
                }

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CustomLoadingIndicator()),
                );

                try {
                  final genre = await GenreApiService().fetchBySong(song.id!);
                  Navigator.pop(context);

                  if (genre == null) {
                    showCustomSnackBar(
                      context: context,
                      message: "Esta música não possui gênero associado.",
                      backgroundColor: Colors.red,
                      icon: Icons.error,
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GenreDetailPage(genreId: genre.id),
                    ),
                  );
                } catch (_) {
                  Navigator.pop(context);
                  showCustomSnackBar(
                    context: context,
                    message: "Falha ao carregar gênero.",
                    backgroundColor: Colors.red,
                    icon: Icons.error,
                  );
                }
              },
            ),
            ButtonCustomSheet(
              icon: 'Fila',
              iconColor: Colors.green,
              text: 'Adicionar à fila de reprodução',
              onTap: () {
                playerVM.addSongToQueue(song);
                Navigator.pop(context);
                showCustomSnackBar(
                  context: context,
                  message: 'Música adicionada a fila',
                  backgroundColor: Colors.green,
                  icon: Icons.check_circle,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
