import "dart:io";
import "package:dam_music_streaming/ui/core/user/view_model/user_view_model.dart";
// import "package:dam_music_streaming/ui/playlists/widgets/playlist_add_song.dart";
import "package:dam_music_streaming/ui/playlists/widgets/playlist_songs.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../view_model/playlist_view_model.dart";
import "../view_model/search_view_model.dart";
import "playlists_list_view.dart";
import "playlists_entry_view.dart";

class PlaylistsView extends StatelessWidget {
  final Directory docsDir;
  const PlaylistsView({super.key, required this.docsDir});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlaylistViewModel>(
          create: (context) {
            final vm = PlaylistViewModel(userViewModel);
            vm.loadPlaylists();
            return vm;
          },
        ),
        ChangeNotifierProvider<SearchViewModel>(
          create: (context) => SearchViewModel(),
        ),
      ],
      child: Consumer<PlaylistViewModel>(
        builder: (context, vm, child) {
          return IndexedStack(
            index: vm.stackIndex,
            children: [
              PlaylistListView(),
              PlaylistEntryView(),
              PlaylistSongs(),
              // AddSongToPlaylistView(),
            ],
          );
        },
      ),
    );
  }
}
