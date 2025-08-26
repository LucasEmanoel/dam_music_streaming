import 'package:dam_music_streaming/ui/core/themes/light.dart';
import 'package:dam_music_streaming/ui/core/ui/svg_icon.dart';
import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import 'dart:io';
import 'ui/playlists/widgets/playlists_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'config/token_manager.dart';
import 'ui/home/widgets/home_feed.dart';
import 'ui/login/cadastro_page.dart';
import 'ui/splash/splash_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final String tokenParaTestes = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJsdWNhc0BnbWFpbC5jb20iLCJ1c2VybmFtZSI6Imx1Y2FzdHcxNSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzU1OTU1NjEzLCJleHAiOjE3NjM3MzE2MTN9.6gM46jOYRope-4-viY6tU-CWlWsS0J2w-SJU7_GxO8c";
  await saveToken(tokenParaTestes);

  Directory docsDir = await startMeUp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(HarmonyApp(docsDir: docsDir));
}

Future<Directory> startMeUp() async {
  return await getApplicationDocumentsDirectory();
}

class HarmonyApp extends StatelessWidget {
  final Directory _docsDir;

  const HarmonyApp({super.key, required Directory docsDir}) : _docsDir = docsDir;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: LightTheme.lightTheme,
      debugShowCheckedModeBanner: false,

      home: SplashPage(docsDir: _docsDir),

      routes: {
        '/home':   (_) => HomeScaffold(docsDir: _docsDir),
        '/signup': (_) => CadastroPage(docsDir: _docsDir),
      },
    );
  }
}

class HomeScaffold extends StatelessWidget {
  final Directory docsDir;
  const HomeScaffold({super.key, required this.docsDir});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(
          children: [
            Scaffold(
              appBar: AppBar(
                toolbarHeight: 70,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    SvgIcon(assetName: 'assets/icons/Logo.svg', size: 40),
                    SizedBox(width: 6),
                    Text("Harmony"),
                  ],
                ),
              ),
              body: HomeFeed()
            ),
            const Center(child: Text("Search")),
            const Center(child: Text("Tocando")),
            PlaylistsView(docsDir: docsDir),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(height: 60, icon: SvgIcon(assetName: 'assets/icons/Home.svg', size: 35)),
            Tab(height: 60, icon: SvgIcon(assetName: 'assets/icons/Search.svg', size: 35)),
            Tab(height: 60, icon: SvgIcon(assetName: 'assets/icons/Song.svg', size: 35)),
            Tab(height: 60, icon: SvgIcon(assetName: 'assets/icons/Library.svg', size: 35)),
          ],
        ),
      ),
    );
  }
}