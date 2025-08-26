import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class DeezerService {
  static const _base = 'https://api.deezer.com';

  Future<List<DzTrack>> topTracks({int limit = 20}) async {
    final url = Uri.parse('$_base/chart/0/tracks?limit=$limit');
    final j = await _get(url);
    final list = (j['data'] as List?) ?? [];
    return list.map((e) => DzTrack.fromJson(e)).toList();
  }

  Future<List<DzAlbum>> topAlbums({int limit = 20}) async {
    final url = Uri.parse('$_base/chart/0/albums?limit=$limit');
    final j = await _get(url);
    final list = (j['data'] as List?) ?? [];
    return list.map((e) => DzAlbum.fromJson(e)).toList();
  }

  Future<DzPlaylist> playlistFromShareLink(String shareUrl) async {
    final id = await _resolvePlaylistId(shareUrl);
    if (id == null) {
      throw Exception('Não foi possível resolver o id da playlist.');
    }
    return playlistById(id);
  }

  Future<DzPlaylist> playlistById(int id) async {
    final meta = await _get(Uri.parse('$_base/playlist/$id'));
    final tracksJson = await _get(Uri.parse('$_base/playlist/$id/tracks?limit=100'));
    final tracks = ((tracksJson['data'] as List?) ?? [])
        .map((e) => DzTrack.fromJson(e))
        .toList();

    return DzPlaylist(
      id: id,
      title: meta['title'] ?? '',
      creatorName: (meta['creator']?['name'] ?? '').toString(),
      pictureUrl: (meta['picture_xl'] ?? meta['picture_big'] ?? meta['picture'])?.toString() ?? '',
      tracks: tracks,
    );
  }

  /// Resolve 'https://link.deezer.com/s/xxxxx' → .../playlist/{id}
  Future<int?> _resolvePlaylistId(String url) async {
    var current = url;
    final reg = RegExp(r'/playlist/(\d+)');

    for (var i = 0; i < 5; i++) {
      final m = reg.firstMatch(current);
      if (m != null) return int.tryParse(m.group(1)!);

      final next = await _fetchRedirectLocation(current);
      if (next == null || next == current) break;
      current = next;
    }
    return null;
  }

  Future<String?> _fetchRedirectLocation(String url) async {
    final client = HttpClient();
    try {
      final req = await client.getUrl(Uri.parse(url));
      req.followRedirects = false;
      final res = await req.close();

      if (res.statusCode >= 300 && res.statusCode < 400) {
        return res.headers.value(HttpHeaders.locationHeader);
      }

      if (res.statusCode == 200) return url;

      return null;
    } finally {
      client.close(force: true);
    }
  }

  Future<Map<String, dynamic>> _get(Uri url) async {
    final r = await http.get(url).timeout(const Duration(seconds: 12));
    if (r.statusCode != 200) {
      throw Exception('HTTP ${r.statusCode}: ${r.body}');
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }
}

class DzPlaylist {
  final int id;
  final String title;
  final String creatorName;
  final String pictureUrl;
  final List<DzTrack> tracks;

  DzPlaylist({
    required this.id,
    required this.title,
    required this.creatorName,
    required this.pictureUrl,
    required this.tracks,
  });
}

class DzTrack {
  final int id;
  final String title;
  final String artistName;
  final String coverUrl;

  DzTrack({
    required this.id,
    required this.title,
    required this.artistName,
    required this.coverUrl,
  });

  factory DzTrack.fromJson(Map<String, dynamic> m) => DzTrack(
    id: m['id'] ?? 0,
    title: m['title'] ?? '',
    artistName: (m['artist']?['name'] ?? '').toString(),
    coverUrl: ((m['album']?['cover_xl'] ??
        m['album']?['cover_big'] ??
        m['album']?['cover']) ??
        '')
        .toString(),
  );
}

class DzAlbum {
  final int id;
  final String title;
  final String artistName;
  final String coverUrl;

  DzAlbum({
    required this.id,
    required this.title,
    required this.artistName,
    required this.coverUrl,
  });

  factory DzAlbum.fromJson(Map<String, dynamic> m) => DzAlbum(
    id: m['id'] ?? 0,
    title: m['title'] ?? '',
    artistName: (m['artist']?['name'] ?? '').toString(),
    coverUrl:
    ((m['cover_xl'] ?? m['cover_big'] ?? m['cover']) ?? '').toString(),
  );
}
