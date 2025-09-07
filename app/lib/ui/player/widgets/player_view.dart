import 'dart:io';
import "package:path/path.dart";
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlayerView extends StatefulWidget {
  PlayerView({super.key});

  @override
  State<PlayerView> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerView> {
  late final AudioPlayer player;

  bool isPlaying = false;

  Future<void> changePlayingState() async {
    if (isPlaying) {
      await player.pause();
    } else {
      await player.play(
        AssetSource(
          // 'https://dam-harmony.s3.us-east-1.amazonaws.com/475334192.mp3',
          'sounds/475334192.mp3',
        ),
      );
    }
    setState(() => isPlaying = !isPlaying);
  }

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();

    // Log para debug
    player.onPlayerStateChanged.listen((state) {
      print("STATE: $state");
    });
    player.onPlayerComplete.listen((_) {
      print("COMPLETED");
      setState(() => isPlaying = false);
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  _PlayerScreenState() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down_outlined,
            color: theme.iconTheme.color,
            size: 30,
          ),
          onPressed: () {
            //
          },
        ),
        title: const Text(
          'Tocando',
          style: TextStyle(color: Color(0xFFB7B0B0), fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_horiz_sharp,
              color: theme.iconTheme.color,
              size: 25,
            ),
            onPressed: () {
              //
            },
          ),
        ],
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        spacing: 85,
        children: [
          Column(
            spacing: 30,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://upload.wikimedia.org/wikipedia/pt/3/3b/Dark_Side_of_the_Moon.png',
                    ),
                  ),
                ),
              ), //imagem
              Column(
                spacing: 5,
                children: [
                  const Text(
                    'Any Colour you like',
                    style: TextStyle(color: Color(0xFF000000), fontSize: 23),
                  ),
                  const Text(
                    'Pink Floyd',
                    style: TextStyle(color: Color(0xFFB7B0B0), fontSize: 14),
                  ),
                ],
              ), // titulo e cantor
            ],
          ), //Cover
          Column(
            children: [
              Column(), //music control
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () async {
                      await changePlayingState();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Color(0xFF6C63FF),
                      ),
                      shape: WidgetStateProperty.all(CircleBorder()),
                      iconSize: WidgetStateProperty.all(35),
                      minimumSize: WidgetStateProperty.all(Size(60, 60)),
                    ),
                    child: Builder(
                      builder: (context) {
                        if (isPlaying) {
                          return Icon(
                            Icons.play_arrow,
                            color: Color(0xFFFFFFFF),
                          );
                        } else {
                          return Icon(Icons.pause, color: Color(0xFFFFFFFF));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
