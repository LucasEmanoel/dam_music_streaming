import 'dart:ui';

import 'package:dam_music_streaming/ui/core/player/view_model/player_view_model.dart';
import 'package:dam_music_streaming/ui/core/ui/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dam_music_streaming/ui/artist/widgets/artist_detail.dart';
import 'package:dam_music_streaming/ui/album/widgets/album_detail.dart';
import 'package:dam_music_streaming/ui/core/ui/button_sheet.dart';
import 'package:dam_music_streaming/ui/playlists/view_model/playlist_view_model.dart';
import 'package:dam_music_streaming/domain/models/playlist_data.dart';
import 'package:dam_music_streaming/data/services/genre_service.dart';
import 'package:dam_music_streaming/data/dto/genre_detail_dto.dart';
import 'package:dam_music_streaming/data/dto/song_dto.dart';
import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'package:dam_music_streaming/domain/models/artist_data.dart';
import 'package:dam_music_streaming/domain/models/album_data.dart';
import 'package:dam_music_streaming/ui/core/ui/info_tile.dart';

class GenreDetailPage extends StatefulWidget {
  final int genreId;
  const GenreDetailPage({super.key, required this.genreId});

  @override
  State<GenreDetailPage> createState() => _GenreDetailPageState();
}

class _GenreDetailPageState extends State<GenreDetailPage> {
  final _api = GenreApiService();
  late final Future<GenreDetailDto> _future = _api.fetchGenreDetail(
    widget.genreId,
  );

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
    final theme = Theme.of(context);
    return FutureBuilder<GenreDetailDto>(
      future: _future,
      builder: (_, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CustomLoadingIndicator()),
          );
        }
        if (snap.hasError || snap.data == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text(
                'Erro ao carregar gênero: ${snap.error ?? "desconhecido"}',
              ),
            ),
          );
        }

        final data = snap.data!;
        final g = data.genre;
        final genreCover = g.coverUrl?.isNotEmpty == true
            ? g.coverUrl!
            : _genreCovers[g.name.toLowerCase()] ??
                  'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400';

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar.large(
                pinned: true,
                expandedHeight: 260,
                backgroundColor: theme.colorScheme.surface,
                flexibleSpace: LayoutBuilder(
                  builder: (context, c) {
                    final hero = _genreHeroImage(g.coverUrl, g.name);
                    final artistsCount = data.topArtists.length;
                    final albumsCount = data.recentAlbums.length;
                    final songsCount = data.topSongs.length;

                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      titlePadding: const EdgeInsetsDirectional.only(
                        start: 51,
                        bottom: 16,
                      ),
                      title: Text(
                        g.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          letterSpacing: .2,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.white,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          // imagem (network com fallback por gênero)
                          DecoratedBox(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: hero,
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: const SizedBox.expand(),
                          ),
                          // blur leve
                          Positioned.fill(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                              child: Container(
                                color: Colors.black.withOpacity(0.10),
                              ),
                            ),
                          ),
                          // gradiente para legibilidade
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black54],
                              ),
                            ),
                          ),
                          // subtítulo com contagens
                          Positioned(
                            left: 16,
                            right: 16,
                            bottom: 56, // fica acima do título
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _StatChip(label: '$artistsCount artistas'),
                                _StatChip(label: '$albumsCount álbuns'),
                                _StatChip(label: '$songsCount músicas'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Top artistas
              if (data.topArtists.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Top artistas',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              if (data.topArtists.isNotEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 112,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: data.topArtists.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) {
                        final a = data.topArtists[i];
                        return InkWell(
                          borderRadius: BorderRadius.circular(40),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ArtistDetailView(artistId: a.id),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 36,
                                backgroundImage: a.pictureBig.isNotEmpty
                                    ? NetworkImage(a.pictureBig)
                                    : null,
                                backgroundColor: Colors.grey.shade300,
                                child: a.pictureBig.isEmpty
                                    ? Text(
                                        a.name.isNotEmpty
                                            ? a.name.characters.first
                                            : '?',
                                      )
                                    : null,
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 90,
                                child: Text(
                                  a.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

              // Álbuns recentes
              if (data.recentAlbums.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Álbuns recentes',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              if (data.recentAlbums.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    delegate: SliverChildBuilderDelegate((_, i) {
                      final alb = data.recentAlbums[i];
                      final cover = alb.urlCover ?? '';
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AlbumDetailView(albumId: alb.id),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: (alb.urlCover ?? '').isNotEmpty
                                    ? Image.network(
                                        alb.urlCover!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: Colors.grey.shade300,
                                        ),
                                      )
                                    : Container(color: Colors.grey.shade300),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              alb.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              alb.artist?.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    }, childCount: data.recentAlbums.length),
                  ),
                ),

              // Músicas populares
              if (data.topSongs.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Músicas populares',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              if (data.topSongs.isNotEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate((_, i) {
                    final s = data.topSongs[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: InfoTile(
                        imageUrl: s.urlCover ?? s.album?.urlCover ?? '',
                        title: s.title,
                        subtitle: s.artist?.name ?? '',
                        trailing: const Icon(Icons.play_arrow),
                        onTap: () => context.read<PlayerViewModel>().play(
                          _toSongData(s),
                        ),
                      ),
                    );
                  }, childCount: data.topSongs.length),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  const _StatChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.28),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: .2,
        ),
      ),
    );
  }
}

const Map<String, String> _genreCovers = {
  'pop': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=1200',
  'rock': 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=1200',
  'hiphop':
      'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=1200',
  'rap': 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=1200',
  'r&b': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=1200',
  'randb':
      'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=1200',
  'jazz': 'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=1200',
  'classical':
      'https://images.unsplash.com/photo-1518972559570-7cc1309f3229?w=1200',
  'electronic':
      'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=1200',
  'indie':
      'https://images.unsplash.com/photo-1541701494587-cb58502866ab?w=1200',
  'sertanejo':
      'https://images.unsplash.com/photo-1508057198894-247b23fe5ade?w=1200',
  'default':
      'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=1200',
};

ImageProvider _genreHeroImage(String? coverUrl, String name) {
  final fromApi = (coverUrl != null && coverUrl.isNotEmpty) ? coverUrl : null;
  final fromMap = _genreCovers[name.toLowerCase()];
  final selected = fromApi ?? fromMap ?? _genreCovers['default']!;
  return NetworkImage(selected);
}
