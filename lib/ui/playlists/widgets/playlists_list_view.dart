import "package:dam_music_streaming/data/repositories/playlist_repository.dart";
import "package:dam_music_streaming/ui/playlists/widgets/playlists_view.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:flutter_slidable/flutter_slidable.dart";

import "../view_model/playlist_view_model.dart";

class PlaylistListView extends StatelessWidget{

  const PlaylistListView({super.key});

  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<PlaylistViewModel>(context, listen: false);
    final theme = Theme.of(context);

    return Consumer<PlaylistViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Minhas Playlists',
              style: const TextStyle(color: Color(0xFFB7B0B0), fontSize: 18),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add, color: theme.iconTheme.color),
                onPressed: () {
                  vm.startEditing();
                  vm.setStackIndex(1);
                },
              ),
            ],
            elevation: 0,
            backgroundColor: theme.scaffoldBackgroundColor,
          ),
          body: ListView.builder(
              itemCount: vm.playlists.length,
              itemBuilder: (context, index) {
                final playlist = vm.playlists[index];
                Color color = theme.cardColor;
                return Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Slidable(
                    key: ValueKey(playlist.id),
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                          backgroundColor: theme.colorScheme.error,
                          foregroundColor: theme.colorScheme.onError,
                          icon: Icons.delete,
                          label: 'Delete', onPressed: (BuildContext context) {  },
                        ),
                      ],
                    ),
                    child: Card(
                      color: theme.cardColor,
                      child: ListTile(
                        leading: Image.network(
                          playlist.urlCover,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,

                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              width: 50,
                              height: 50,
                              child: Icon(Icons.error_outline, color: Colors.red),
                            );
                          },

                        ),
                        title: Text(playlist.title),
                        subtitle: Text(
                          playlist.author,
                          style: const TextStyle(color: Color(0xFFB7B0B0)),
                        ),
                        onTap: () async {
                          vm.startEditing(playlist: playlist); //depois vou remover, esperando aprender fazer req em api
                          vm.setStackIndex(1);
                        },
                      ),
                    ),
                  ),
                );
              },
          ),
        );
      },
    );
  }
}