import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../../../domain/models/song_data.dart';

class PlayerViewModel extends ChangeNotifier {
  final AudioPlayer _player;

  SongData? _current;
  bool _isPlaying = false;

  Duration _position = Duration.zero;
  Duration _duration = const Duration(minutes: 3);
  Timer? _ticker;

  SongData? get current => _current;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;

  bool get hasTrack => _current != null;

  PlayerViewModel({required AudioPlayer player}) : this._player = player;

  void play(SongData s) {
    _current = s;
    _isPlaying = true;
    _position = Duration.zero;
    _duration = s.duration ?? const Duration(minutes: 3);
    _startTicker();
    notifyListeners();
  }

  Future<void> toggle() async {
    _isPlaying = !_isPlaying;
    if (_isPlaying) {
      await _player.resume();
      _startTicker();
    } else {
      await _player.stop();
      _ticker?.cancel();
    }
    notifyListeners();
  }

  void setCurrentSong(SongData song) {
    this._current = song;
    this._player.setSource(
      UrlSource(
        'https://dam-harmony.s3.us-east-1.amazonaws.com/${song.id}.mp3',
      ),
    );
  }

  void next() {
    // TODO: integrar com fila/playlist
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isPlaying) return;
      final nextPos = _position + const Duration(seconds: 1);
      _position = nextPos >= _duration ? _duration : nextPos;
      if (_position >= _duration) {
        _isPlaying = false;
        _ticker?.cancel();
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
