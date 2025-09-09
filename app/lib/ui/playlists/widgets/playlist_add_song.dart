import 'package:dam_music_streaming/domain/models/playlist_data.dart';
import 'package:dam_music_streaming/ui/core/ui/custom_snack.dart';
import 'package:dam_music_streaming/ui/core/ui/info_tile.dart';
import 'package:dam_music_streaming/ui/core/ui/loading.dart';
import 'package:dam_music_streaming/ui/playlists/view_model/playlist_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddSongToPlaylistView extends StatelessWidget {
  const AddSongToPlaylistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistViewModel>(
      builder: (context, vm, child) {
        final userPlaylists = vm.playlists;

        return Scaffold(
          appBar: AppBar(
            title: Text("Salvar"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  vm.setStackIndex(2);
                }
                vm.clearPlaylistSelections();
              },
            ),
          ),
          body: vm.isLoading
              ? const Center(child: CustomLoadingIndicator())
              : userPlaylists.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "Você ainda não criou nenhuma playlist.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: userPlaylists.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final playlist = userPlaylists[index];
                    final isChecked = vm.selectedPlaylistIds.contains(playlist);

                    return InfoTile(
                      title: playlist.title ?? 'Playlist sem nome',
                      subtitle: '${playlist.numSongs ?? 0} músicas',
                      imageUrl: playlist.urlCover ?? '',
                      trailing: Checkbox(
                        value: isChecked,
                        onChanged: (value) =>
                            vm.togglePlaylistSelection(playlist),
                      ),
                      onTap: () => vm.togglePlaylistSelection(playlist),
                    );
                  },
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: vm.selectedPlaylistIds.isEmpty
              ? null
              : FloatingActionButton.extended(
                  onPressed: () async {
                    if (vm.songToInsertId != null) {
                      await vm.addSongToSelectedPlaylists(
                        songId: vm.songToInsertId,
                      );

                      showCustomSnackBar(
                        context: context,
                        icon: Icons.check_circle_outline,
                        message: 'Música adicionada com sucesso!',
                        backgroundColor: Colors.green,
                      );

                      vm.clearPlaylistSelections();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        vm.setStackIndex(2);
                      }
                    }
                  },
                  label: const Text('Salvar'),
                  icon: const Icon(Icons.check),
                ),
        );
      },
    );
  }
}
