import 'package:cached_network_image/cached_network_image.dart';
import 'package:dam_music_streaming/data/services/genre_service.dart';
import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'package:dam_music_streaming/ui/core/player/view_model/player_view_model.dart';
import 'package:dam_music_streaming/ui/core/ui/button_sheet.dart';
import 'package:dam_music_streaming/ui/core/ui/info_tile.dart';
import 'package:dam_music_streaming/ui/genre/widgets/genre_detail.dart';
import 'package:dam_music_streaming/ui/player/view_model/player_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerShowView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerViewModel>(
      builder: (context, vm, child) {
        final PlayerScreenViewModel playerScreenViewModel = context
            .read<PlayerScreenViewModel>();
        SongData? song = vm.current;

        //VALIDAR ESTADO CASO NÃO TENHA MÚSICA CURRENT
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
                  // _showSongActions(context, song);
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
                    imageUrl: vm.current?.album?.urlCover ?? '',
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
                            offset: Offset(0, 4),
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
                      Text(
                        vm.current?.artist?.name ?? '',
                        style: TextStyle(
                          color: Color(0xFFB7B0B0),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ), // titulo e cantor
                ],
              ), //Cover
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(left: 18, right: 18),
                child: Column(
                  spacing: 9.5,
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.only(right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(height: 35),
                          IconButton(
                            icon: Icon(
                              Icons.list,
                              size: 35,
                              color: Color(0xFF000000),
                            ),
                            onPressed: () {
                              playerScreenViewModel.setStackIndex(1);
                            },
                          ),
                        ],
                      ),
                    ),
                    Column(
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
                                : 0.0,
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
                      spacing: 20,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.skip_previous_outlined,
                            size: 35,
                            color: vm.hasPreviousSong()
                                ? Color(0xFF000000)
                                : Color(0xFF8E8E8E),
                          ),
                          onPressed: vm.hasPreviousSong()
                              ? () {
                                  vm.jumpPreviousSong();
                                }
                              : null,
                        ),
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
                        IconButton(
                          icon: Icon(
                            Icons.skip_next_outlined,
                            size: 35,
                            color: vm.hasNextSong()
                                ? Color(0xFF000000)
                                : Color(0xFF8E8E8E),
                          ),
                          onPressed: vm.hasNextSong()
                              ? () {
                                  vm.jumpNextSong();
                                }
                              : null,
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

  void _showSongActions(BuildContext context, SongData song) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InfoTile(
                imageUrl: song.urlCover ?? '',
                title: song.title ?? '',
                subtitle: song.artist?.name ?? '',
              ),
              const SizedBox(height: 20),

              ButtonCustomSheet(
                icon: 'Profile',
                text: 'Ver Artista',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ButtonCustomSheet(
                icon: 'Album',
                text: 'Ver Album',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ButtonCustomSheet(
                icon: 'Playlist',
                text: 'Adicionar a playlist',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ButtonCustomSheet(
                icon: 'Genre',
                text: 'Ver gênero',
                onTap: () async {
                  Navigator.pop(context);

                  if (song.id == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Id da música inválido.')),
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                  );

                  try {
                    final genre = await GenreApiService().fetchBySong(song.id!);
                    Navigator.pop(context);

                    if (genre == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Esta música não possui gênero associado.',
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GenreDetailPage(genreId: genre.id),
                      ),
                    );
                  } catch (_) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Falha ao carregar gênero.'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
