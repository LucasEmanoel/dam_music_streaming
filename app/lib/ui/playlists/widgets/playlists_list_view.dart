import "package:dam_music_streaming/domain/models/playlist_data.dart";
import "package:dam_music_streaming/ui/core/ui/button_sheet.dart";
import "package:dam_music_streaming/ui/core/ui/loading.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../core/ui/confirm_dialog.dart";
import "../../core/ui/info_tile.dart";
import "../view_model/playlist_view_model.dart";

class PlaylistListView extends StatelessWidget {
  const PlaylistListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<PlaylistViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) {
          return Scaffold(body: Center(child: CustomLoadingIndicator()));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Minhas Playlists',
              style: TextStyle(color: Color(0xFFB7B0B0), fontSize: 18),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add, color: theme.iconTheme.color, size: 25),
                onPressed: () {
                  vm.startEditing();
                  vm.setStackIndex(1);
                },
              ),
            ],
            elevation: 0,
            backgroundColor: theme.scaffoldBackgroundColor,
          ),
          body: vm.playlists.isEmpty
              ? Center(
                  child: Text(
                    'Nenhuma playlist encontrada.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: vm.playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = vm.playlists[index];
                    return Card(
                      color: theme.cardColor,
                      child: InfoTile(
                        imageUrl: playlist.urlCover ?? '',
                        title: playlist.title ?? '',
                        subtitle: playlist.description ?? '',
                        onTap: () {
                          vm.startView(id: playlist.id!);
                          vm.setStackIndex(2);
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () =>
                              _showPlaylistActions(context, vm, playlist),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  //TODO: colocar para gerar um component de modal universal, ai poderemos abrir em varias telas.
  void _showPlaylistActions(
    BuildContext context,
    PlaylistViewModel vm,
    PlaylistData playlist,
  ) {

    vm.entityBeingVisualized = playlist;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InfoTile(
                imageUrl: playlist.urlCover ?? '',
                title: playlist.title ?? '',
                subtitle: playlist.description ?? '',
              ),
              SizedBox(height: 20),
              ButtonCustomSheet(
                icon: 'Profile',
                text: 'Ver Author', // chamar tela de visualizar perfil
                onTap: () {},
              ),
              ButtonCustomSheet(
                icon: 'Music',
                text: 'Ver Musicas',
                onTap: () {
                  Navigator.pop(context);
                  vm.startView(id: playlist.id!);
                  vm.setStackIndex(2);
                },
              ),
              ButtonCustomSheet(
                icon: 'Edit',
                text: 'Editar playlist',
                onTap: () {
                  Navigator.pop(context);
                  _editPlaylist(context, playlist, vm);
                },
              ),
              ButtonCustomSheet(
                icon: 'Fila',
                iconColor: Colors.green,
                text: 'Adicionar a fila de reprodução',
                onTap: () {},
              ),
              ButtonCustomSheet(
                btnColor: Colors.red,
                icon: 'Cancel',
                text: 'Deletar playlist',
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteDialog(context, vm);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _editPlaylist(
    BuildContext context,
    PlaylistData playlist,
    PlaylistViewModel vm,
  ) async {
    vm.startEditing(playlist: playlist);
    vm.setStackIndex(1);
  }

  void _showDeleteDialog(BuildContext context, PlaylistViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: "Atenção!",
        content:
            "Apagar a playlist irá remover permanentemente essa seleção do sistema. Essa ação não é reversível.",
        // cancelara sempre vou deixar cinza
        txtBtn: "Apagar",
        corBtn: Color(0xFFFF3951),
        onConfirm: () {
          vm.deletePlaylist(vm.entityBeingVisualized?.id ?? -1);
          print("Playlist apagada!");
        },
      ),
    );
  }
}
