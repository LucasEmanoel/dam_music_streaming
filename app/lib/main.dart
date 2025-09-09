import 'package:audioplayers/audioplayers.dart';
import 'package:dam_music_streaming/ui/core/player/view_model/player_view_model.dart';
import 'package:dam_music_streaming/ui/core/themes/light.dart';
import 'package:dam_music_streaming/ui/core/ui/svg_icon.dart';
import 'package:dam_music_streaming/ui/core/user/view_model/user_view_model.dart';
import 'package:dam_music_streaming/ui/player/widgets/player_view.dart';
import 'package:dam_music_streaming/ui/profile/widgets/profile_view.dart';
import 'package:dam_music_streaming/ui/suggestions/widgets/suggestions_weather.dart';
import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import 'package:provider/provider.dart';
import 'dart:io';
import 'ui/playlists/widgets/playlists_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'ui/home/widgets/home_feed.dart';
import 'ui/login/cadastro_page.dart';
import 'ui/splash/splash_page.dart';
import 'ui/search/search_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory docsDir = await startMeUp();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AudioPlayer audioPlayer = setAudioPlayer();
  runApp(HarmonyApp(docsDir: docsDir, player: audioPlayer));
}

Future<Directory> startMeUp() async {
  return await getApplicationDocumentsDirectory();
}

AudioPlayer setAudioPlayer() {
  AudioPlayer player = AudioPlayer();

  return player;
}

class HarmonyApp extends StatelessWidget {
  final Directory _docsDir;
  final AudioPlayer _audioPlayer;

  const HarmonyApp({
    super.key,
    required Directory docsDir,
    required AudioPlayer player,
  }) : _docsDir = docsDir,
       _audioPlayer = player;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserViewModel>(
          create: (context) {
            UserViewModel userModel = UserViewModel(_docsDir);
            return userModel;
          },
        ),
        ChangeNotifierProvider<PlayerViewModel>(
          create: (context) {
            PlayerViewModel playerViewModel = PlayerViewModel(
              player: _audioPlayer,
            );
            return playerViewModel;
          },
        ),
      ],
      child: MaterialApp(
        theme: LightTheme.lightTheme,
        debugShowCheckedModeBanner: false,

        home: SplashPage(docsDir: _docsDir),

        routes: {
          '/home': (_) => HomeScaffold(docsDir: _docsDir),
          '/signup': (_) => CadastroPage(docsDir: _docsDir),
          '/profile': (_) => ProfileView(docsDir: _docsDir),
        },
      ),
    );
  }
}

class HomeScaffold extends StatelessWidget {
  final Directory docsDir;
  File? avatarFile;
  final initialIndex;

  HomeScaffold({super.key, required this.docsDir, this.initialIndex = 0}) {}

  @override
  Widget build(BuildContext context) {
    final UserViewModel userViewModel = context.watch<UserViewModel>();

    return DefaultTabController(
      length: 5,
      initialIndex: initialIndex,
      child: Scaffold(
        body: TabBarView(
          children: [
            Scaffold(
              appBar: AppBar(
                toolbarHeight: 70,
                actionsPadding: EdgeInsets.only(right: 28),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgIcon(assetName: 'assets/icons/Logo.svg', size: 40),
                    SizedBox(width: 6),
                    Text("Harmony", style: TextStyle(fontSize: 16)),
                  ],
                ),
                actions: [
                  /*IconButton(
                    icon: Icon(Icons.wb_sunny_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeatherSuggestionsView(),
                        ),
                      );
                    },
                  ),*/
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/profile');
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.indigoAccent,
                      maxRadius: 16,
                      backgroundImage: userViewModel.getUserProfilePicture(),
                    ),
                  ),
                ],
              ),

              body: HomeFeed(),
            ),
            WeatherSuggestionsView(),
            const SearchPage(),
            PlayerView(context: context), //context apenas para debug
            PlaylistsView(),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(
              height: 60,
              icon: SvgIcon(assetName: 'assets/icons/Home.svg', size: 35),
            ),
            Tab(
              height: 60,
              icon: Icon(Icons.cloud_outlined, size: 35),
            ),
            Tab(
              height: 60,
              icon: SvgIcon(assetName: 'assets/icons/Search.svg', size: 35),
            ),
            Tab(
              height: 60,
              icon: SvgIcon(assetName: 'assets/icons/Song.svg', size: 35),
            ),
            Tab(
              height: 60,
              icon: SvgIcon(assetName: 'assets/icons/Library.svg', size: 35),
            ),
          ],
        ),
      ),
    );
  }
}
