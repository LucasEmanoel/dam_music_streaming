import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../view_model/playlist_view_model.dart";

class PlaylistEntryView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PlaylistViewModel>(context, listen: false);

    for (var appointment in vm.playlists) {
      Text('oi');
    }

    return Consumer<PlaylistViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          body: Column(
            children: [Text('p1')],
          ),
        );
      },
    );
  }
}