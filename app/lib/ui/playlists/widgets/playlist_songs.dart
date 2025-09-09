import 'package:cached_network_image/cached_network_image.dart';
import 'package:dam_music_streaming/ui/album/widgets/album_detail.dart';
import 'package:dam_music_streaming/ui/artist/widgets/artist_detail.dart';
import 'package:dam_music_streaming/ui/core/player/view_model/player_view_model.dart';
import 'package:dam_music_streaming/ui/core/ui/custom_snack.dart';
import 'package:dam_music_streaming/ui/core/ui/info_tile.dart';
import 'package:dam_music_streaming/ui/core/ui/loading.dart';
import 'package:dam_music_streaming/ui/playlists/widgets/playlist_add_song.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/song_repository.dart';
import '../../../data/services/genre_service.dart';
import '../../../domain/models/playlist_data.dart';
import '../../../domain/models/song_data.dart';
import '../../core/ui/button_sheet.dart';
import '../../genre/widgets/genre_detail.dart';
import '../view_model/playlist_view_model.dart';
import '../view_model/search_view_model.dart';

class PlaylistSongs extends StatelessWidget {
  const PlaylistSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistViewModel>(
      builder: (context, vm, child) {
        final playlist = vm.entityBeingVisualized;

        if (playlist == null) {
          return Scaffold(
            appBar: AppBar(),
            body: vm.isLoading
                ? Center(child: CustomLoadingIndicator())
                : Center(child: Text('Nenhuma playlist selecionada.')),
          );
        }

        return Scaffold(
          body: vm.isLoading
              ? Center(child: CustomLoadingIndicator())
              : CustomScrollView(
                  slivers: [
                    _buildSliverAppBar(context, vm, playlist),
                    _buildHeader(context, playlist),

                    if (playlist.songs?.isEmpty ?? true)
                      _buildEmptyView(context, vm, playlist)
                    else
                      _buildSongsList(context, vm, playlist),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    PlaylistViewModel vm,
    PlaylistData playlist,
  ) {
    final theme = Theme.of(context);
    return SliverAppBar.large(
      expandedHeight: 200.0,
      pinned: true,
      floating: true,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: theme.iconTheme.color, size: 25),
        onPressed: () => {
          if (Navigator.canPop(context))
            {Navigator.pop(context)}
          else
            {vm.setStackIndex(0)},
        },
      ),
      actions: [
        if (vm.isOwner)
          IconButton(
            icon: Icon(Icons.add, color: theme.iconTheme.color, size: 25),
            onPressed: () async {
              if (playlist.id == null) {
                showCustomSnackBar(
                  context: context,
                  message: "Erro: ID da playlist é nulo.",
                  backgroundColor: Colors.red,
                  icon: Icons.error,
                );
                return;
              }

              final searchVM = Provider.of<SearchViewModel>(
                context,
                listen: false,
              );

              await handleSearch(context, searchVM, playlist.id!, vm);
            },
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (playlist.urlCover != null && playlist.urlCover!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: playlist.urlCover!,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(child: CustomLoadingIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )
            else
              Container(
                color: Colors.grey[800],
                child: Icon(Icons.music_note, color: Colors.white, size: 60),
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
                    playlist.title ?? 'Playlist sem título',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  if (playlist.description != null &&
                      playlist.description!.isNotEmpty)
                    Text(
                      playlist.description!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
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
    );
  }

  Widget _buildHeader(BuildContext context, PlaylistData playlist) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Criado por: ${playlist.author?.username ?? 'Desconhecido'}',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    if (playlist.duration != null)
                      Text(
                        '${playlist.duration!.inMinutes} min de duração',
                        style: TextStyle(
                          color: Color.fromARGB(255, 117, 117, 117),
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
                Spacer(),
                FloatingActionButton(
                  shape: CircleBorder(),
                  child: Icon(Icons.play_arrow, size: 30),
                  onPressed: () {
                    final songs = playlist.songs;

                    if (songs != null && songs.isNotEmpty) {
                      final vm = Provider.of<PlayerViewModel>(
                        context,
                        listen: false,
                      );

                      vm.addListToQueue(list: songs);
                      vm.play(songs[0]);
                    } else {
                      showCustomSnackBar(
                        context: context,
                        message: "A playlist está vazia.",
                        backgroundColor: Colors.red,
                        icon: Icons.error,
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(
    BuildContext context,
    PlaylistViewModel vm,
    PlaylistData playlist,
  ) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_off, size: 60, color: Colors.grey),
            SizedBox(height: 24),
            TextButton.icon(
              icon: Icon(Icons.add),
              label: Text('Adicionar Músicas'),
              onPressed: () async {
                if (playlist.id == null) {
                  showCustomSnackBar(
                    context: context,
                    message: "Erro: ID da playlist é nulo.",
                    backgroundColor: Colors.red,
                    icon: Icons.error,
                  );
                  return;
                }

                final searchVM = Provider.of<SearchViewModel>(
                  context,
                  listen: false,
                );

                // Chama a nova função reutilizável
                await handleSearch(context, searchVM, playlist.id!, vm);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongsList(
    BuildContext context,
    PlaylistViewModel vm,
    PlaylistData playlist,
  ) {
    final theme = Theme.of(context);
    final songs = playlist.songs ?? [];

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final song = songs[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),

          child: InfoTile(
            imageUrl: song.urlCover ?? '',
            title: song.title ?? 'Título desconhecido',
            subtitle: song.artist?.name ?? 'Artista desconhecido',
            trailing: Icon(Icons.more_vert, size: 20),
            onTap: () {
              _showSongActions(context, vm, song, playlist);
            },
          ),
        );
      }, childCount: songs.length),
    );
  }

  void _showSongActions(
    BuildContext context,
    PlaylistViewModel vm,
    SongData song,
    PlaylistData currentPlaylist,
  ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InfoTile(
                imageUrl: song.urlCover ?? '',
                title: song.title ?? 'Título desconhecido',
                subtitle: song.artist?.name ?? 'Artista desconhecido',
              ),
              SizedBox(height: 20),
              ButtonCustomSheet(
                icon: 'Profile',
                text: 'Ver Artista',
                onTap: () {
                  Navigator.pop(context);
                  if (song.artist != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ArtistDetailView(artistId: song.artist!.id ?? -1),
                      ),
                    );
                  }
                },
              ),
              ButtonCustomSheet(
                icon: 'Album',
                text: 'Ver Álbum',
                onTap: () {
                  Navigator.pop(context);
                  if (song.album != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AlbumDetailView(albumId: song.album!.id ?? -1),
                      ),
                    );
                  }
                },
              ),
              ButtonCustomSheet(
                icon: 'Genre',
                text: 'Ver gênero',
                onTap: () async {
                  Navigator.pop(context);

                  if (song.id == null) {
                    showCustomSnackBar(
                      context: context,
                      message: "Id da música inválido.",
                      backgroundColor: Colors.red,
                      icon: Icons.error,
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) =>
                        const Center(child: CustomLoadingIndicator()),
                  );

                  try {
                    final genre = await GenreApiService().fetchBySong(song.id!);
                    Navigator.pop(context); // fecha o loading

                    if (genre == null) {
                      showCustomSnackBar(
                        context: context,
                        message: "Esta música não possui gênero associado.",
                        backgroundColor: Colors.red,
                        icon: Icons.error,
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
                    Navigator.pop(context); // fecha o loading
                    showCustomSnackBar(
                      context: context,
                      message: 'Falha ao carregar gênero.',
                      backgroundColor: Colors.red,
                      icon: Icons.error,
                    );
                  }
                },
              ),
              ButtonCustomSheet(
                icon: 'Playlist',
                text: 'Adicionar a outra playlist',
                onTap: () {
                },
              ),
              ButtonCustomSheet(
                icon: 'Fila',
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
                  if (currentPlaylist.id != null && song.id != null) {
                    vm
                        .removeSongFromPlaylist(currentPlaylist.id!, song.id!)
                        .then((_) {
                          showCustomSnackBar(
                            context: context,
                            message: 'Música removida da playlist.',
                            backgroundColor: Colors.green,
                            icon: Icons.check,
                          );
                        })
                        .catchError((error) {
                          showCustomSnackBar(
                            context: context,
                            message: 'Erro ao remover música: $error',
                            backgroundColor: Colors.red,
                            icon: Icons.error,
                          );
                        });
                  }

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

Future<void> handleSearch(
  BuildContext context,
  SearchViewModel searchVM,
  int playlistId,
  PlaylistViewModel vm,
) async {
  searchVM.clearSelection();

  final Set<SongData>? selectedSongs = await showSearch<Set<SongData>>(
    context: context,
    delegate: CustomSearchDelegate(searchVM: searchVM),
  );

  if (selectedSongs != null && selectedSongs.isNotEmpty) {
    vm.addSongsToCurrentPlaylist(playlistId, selectedSongs);

    showCustomSnackBar(
      context: context,
      message: '${selectedSongs.length} músicas adicionadas!',
      backgroundColor: Colors.green,
      icon: Icons.check,
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
    if (query.isEmpty) {
      return Container();
    }
    if (query != previousQuery) {
      previousQuery = query;
      _searchSongs = repo.searchSongs(query);
    }

    return ChangeNotifierProvider.value(
      value: searchVM,
      child: Consumer<SearchViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: FutureBuilder<List<SongData>>(
              future: _searchSongs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CustomLoadingIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Ocorreu um erro na busca."));
                }

                if (snapshot.data?.isEmpty ?? true) {
                  return Center(child: Text("Nenhuma música encontrada."));
                }

                final songs = snapshot.data!;

                return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    final isSelected = viewModel.selectedSongs.contains(song);
                    return InfoTile(
                      title: song.title ?? 'Título Desconhecido',
                      subtitle: song.artist?.name ?? 'Artista Desconhecido',
                      imageUrl: song.urlCover ?? '',
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (value) =>
                            viewModel.toggleSongSelection(song),
                      ),
                      onTap: () => viewModel.toggleSongSelection(song),
                    );
                  },
                );
              },
            ),

            floatingActionButton: searchVM.selectedSongs.isNotEmpty
                ? FloatingActionButton.extended(
                    onPressed: () {
                      if (searchVM.selectedSongs.isEmpty) {
                        null;
                      } else {
                        close(context, searchVM.selectedSongs);
                      }
                    },
                    icon: Icon(Icons.check, color: Colors.white),
                    label: Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    if (query != previousQuery) {
      previousQuery = query;
      _searchSongs = repo.searchSongs(query);
    }

    return ChangeNotifierProvider.value(
      value: searchVM,
      child: Consumer<SearchViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: FutureBuilder<List<SongData>>(
              future: _searchSongs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CustomLoadingIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Ocorreu um erro na busca."));
                }
                if (snapshot.data?.isEmpty ?? true) {
                  return Center(child: Text("Nenhuma música encontrada."));
                }
                final songs = snapshot.data!;
                return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    final isSelected = viewModel.selectedSongs.contains(song);
                    return InfoTile(
                      title: song.title ?? 'Título Desconhecido',
                      subtitle: song.artist?.name ?? 'Artista Desconhecido',
                      imageUrl: song.urlCover ?? '',
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (value) =>
                            viewModel.toggleSongSelection(song),
                      ),
                      onTap: () => viewModel.toggleSongSelection(song),
                    );
                  },
                );
              },
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                close(context, viewModel.selectedSongs);
              },
              icon: Icon(Icons.check, color: Colors.white),
              label: Text('Salvar', style: TextStyle(color: Colors.white)),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }
}
