import 'dart:io';
import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'package:dam_music_streaming/ui/core/player/view_model/player_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerViewModel>(
      builder: (context, vm, child) {
        SongData song = SongData(
          id: 475334192,
          artist: null,
          title: 'Get back',
          album: null,
          urlCover:
              'https://cdn-images.dzcdn.net/images/cover/efacd27f64a06aa8dae8de0dea7f0ac4/500x500-000000-80-0-0.jpg',
        );
        vm.setCurrentSong(song);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_down_outlined,
                size: 30,
                color: Color(0xFF000000),
              ),
              onPressed: () {
                //
              },
            ),
            title: const Text(
              'Tocando',
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.more_horiz_sharp,
                  size: 25,
                  color: Color(0xFF000000),
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
            children: [
              const SizedBox(height: 42),
              Column(
                spacing: 30,
                children: [
                  CachedNetworkImage(
                    imageUrl: vm.current!.urlCover ?? '',
                    imageBuilder: (context, imageProvider) => Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fitHeight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x591A1662),
                            spreadRadius: 3,
                            blurRadius: 14,
                            offset: Offset(
                              0,
                              4,
                            ), // Horizontal and vertical offset of the shadow
                          ),
                        ],
                      ),
                    ),
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                  Column(
                    spacing: 5,
                    children: [
                      Text(
                        vm.current?.title ?? '',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        'Pink Floyd',
                        style: TextStyle(
                          color: Color(0xFFB7B0B0),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ), // titulo e cantor
                ],
              ), //Cover
              const SizedBox(height: 45),
              Container(
                padding: EdgeInsets.only(left: 18, right: 18),
                child: Column(
                  spacing: 9.5,
                  children: [
                    Column(
                      // spacing: -8,
                      children: [
                        SliderTheme(
                          data: SliderThemeData(
                            thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 7,
                            ),
                          ),
                          child: Slider(
                            onChanged: (value) {
                              final duration = vm.duration;
                              if (duration == null) {
                                return;
                              }
                              final position = value * duration.inMilliseconds;
                              vm.changeTimeMusicPlaying(position);
                            },
                            value:
                                (vm.position != null &&
                                    vm.duration != null &&
                                    vm.position!.inMilliseconds > 0 &&
                                    vm.position!.inMilliseconds <
                                        vm.duration!.inMilliseconds)
                                ? vm.position!.inMilliseconds /
                                      vm.duration!.inMilliseconds
                                : 0.0, //
                            inactiveColor: Color(0xFFB2B2B2),
                            activeColor: Color(0xFF6C63FF),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 18, right: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                vm.positionText,
                                style: TextStyle(
                                  color: Color(0xFF696969),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                vm.durationText,
                                style: TextStyle(
                                  color: Color(0xFF696969),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton(
                          onPressed: () async {
                            await vm.toggle();
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
                              if (vm.isPlaying) {
                                return Icon(
                                  Icons.pause,
                                  color: Color(0xFFFFFFFF),
                                );
                              } else {
                                return Icon(
                                  Icons.play_arrow,
                                  color: Color(0xFFFFFFFF),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ), //music control
              ),
            ],
          ),
        );
      },
    );
  }
}
