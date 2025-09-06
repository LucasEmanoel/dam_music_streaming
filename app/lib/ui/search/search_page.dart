// lib/ui/search/search_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/song_repository.dart';
import '../../domain/models/song_data.dart';
import '../../domain/models/playlist_data.dart';
import '../album/widgets/album_detail.dart';
import '../artist/widgets/artist_detail.dart';
import '../core/ui/info_tile.dart';
import '../core/ui/loading.dart';
import '../core/ui/button_sheet.dart';
import '../playlists/view_model/playlist_view_model.dart';

class SearchViewModel2 extends ChangeNotifier {
  final SongRepository repo;
  SearchViewModel2(this.repo);

  String _query = '';
  bool _loading = false;
  String? _error;
  List<SongData> _results = [];

  String get query => _query;
  bool get loading => _loading;
  String? get error => _error;
  List<SongData> get results => _results;

  Future<void> search(String q) async {
    _query = q.trim();
    _error = null;
    if (_query.isEmpty) {
      _results = [];
      notifyListeners();
      return;
    }
    _loading = true;
    notifyListeners();
    try {
      _results = await repo.searchSongs(_query); // mesmo endpoint da playlist
    } catch (e) {
      _error = 'Falha ao buscar. Tente novamente.';
      _results = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void clear() {
    _query = '';
    _results = [];
    _error = null;
    notifyListeners();
  }
}

// =============== PAGE ===============
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _ctrl = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => SearchViewModel2(SongRepository()),
      child: Consumer<SearchViewModel2>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 72,
              titleSpacing: 16,
              title: TextField(
                controller: _ctrl,
                onChanged: (v) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 400), () {
                    vm.search(v); // usa o vm dentro do Provider ✅
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Buscar músicas, artistas, álbuns…',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: vm.query.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _ctrl.clear();
                      vm.clear();
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant.withOpacity(.6),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            body: Builder(
              builder: (_) {
                if (vm.loading) {
                  return const Center(child: CustomLoadingIndicator());
                }
                if (vm.error != null) {
                  return Center(child: Text(vm.error!));
                }
                if (vm.query.isEmpty) {
                  return const _EmptySearchHint();
                }
                if (vm.results.isEmpty) {
                  return const Center(child: Text('Nenhum resultado.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: vm.results.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final s = vm.results[i];
                    return InfoTile(
                      imageUrl: s.urlCover ?? '',
                      title: s.title ?? 'Título desconhecido',
                      subtitle: s.artist?.name ?? 'Artista desconhecido',
                      trailing: const Icon(Icons.more_vert, size: 20),
                      onTap: () => _showSongActions(context, s),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  // BottomSheet com o mesmo "estilo" da tela de playlist
  void _showSongActions(BuildContext context, SongData song) {
    final playlistVM = context.read<PlaylistViewModel?>();
    final PlaylistData? currentPlaylist = playlistVM?.entityBeingVisualized;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoTile(
                  imageUrl: song.urlCover ?? '',
                  title: song.title ?? 'Título desconhecido',
                  subtitle: song.artist?.name ?? 'Artista desconhecido',
                ),
                const SizedBox(height: 20),
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
                if (currentPlaylist?.id != null)
                  ButtonCustomSheet(
                    icon: 'Playlist',
                    text:
                    'Adicionar à playlist atual (${currentPlaylist!.title ?? "sem título"})',
                    onTap: () {
                      Navigator.pop(context);
                      playlistVM!.addSongsToCurrentPlaylist(
                        currentPlaylist.id!,
                        {song},
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Música adicionada!')),
                      );
                    },
                  )
                else
                  ButtonCustomSheet(
                    icon: 'Playlist',
                    text: 'Adicionar a uma playlist',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Abra uma playlist para adicionar rapidamente, ou implemente o seletor.',
                          ),
                        ),
                      );
                    },
                  ),
                ButtonCustomSheet(
                  icon: 'Fila',
                  iconColor: Colors.green,
                  text: 'Adicionar à fila de reprodução',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: integrar com fila do player
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptySearchHint extends StatelessWidget {
  const _EmptySearchHint();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Pesquise por músicas, artistas ou álbuns',
        style: TextStyle(color: Colors.grey[700]),
      ),
    );
  }
}
