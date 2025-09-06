import 'package:dam_music_streaming/ui/core/ui/album_tile.dart';
import 'package:dam_music_streaming/ui/core/ui/loading.dart';
import 'package:dam_music_streaming/ui/suggestions/view_model/sugestions_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeatherSuggestionsView extends StatelessWidget {
  const WeatherSuggestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = SuggestionsViewModel();
        vm.getSuggestionsByWeather();
        return vm;
      },
      child: Consumer<SuggestionsViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return Scaffold(body: Center(child: CustomLoadingIndicator()));
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Sugestões de Clima',
                style: TextStyle(color: Color(0xFFB7B0B0), fontSize: 18),
              ),
              elevation: 0,
            ),
            body: vm.playlists.isEmpty

                ? Center(
                    child: Text(
                      'Nenhuma SUGESTÃO encontrada.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )

                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: vm.playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = vm.playlists[index];
                      return MediaTile(
                        imageUrl: playlist.urlCover ?? '',
                        title: playlist.title ?? '',
                        subtitle: playlist.description ?? '',
                        onTap: () {
                          //pretendo usar navigator aqui, inves do stack
                          if (playlist.id != null) {
                            //vm.startView(id: playlist.id!);
                            //vm.setStackIndex(2);
                          }
                        },
                      );
                    
                    },
                  ),
          );
        },
      ),
    );
  }
}
