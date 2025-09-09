import 'package:dam_music_streaming/ui/core/ui/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/services/geolocator_service.dart';
import '../../../data/services/playlist_service.dart';
import '../../../data/dto/song_dto.dart';
import '../../core/player/view_model/player_view_model.dart';
import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'package:dam_music_streaming/domain/models/artist_data.dart';
import 'package:dam_music_streaming/domain/models/album_data.dart';
import '../../../data/services/weather_service.dart';

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
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _LocationWeatherCard(),
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
                    onTap: () =>
                        context.read<PlayerViewModel>().play(_toSongData(s)),
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

class _LocationWeatherCard extends StatefulWidget {
  const _LocationWeatherCard();

  @override
  State<_LocationWeatherCard> createState() => _LocationWeatherCardState();
}

class _LocationWeatherCardState extends State<_LocationWeatherCard> {
  static const String _openWeatherApiKey = '06dd098f9449bc492cf6316c89e00047';

  final _location = LocationService();
  late final WeatherService _weather = WeatherService(_openWeatherApiKey);

  String? _city;
  String? _desc;
  String? _main;
  double? _tempC;
  bool _loading = true;
  String? _error;

  static const List<Color> _defaultGradient = [Color(0xFF4B6CB7), Color(0xFF182848)];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final pos = await _location.getCurrentPosition();
      if (pos == null) {
        setState(() {
          _error = 'Ative a localização para ver o clima';
          _loading = false;
        });
        return;
      }

      final city = await _location.getCityFromPosition(pos);
      if (city == null || city.isEmpty) {
        setState(() {
          _error = 'Não consegui identificar sua cidade';
          _loading = false;
        });
        return;
      }

      final w = await _weather.getWeatherFromPosition(city);

      double? tempC;
      String? desc;
      String? main;
      if (w != null) {
        final tempK = w.temperature?.kelvin;
        if (tempK != null) tempC = tempK - 273.15;
        final apiDesc = w.weatherDescription?.toLowerCase();
        desc = descriptionPtBr[apiDesc] ?? apiDesc;
        main = w.weatherMain;
      }

      setState(() {
        _city = city;
        _desc = (desc ?? '').isNotEmpty ? desc : 'boa';
        _main = main;
        _tempC = tempC;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Não foi possível obter o clima (${e.runtimeType}).';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Color> gradientColors =
        weatherGradients[_main ?? ''] ?? _defaultGradient;

    Widget inner;
    if (_loading) {
      inner = const Center(child: CustomLoadingIndicator());
    } else if (_error != null) {
      inner = Row(
        children: [
          Expanded(
            child: Text(
              _error!,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
              foregroundColor: Colors.white,
            ),
            onPressed: _load,
            child: const Text('Tentar novamente'),
          ),
        ],
      );
    } else {
      inner = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá!',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white.withOpacity(.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Clima de ${_desc ?? 'festa'}\ntemos uma playlist\nperfeita pra você',
                  maxLines: 3,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 6),
                if (_city != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _city!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _tempC != null ? '${_tempC!.round()}°' : '--°',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              const Icon(Icons.chevron_right, color: Colors.white, size: 24),
            ],
          ),
        ],
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 144),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _loading || _error != null ? null : () {
            DefaultTabController.of(context).animateTo(1);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: inner,
          ),
        ),
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

Map<String, List<Color>> weatherGradients = {
  'Clear': [Color(0xFFFFD54F), Color(0xFFFFB300)],
  'Clouds': [Color(0xFF90A4AE), Color(0xFF546E7A)],
  'Rain': [Color(0xFF4FC3F7), Color(0xFF0288D1)],
  'Drizzle': [Color(0xFF81D4FA), Color(0xFF4FC3F7)],
  'Thunderstorm': [Color(0xFF5C6BC0), Color(0xFF1A237E)],
  'Snow': [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
  'Mist': [Color(0xFFB0BEC5), Color(0xFF90A4AE)],
  'Smoke': [Color(0xFFB0BEC5), Color(0xFF757575)],
  'Haze': [Color(0xFFB0BEC5), Color(0xFF9E9E9E)],
  'Dust': [Color(0xFFE0B084), Color(0xFFB27C4B)],
  'Fog': [Color(0xFFB0BEC5), Color(0xFF90A4AE)],
  'Sand': [Color(0xFFE0B084), Color(0xFFC48A3A)],
  'Ash': [Color(0xFF8D6E63), Color(0xFF5D4037)],
  'Squall': [Color(0xFF4FC3F7), Color(0xFF1565C0)],
  'Tornado': [Color(0xFF616161), Color(0xFF212121)],
};

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

const Map<String, String> descriptionPtBr = {
  'light rain': 'chuva fraca',
  'moderate rain': 'chuva moderada',
  'clear sky': 'céu limpo',
  'few clouds': 'poucas nuvens',
  'broken clouds': 'nuvens dispersas',
  'light snow': 'neve leve',
  'mist': 'névoa',
  'fog': 'neblina',
};