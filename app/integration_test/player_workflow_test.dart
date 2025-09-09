import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dam_music_streaming/ui/core/player/view_model/player_view_model.dart';
import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'package:dam_music_streaming/domain/models/artist_data.dart';

void main() {
  group('Player Integration Tests', () {
    late AudioPlayer audioPlayer;
    late PlayerViewModel playerViewModel;

    setUp(() {
      audioPlayer = AudioPlayer();
      playerViewModel = PlayerViewModel(player: audioPlayer);
    });

    tearDown(() {
      audioPlayer.dispose();
    });

    testWidgets('deve reordenar a fila corretamente', (
      WidgetTester tester,
    ) async {
      final songs = [
        SongData(
          id: 1,
          deezerId: 12345,
          title: 'Song A',
          artist: ArtistData(id: 1, name: 'Artist A'),
        ),
        SongData(
          id: 2,
          deezerId: 12346,
          title: 'Song B',
          artist: ArtistData(id: 2, name: 'Artist B'),
        ),
        SongData(
          id: 3,
          deezerId: 12347,
          title: 'Song C',
          artist: ArtistData(id: 3, name: 'Artist C'),
        ),
      ];

      playerViewModel.addListToQueue(list: songs);

      await tester.pumpWidget(
        ChangeNotifierProvider<PlayerViewModel>.value(
          value: playerViewModel,
          child: MaterialApp(
            home: Scaffold(
              body: Consumer<PlayerViewModel>(
                builder: (context, player, child) {
                  return Column(
                    children: [
                      Text('Current: ${player.current?.title ?? 'None'}'),
                      Text(
                        'Queue: ${player.songsQueue.map((s) => s.title).join(', ')}',
                      ),
                      ElevatedButton(
                        onPressed: () => player.reorderQueue(1, 0),
                        child: const Text('Reorder Queue'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Current: Song A'), findsOneWidget);
      expect(find.text('Queue: Song B, Song C'), findsOneWidget);

      await tester.tap(find.text('Reorder Queue'));
      await tester.pumpAndSettle();

      expect(find.text('Current: Song A'), findsOneWidget);
      expect(find.text('Queue: Song C, Song B'), findsOneWidget);
    });
  });
}
