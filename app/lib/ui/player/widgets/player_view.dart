import 'dart:io';
import 'package:dam_music_streaming/data/services/genre_service.dart';
import 'package:dam_music_streaming/domain/models/album_data.dart';
import 'package:dam_music_streaming/domain/models/artist_data.dart';
import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'package:dam_music_streaming/ui/album/view_model/album_view_model.dart';
import 'package:dam_music_streaming/ui/core/player/view_model/player_view_model.dart';
import 'package:dam_music_streaming/ui/core/ui/button_sheet.dart';
import 'package:dam_music_streaming/ui/core/ui/custom_snack.dart';
import 'package:dam_music_streaming/ui/core/ui/info_tile.dart';
import 'package:dam_music_streaming/ui/core/ui/loading.dart';
import 'package:dam_music_streaming/ui/genre/widgets/genre_detail.dart';
import 'package:dam_music_streaming/ui/player/view_model/player_screen_view_model.dart';
import 'package:dam_music_streaming/ui/player/widgets/player_queue_view.dart';
import 'package:dam_music_streaming/ui/player/widgets/player_show_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlayerView extends StatelessWidget {
  PlayerView({super.key, required BuildContext context}) {
    //area apenas para debug
    final PlayerViewModel vm = context.read<PlayerViewModel>();
    List<SongData> songs = [
      SongData(
        id: 3498055531,
        deezerId: 3498055531,
        title: 'Hang On In There(B - Side)',
        artist: ArtistData(
          id: 73,
          name: 'Queen',
          pictureBig:
              'https: //cdn-images.dzcdn.net/images/artist/71eeb9e2eeb375df35a3c0654a5a01ab/250x250-000000-80-0-0.jpg',
        ),
        album: AlbumData(
          id: 434,
          title: 'B - Sides',
          urlCover:
              'https://cdn-images.dzcdn.net/images/cover/704ca8f7cd13f5fbfed5cca939cd4266/250x250-000000-80-0-0.jpg',
        ),
      ),
      SongData(
        id: 3498055541,
        deezerId: 3498055541,
        title: 'See What A Fool I’ve Been(B - Side Version / Remastered 2011)',
        artist: ArtistData(
          id: 73,
          name: 'Queen',
          pictureBig:
              'https://cdn-images.dzcdn.net/images/cover/704ca8f7cd13f5fbfed5cca939cd4266/250x250-000000-80-0-0.jpg',
        ),
        album: AlbumData(
          id: 434,
          title: 'B - Sides',
          urlCover:
              'https://cdn-images.dzcdn.net/images/cover/704ca8f7cd13f5fbfed5cca939cd4266/250x250-000000-80-0-0.jpg',
        ),
      ),
      SongData(
        id: 3498055551,
        deezerId: 3498055551,
        title: 'A Human Body(B - Side)',
        artist: ArtistData(
          id: 73,
          name: 'Queen',
          pictureBig:
              'https: //cdn-images.dzcdn.net/images/artist/71eeb9e2eeb375df35a3c0654a5a01ab/250x250-000000-80-0-0.jpg',
        ),
        album: AlbumData(
          id: 434,
          title: 'B - Sides',
          urlCover:
              'https://cdn-images.dzcdn.net/images/cover/704ca8f7cd13f5fbfed5cca939cd4266/250x250-000000-80-0-0.jpg',
        ),
      ),
    ];
    vm.addListToQueue(list: songs);
    // vm.playOneSong(songs[0]);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlayerScreenViewModel>(
      create: (context) {
        final vm = PlayerScreenViewModel();
        return vm;
      },
      child: Consumer<PlayerScreenViewModel>(
        builder: (context, vm, child) {
          return IndexedStack(
            index: vm.indexStack,
            children: [PlayerShowView(), PlayerQueueView()],
          );
        },
      ),
    );
  }
}
