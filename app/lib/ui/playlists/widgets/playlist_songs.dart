
import 'package:dam_music_streaming/data/dto/song_dto.dart';
import 'package:dam_music_streaming/ui/album/widgets/album_songs.dart';
import 'package:dam_music_streaming/ui/core/ui/info_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/song_repository.dart';
import '../../../domain/models/playlist_data.dart';
import '../../../domain/models/song_data.dart';
import '../../core/ui/button_sheet.dart';
import '../view_model/playlist_view_model.dart';
import '../view_model/search_view_model.dart';

class PlaylistSongs extends StatelessWidget {
  const PlaylistSongs({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<PlaylistViewModel>(
      builder: (context, vm, child) {
        final playlist = vm.entityBeingVisualized;

        return Scaffold(
          body: playlist == null
              ? const Center(child: Text('Nenhuma playlist selecionada.'))
              : CustomScrollView(
            slivers: [
              SliverAppBar.large(
                expandedHeight: 200.0,
                //floating: false,
                pinned: true,
                elevation: 0,
                //backgroundColor: theme.scaffoldBackgroundColor,
                leading: IconButton(
                  icon: Icon(
                      Icons.arrow_back, color: theme.iconTheme.color, size: 25),
                  onPressed: () {
                    vm.setStackIndex(0);
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(


                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        playlist.urlCover ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[700],
                          );
                        },
                      ),

                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black87],
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              playlist.title ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              playlist.description ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Criado por: ${playlist.author?.username ??
                                    ''}',
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                    fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${playlist.duration} de duração',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 71, 71, 71),
                                    fontSize: 13),
                              ),
                            ],
                          ),
                          const Spacer(),
                          FloatingActionButton(
                            shape: const CircleBorder(),
                            child: const Icon(Icons.play_arrow, size: 30),
                            onPressed: () {},
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              if (playlist!.songs?.isEmpty ?? true)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                            Icons.music_off, size: 60, color: Colors.grey),
                        const SizedBox(height: 24),
                        TextButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Adicionar Músicas',
                            selectionColor: Colors.black,),
                          onPressed: () async {
                            final searchVM = Provider.of<SearchViewModel>(
                                context, listen: false);
                            searchVM.clearSelection();

                            if (playlist == null || playlist.id == null) {
                              print("Erro: Playlist ou ID da playlist é nulo.");
                              return;
                            }

                            final Set<
                                SongData>? selectedSongs = await showSearch<
                                Set<SongData>>(
                              context: context,
                              delegate: CustomSearchDelegate(
                                  searchVM: searchVM),
                            );

                            if (selectedSongs != null &&
                                selectedSongs.isNotEmpty) {
                              vm.addSongsToCurrentPlaylist(
                                  playlist.id!, selectedSongs);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${selectedSongs
                                    .length} músicas adicionadas!')),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final song = playlist.songs![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                        child: Card(
                          color: theme.cardColor,
                          child: InfoTile(
                            imageUrl: song.md5Image ?? '',
                            title: song.title ?? '',
                            subtitle: song.artist?.name ?? '',
                            trailing: const Icon(Icons.more_vert, size: 20),
                            onTap: () async {
                              _showSongActions(context, vm, song, playlist);
                              vm.setStackIndex(2);
                            },
                          ),
                        ),
                      );
                    },
                    childCount: playlist.songs?.length ?? 0,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deletePlaylist(BuildContext context, PlaylistData playlist,
      PlaylistViewModel vm) async {
    await vm.deletePlaylist(playlist.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
        content: Text("Contact deleted"),
      ),
    );
  }

  void _showSongActions(BuildContext context, PlaylistViewModel vm, SongData song, PlaylistData currentPlaylist) {
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
                imageUrl: song.md5Image ?? '',
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
                text: 'Ver Álbum',
                onTap: () {
                  Navigator.pop(context);
                  if (song.album?.id != null) {
                     Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (_) => AlbumSongs(albumID: song.album!.id!)
                         )
                     );
                  }
                },
              ),
              ButtonCustomSheet(
                icon: 'Playlist',
                text: 'Adicionar a outra playlist',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ButtonCustomSheet(
                icon: 'Fila',
                iconColor: Colors.green,
                text: 'Adicionar à fila de reprodução',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ButtonCustomSheet(
                btnColor: Colors.red,
                icon: 'Cancel',
                text: 'Remover desta playlist',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<Set<SongData>> {

  final SongRepository repo = SongRepository();
  final SearchViewModel searchVM;

  Future<List<SongData>>? _searchSongs;
  String? previousQuery;


  CustomSearchDelegate({required this.searchVM});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, searchVM.selectedSongs);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    if(query != previousQuery){
      previousQuery = query;
      _searchSongs = repo.searchSongs(query);
    }

    return ChangeNotifierProvider.value(
      value: searchVM,
      child: Consumer<SearchViewModel>(
        builder: (context, viewModel, child) {

          return FutureBuilder<List<SongData>>(
            future: _searchSongs,
            builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Nenhuma música encontrada."));
              }

              final songs = snapshot.data!;

              return ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  final isSelected = viewModel.selectedSongs.contains(song);

                  return InfoTile(
                    title: song.title,
                    subtitle: song.artist?.name,
                    //imageUrl: song.md5Image,
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (value) => viewModel.toggleSongSelection(song),
                    ),
                    onTap: () => viewModel.toggleSongSelection(song),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: searchVM,
      child: Container(),
    );
  }
}