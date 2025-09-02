import 'package:dam_music_streaming/ui/album/view_model/album_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AlbumSongs extends StatelessWidget {
  final int albumID;

  AlbumSongs({super.key, required this.albumID});

  @override
  Widget build(BuildContext context) {
    // Consome o ViewModel para obter a lista de álbuns
    final vm = context.watch<AlbumViewModel>();

    if (vm.isLoading && vm.albums.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: vm.albums.length,
      itemBuilder: (context, index) {
        final album = vm.albums[index];
        return GestureDetector(
          onTap: () {
            // Ao tocar, pede ao ViewModel para carregar os detalhes e mudar de tela
            vm.viewAlbum(album.id!);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(album.urlCover ?? '', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 8),
              Text(album.title ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(album.artist?.name ?? '', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        );
      },
    );
  }
}