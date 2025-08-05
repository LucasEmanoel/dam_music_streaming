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

    return Consumer<PlaylistViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          body: ListView.builder(
              itemCount: vm.playlists.length,
              itemBuilder: (context, index) {
                final playlist = vm.playlists[index];
                Color color = Colors.white60;
                return Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Slidable(
                    key: ValueKey(playlist.id),
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                          backgroundColor: Colors.red,
                          //foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete', onPressed: (BuildContext context) {  },
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 0,
                      color: color,
                      child: ListTile(
                        title: Text(playlist.title),
                        subtitle: Text(playlist.author,),
                        onTap: () async {
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