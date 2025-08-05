import 'package:dam_music_streaming/ui/core/ui/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.scaffoldBackgroundColor,

            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: theme.iconTheme.color, size: 25,),
              onPressed: () {
                vm.setStackIndex(0);
              },
            ),
            actions: [
              IconButton(
                icon: SvgIcon(
                    assetName: 'assets/icons/Trash.svg',
                    color: theme.colorScheme.error,
                    size: 35),
                onPressed: () {
                  vm.setStackIndex(0);
                },
              ),
            ],
          ),
          body: playlist == null
              ? const Center(child: Text('Nenhuma playlist selecionada.'))
              :SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(playlist.title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(playlist.description,
                  style: TextStyle(
                    color: theme.dividerColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Criado por: ${playlist.author}',
                          style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${playlist.numSongs} de duração',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient( //TODO: achar uma cor legal para variar
                          colors: [theme.colorScheme.primary, theme.colorScheme.primary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: FloatingActionButton(
                        child: const Icon(Icons.play_arrow, size: 30),
                        onPressed: () {},
                      )
                    ),
                  ],
                ),
                SizedBox(height: 30),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),

                  itemCount: playlist.songs.length,
                  itemBuilder: (context, index) {
                    final song = playlist.songs[index];
                    return Card(
                      color: theme.cardColor,
                      child: ListTile(
                        leading: Image.network(
                          song.coverUrl,
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
                        title: Text(song.title),
                        subtitle: Text(
                          song.artist,
                          style: const TextStyle(color: Color(0xFFB7B0B0)),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 20,),
                        onTap: () async {
                          vm.setStackIndex(2);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}