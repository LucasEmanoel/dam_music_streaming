import 'package:dam_music_streaming/ui/core/ui/loading.dart';
import 'package:dam_music_streaming/ui/player/widgets/player_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/services/playlist_service.dart';
import '../../../data/dto/song_dto.dart';
import '../../core/player/view_model/player_view_model.dart';

import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'package:dam_music_streaming/domain/models/artist_data.dart';
import 'package:dam_music_streaming/domain/models/album_data.dart';

class HomeFeed extends StatefulWidget {
  const HomeFeed({super.key});
  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

List<SongDto> _capByArtist(List<SongDto> songs, {int perArtist = 5}) {
  final Map<int, int> counts = {};
  final List<SongDto> out = [];

  for (final s in songs) {
    final int? artistId = s.artist?.id;
    if (artistId == null) {
      out.add(s);
      continue;
    }
    final c = counts[artistId] ?? 0;
    if (c < perArtist) {
      out.add(s);
      counts[artistId] = c + 1;
    }
  }
  return out;
}

class _HomeFeedState extends State<HomeFeed> {
  final _api = PlaylistApiService();

  late final Future<List<SongDto>> _songsFuture = _api.fetchAllSongs();

  bool _showAll = false;

  SongData _toSongData(SongDto s) => SongData(
    id: s.id,
    title: s.title,
    urlCover: s.urlCover ?? s.album?.urlCover,
    artist: s.artist != null
        ? ArtistData(id: s.artist!.id, name: s.artist!.name)
        : null,
    album: s.album != null
        ? AlbumData(
            id: s.album!.id,
            title: s.album!.title,
            urlCover: s.album!.urlCover,
            artist: s.album!.artist != null
                ? ArtistData(
                    id: s.album!.artist!.id,
                    name: s.album!.artist!.name,
                  )
                : null,
          )
        : null,
  );

  @override
  Widget build(BuildContext context) {
    final PlayerViewModel playerVm = context.watch<PlayerViewModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<List<SongDto>>(
            future: _songsFuture,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const SizedBox(
                  height: 168,
                  child: Center(child: CustomLoadingIndicator()),
                );
              }
              if (snap.hasError) {
                return _ErrorBox('Falha ao carregar músicas: ${snap.error}');
              }
              final songs = snap.data ?? [];
              if (songs.isEmpty) {
                return const _ErrorBox('Nenhuma música cadastrada ainda.');
              }

              final featured = songs.take(6).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RecommendationsCarousel(
                    items: featured,
                    onTap: (s) =>
                        context.read<PlayerViewModel>().play(_toSongData(s)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Recomendações',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 22),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Músicas',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              InkWell(
                onTap: () => setState(() => _showAll = !_showAll),
                child: Text(
                  _showAll ? 'Ver menos' : 'Ver mais',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          FutureBuilder<List<SongDto>>(
            future: _songsFuture,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const SizedBox(
                  height: 320,
                  child: Center(child: CustomLoadingIndicator()),
                );
              }
              if (snap.hasError) {
                return _ErrorBox('Falha ao carregar músicas: ${snap.error}');
              }
              final songs = snap.data ?? [];
              if (songs.isEmpty) {
                return const _ErrorBox('Nenhuma música cadastrada ainda.');
              }

              final base = _capByArtist(songs, perArtist: 3);

              final visible = _showAll ? base : base.take(8).toList();

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: .86,
                ),
                itemCount: visible.length,
                itemBuilder: (_, i) {
                  final s = visible[i];
                  return _SongCard(
                    song: s,
                    onTap: () {
                      print("MUSICA ${s.title}");
                      playerVm.playOneSong(SongData.fromDto(s));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PlayerView()),
                      );
                      // context.read<PlayerViewModel>().play(_toSongData(s))
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RecommendationsCarousel extends StatelessWidget {
  final List<SongDto> items;
  final void Function(SongDto) onTap;
  const _RecommendationsCarousel({required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const gradients = [
      [Color(0xFFFFB64D), Color(0xFFFF6C6C)],
      [Color(0xFF74B8FF), Color(0xFF5F7BFF)],
      [Color(0xFF7EF0C1), Color(0xFF05C2A6)],
    ];
    return SizedBox(
      height: 168,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.86),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final t = items[i];
          final g = gradients[i % gradients.length];
          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: g,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => onTap(t),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      '${t.title}\n${t.artist?.name ?? ""}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SongCard extends StatelessWidget {
  final SongDto song;
  final VoidCallback onTap;
  const _SongCard({required this.song, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cover = song.urlCover ?? song.album?.urlCover;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: cover != null && cover.isNotEmpty
                  ? Image.network(
                      cover,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.grey.shade300),
                    )
                  : Container(color: Colors.grey.shade300),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            song.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          Text(
            song.artist?.name ?? 'Artista desconhecido',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String msg;
  const _ErrorBox(this.msg);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Text(
      msg,
      style: TextStyle(color: Colors.red.shade700, fontSize: 12),
    ),
  );
}
