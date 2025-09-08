import 'package:dam_music_streaming/ui/player/view_model/player_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerQueueView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PlayerScreenViewModel playerScreenViewModel = context
        .read<PlayerScreenViewModel>();

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
      body: Column(children: [const Text("TESTE")]),
    );
  }
}
