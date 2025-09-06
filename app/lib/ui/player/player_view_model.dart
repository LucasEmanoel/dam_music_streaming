import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/models/song_data.dart';

class PlayerViewModel extends ChangeNotifier {
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

  void play(SongData s) {
    _current = s;
    _isPlaying = true;
    _position = Duration.zero;
    _duration = s.duration ?? const Duration(minutes: 3);
    _startTicker();
    notifyListeners();
  }

  void toggle() {
    _isPlaying = !_isPlaying;
    if (_isPlaying) {
      _startTicker();
    } else {
      _ticker?.cancel();
    }
    notifyListeners();
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
