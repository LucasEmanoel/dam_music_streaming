
import 'package:dam_music_streaming/ui/core/ui/info_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/playlist_data.dart';
import '../view_model/playlist_view_model.dart';

class PlaylistSongs extends StatelessWidget {
  const PlaylistSongs({super.key});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Consumer<PlaylistViewModel>(
      builder: (context, vm, child) {

        final playlist = vm.entityBeingVisualized;

        return Scaffold(
          body: playlist == null
              ? const Center(child: Text('Nenhuma playlist selecionada.'))
              : CustomScrollView(
            slivers: [
              SliverAppBar.large(
                expandedHeight: 200.0,
                //floating: false,
                pinned: true, 
                elevation: 0,
                //backgroundColor: theme.scaffoldBackgroundColor,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.iconTheme.color, size: 25),
                  onPressed: () {
                    vm.setStackIndex(0);
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(


                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        playlist.urlCover ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[700],
                          );
                        },
                      ),

                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black87],
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              playlist.title ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              playlist.description ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Criado por: ${playlist.author}',
                                style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${playlist.duration} de duração',
                                style: const TextStyle(color: Color.fromARGB(255, 71, 71, 71), fontSize: 13),
                              ),
                            ],
                          ),
                          const Spacer(),
                          FloatingActionButton(
                            shape: const CircleBorder(),
                            child: const Icon(Icons.play_arrow, size: 30),
                            onPressed: () {},
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final song = playlist.songs?[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      child: Card(
                        color: theme.cardColor,
                        child: InfoTile(
                          imageUrl: song?.coverUrl ?? '',
                          title: song?.title ?? '',
                          subtitle: song?.artist ?? '',
                          trailing: const Icon(Icons.more_vert, size: 20),
                          onTap: () async {
                            vm.setStackIndex(2);
                          },
                        ),
                      ),
                    );
                  },
                  childCount: playlist.songs?.length ?? 0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deletePlaylist(BuildContext context, PlaylistData playlist, PlaylistViewModel vm) async {
    await vm.deletePlaylist(playlist.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
        content: Text("Contact deleted"),
      ),
    );
  }
}