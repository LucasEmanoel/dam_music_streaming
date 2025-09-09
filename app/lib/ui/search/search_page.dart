import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../data/repositories/song_repository.dart';
import '../../data/services/genre_service.dart';
import '../../domain/models/song_data.dart';
import '../../domain/models/playlist_data.dart';
import '../album/widgets/album_detail.dart';
import '../artist/widgets/artist_detail.dart';
import '../core/player/view_model/player_view_model.dart';
import '../core/ui/info_tile.dart';
import '../core/ui/loading.dart';
import '../core/ui/button_sheet.dart';
import '../genre/widgets/genre_detail.dart';
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
      final fetched = await repo.searchSongs(_query);

      final qn = _query.toLowerCase();
      _results = fetched.where((s) {
        final title = (s.title ?? '').toLowerCase();
        final artist = (s.artist?.name ?? '').toLowerCase();
        final album = (s.album?.title ?? '').toLowerCase();
        return title.contains(qn) || artist.contains(qn) || album.contains(qn);
      }).toList();
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
              toolbarHeight: 70,
              titleSpacing: 16,
              title: TextField(
                controller: _ctrl,
                onChanged: (v) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 400), () {
                    vm.search(v);
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
                  return const _GenresDiscover();
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
                      final genre = await GenreApiService().fetchBySong(
                        song.id!,
                      );
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
                  onTap: () async {
                    Navigator.pop(context);
                    final player = context.read<PlayerViewModel>();
                    final url = '${player.songBaseUrl}${song.id}.mp3';

                    final ok = await _urlOk(url);
                    if (!ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Não foi possível acessar o áudio (${song.id}).',
                          ),
                        ),
                      );
                      return;
                    }

                    if (!player.hasTrack) {
                      player.playOneSong(song);
                      await player.toggle();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reproduzindo a música selecionada.'),
                        ),
                      );
                    } else {
                      player.addSongToQueue(song);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Música adicionada à fila.'),
                        ),
                      );
                    }
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

Future<bool> _urlOk(String url) async {
  try {
    final r = await http
        .head(Uri.parse(url))
        .timeout(const Duration(seconds: 5));
    if (r.statusCode >= 200 && r.statusCode < 300) return true;
    final g = await http
        .get(Uri.parse(url), headers: {'Range': 'bytes=0-1'})
        .timeout(const Duration(seconds: 5));
    return g.statusCode == 206 || (g.statusCode >= 200 && g.statusCode < 300);
  } catch (_) {
    return false;
  }
}

class _GenresDiscover extends StatelessWidget {
  const _GenresDiscover();

  @override
  Widget build(BuildContext context) {
    final api = GenreApiService();

    return FutureBuilder<List<GenreMiniDto>>(
      future: api.fetchAll(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Falha ao carregar gêneros'));
        }

        final raw = snap.data ?? const <GenreMiniDto>[];

        final genres = raw
            .fold<Map<String, GenreMiniDto>>({}, (map, g) {
              map[g.name.toLowerCase()] = g;
              return map;
            })
            .values
            .toList();

        if (genres.isEmpty) {
          return const Center(child: Text('Nenhuma categoria por enquanto.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Descobrir categorias',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.4,
                ),
                itemCount: genres.length,
                itemBuilder: (_, i) {
                  final g = genres[i];
                  final color = _genreColors[i % _genreColors.length];
                  return _GenreCard(
                    label: g.name,
                    color: color,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GenreDetailPage(genreId: g.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

const _genreColors = <Color>[
  Color(0xFF16A34A),
  Color(0xFF7C3AED),
  Color(0xFFE11D48),
  Color(0xFF2563EB),
  Color(0xFF059669),
  Color(0xFF0EA5E9),
  Color(0xFFF59E0B),
  Color(0xFF9333EA),
];

class _GenreCard extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _GenreCard({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: .2,
            ),
          ),
        ),
      ),
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
