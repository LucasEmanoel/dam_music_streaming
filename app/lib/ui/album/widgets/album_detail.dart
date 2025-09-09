import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'package:dam_music_streaming/ui/core/ui/button_sheet.dart';
import 'package:dam_music_streaming/ui/core/ui/custom_snack.dart';
import 'package:dam_music_streaming/ui/core/ui/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/services/genre_service.dart';
import '../../core/ui/info_tile.dart';
import '../../genre/widgets/genre_detail.dart';
import '../view_model/album_view_model.dart';

class AlbumDetailView extends StatelessWidget {
  final int albumId;

  const AlbumDetailView({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = AlbumViewModel();
        vm.viewAlbum(albumId);
        return vm;
      },
      child: Consumer<AlbumViewModel>(
        builder: (context, vm, child) {
          final album = vm.albumBeingViewed;

          if (vm.isLoading || album == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: CustomLoadingIndicator()),
            );
          }

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                album.title ?? "Detalhes do Álbum",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              offset: Offset(0, 6),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            album.urlCover ?? '',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,

                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 150,
                                  height: 150,
                                  color: Colors.grey,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Center(
                      child: Text(
                        album.title ?? '',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 12),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.grey,
                                      child: ClipOval(
                                        child:
                                            (album.artist?.pictureBig != null &&
                                                album
                                                    .artist!
                                                    .pictureBig!
                                                    .isNotEmpty)
                                            ? Image.network(
                                                album.artist!.pictureBig!,
                                                fit: BoxFit.cover,
                                                width: 40.0,
                                                height: 40.0,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return const Icon(
                                                        Icons.person,
                                                        color: Colors.white,
                                                      );
                                                    },
                                              )
                                            : const Icon(
                                                // Fallback para quando a URL é nula ou vazia
                                                Icons.person,
                                                color: Colors.white,
                                              ),
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      album.artist?.name ??
                                          'Artista Desconhecido',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '12 músicas',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Duração',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              album.duration != null
                                  ? '${album.duration!.inMinutes}min e ${album.duration!.inSeconds.remainder(60)}s'
                                  : 'Duração indisponível',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: album.songs?.length ?? 0,
                      itemBuilder: (context, index) {
                        final song = album.songs?[index];

                        if (song == null) {
                          return Container();
                        }

                        return InfoTile(
                          imageUrl: song.urlCover ?? 'Sem imagem',
                          title: song.title ?? 'Sem titulo',
                          subtitle: song.artist?.name ?? 'Artista Desconhecido',
                          trailing: const Icon(Icons.more_vert, size: 20),
                          onTap: () async {
                            _showSongActions(context, vm, song);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void _showSongActions(BuildContext context, AlbumViewModel vm, SongData song) {
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
              icon: 'Profile',
              text: 'Ver Artista',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ButtonCustomSheet(
              icon: 'Playlist',
              text: 'Adicionar a playlist',
              onTap: () {
                Navigator.pop(context);
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
                  builder: (_) =>
                      const Center(child: CustomLoadingIndicator()),
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
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
