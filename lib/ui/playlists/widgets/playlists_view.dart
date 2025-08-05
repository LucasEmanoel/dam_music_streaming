import "dart:io";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../view_model/playlist_view_model.dart";
import "playlists_list_view.dart";
import "playlists_entry_view.dart";

class Playlist extends StatelessWidget {

  const Playlist({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlaylistViewModel>(
      create: (context) {
        final vm = PlaylistViewModel();
        vm.loadPlaylists();
        return vm;
      },
      child: Consumer<PlaylistViewModel>(
        builder: (context, vm, child) {
          return IndexedStack(
            index: vm.stackIndex,
            children: [
              PlaylistListView(),
              //PlaylistEntryView(),
            ],
          );
        },
      ),
    );
  }
}