import 'package:flutter/material.dart';
import '../../../data/services/music_service.dart';

class HomeFeed extends StatefulWidget {
  const HomeFeed({super.key});
  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  final DeezerService api = DeezerService();

  static const sharedUrl = 'https://link.deezer.com/s/30Oai2Rto3meko6tgOj2c';


  late final Future<DzPlaylist> _userPlaylist = api.playlistFromShareLink(sharedUrl);
  late final Future<List<DzAlbum>> _albums = api.topAlbums(limit: 8);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<DzPlaylist>(
            future: _userPlaylist,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const SizedBox(height: 168, child: Center(child: CircularProgressIndicator()));
              }
              if (snap.hasError) {
                return _ErrorBox('Falha ao carregar a playlist compartilhada: ${snap.error}');
              }
              final pl = snap.data!;
              final items = pl.tracks.take(6).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RecommendationsCarousel(items: items),
                  const SizedBox(height: 8),
                  Text(pl.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text('de ${pl.creatorName}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              );
            },
          ),

          const SizedBox(height: 22),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Lançamentos', style: TextStyle(fontWeight: FontWeight.w700)),
              Text('Ver todos'),
            ],
          ),
          const SizedBox(height: 10),
          FutureBuilder<List<DzAlbum>>(
            future: _albums,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const SizedBox(height: 320, child: Center(child: CircularProgressIndicator()));
              }
              if (snap.hasError) {
                return _ErrorBox('Não foi possível carregar lançamentos: ${snap.error}');
              }
              final albums = snap.data ?? [];
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: .80),
                itemCount: albums.length,
                itemBuilder: (_, i) => _AlbumTile(album: albums[i]),
              );
            },
          ),
        ],
      ),
    );
  }
}

// --- UI helpers (mesmos do exemplo anterior) ---
class _RecommendationsCarousel extends StatelessWidget {
  final List<DzTrack> items;
  const _RecommendationsCarousel({required this.items});

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
                gradient: LinearGradient(colors: g, begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(18),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {}, // abrir player/detalhe
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      '${t.title}\n${t.artistName}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
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

class _AlbumTile extends StatelessWidget {
  final DzAlbum album;
  const _AlbumTile({required this.album});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(album.coverUrl, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300)),
          ),
        ),
        const SizedBox(height: 6),
        Text(album.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
        Text(album.artistName, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      ],
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String msg;
  const _ErrorBox(this.msg);
  @override
  Widget build(BuildContext context) =>
      Padding(padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(msg, style: TextStyle(color: Colors.red.shade700, fontSize: 12)));
}
