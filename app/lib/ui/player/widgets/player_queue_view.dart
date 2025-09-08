import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'package:dam_music_streaming/ui/core/player/view_model/player_view_model.dart';
import 'package:dam_music_streaming/ui/core/ui/info_tile.dart';
import 'package:dam_music_streaming/ui/player/view_model/player_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerQueueView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PlayerScreenViewModel playerScreenViewModel = context
        .read<PlayerScreenViewModel>();

    final PlayerViewModel playerVm = context.watch<PlayerViewModel>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down_outlined,
            size: 30,
            color: Color(0xFF000000),
          ),
          onPressed: () {
            playerScreenViewModel.setStackIndex(0);
          },
        ),
        title: const Text(
          'Fila de reprodução',
          style: TextStyle(
            color: Color(0xFF000000),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: playerVm.songsQueue.isEmpty
          ? Center(
              child: Text(
                'A fila está vazia.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(right: 25),
                  child: GestureDetector(
                    onTap: () {
                      playerVm.clearQueue();
                    },
                    child: const Text(
                      'Limpar',
                      style: TextStyle(color: Color(0xFF79747E), fontSize: 14),
                    ),
                  ),
                ),
                ReorderableListView.builder(
                  shrinkWrap: true,
                  itemCount: playerVm.songsQueue.length,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  itemBuilder: (context, index) {
                    final SongData song = playerVm.songsQueue.elementAt(index);
                    return ReorderableDragStartListener(
                      key: Key('${song.id}'),
                      index: index,
                      child: InfoTile(
                        imageUrl: song.album?.urlCover ?? '',
                        title: song.title ?? '',
                        subtitle: song.artist?.name ?? '',
                        trailing: IconButton(
                          icon: const Icon(Icons.list),
                          onPressed: () => {
                            //
                          },
                        ),
                        onTap: () {
                          // playerVm.setQueueAtIndex(index);
                        },
                      ),
                    );
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    playerVm.reorderQueue(oldIndex, newIndex);
                  },
                ),
              ],
            ),
    );
  }
}
