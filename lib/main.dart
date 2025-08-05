import 'package:dam_music_streaming/ui/core/themes/light.dart';
import 'package:dam_music_streaming/ui/core/ui/svg_icon.dart';
import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import 'dart:io';
import 'ui/playlists/widgets/playlists_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HarmonyApp());
}

Future<Directory> startMeUp() async {
  return await getApplicationDocumentsDirectory();
}

class HarmonyApp extends StatelessWidget {
  const HarmonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: LightTheme.lightTheme,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Padding(padding: const EdgeInsets.symmetric(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgIcon(assetName: 'assets/icons/Logo.svg', size: 40,),
                SizedBox(width: 4),
                Text("Harmony"),
              ],
            ),
            )

          ),

          body: const TabBarView(
            children: [
              Center(child: Text("Home")),
              Center(child: Text("Search")),
              Center(child: Text("Tocando")),
              Playlist(),
            ],
          ),
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(
                  height: 60,
                  icon: SvgIcon(assetName: 'assets/icons/Home.svg', size: 35,)
              ),
              Tab(
                  height: 60,
                  icon: SvgIcon(assetName: 'assets/icons/Search.svg', size: 35,)
              ),
              Tab(
                  height: 60,
                  icon: SvgIcon(assetName: 'assets/icons/Song.svg', size: 35,)
              ),
              Tab(
                  height: 60,
                  icon: SvgIcon(assetName: 'assets/icons/Library.svg', size: 35,)
              ),
            ],
          ),
        ),
      ),
    );
  }
}