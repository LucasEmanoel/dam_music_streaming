import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../../../domain/models/song_data.dart';

class PlayerViewModel extends ChangeNotifier {
  final songBaseUrl = 'https://dam-harmony.s3.us-east-1.amazonaws.com/';
  late final AudioPlayer _player;

  SongData? _current;
  bool _isPlaying = false;

  Duration? _position;
  Duration? _duration;
  Timer? _ticker;

  SongData? get current => _current;
  bool get isPlaying => _isPlaying;
  Duration? get position => _position;
  Duration? get duration => _duration;
  String get durationText => _duration?.toString().split('.').first ?? '';
  String get positionText => _position?.toString().split('.').first ?? '';

  bool get hasTrack => _current != null;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;

  PlayerViewModel({required AudioPlayer player}) {
    this._player = player;
    this._position = Duration.zero;
    this._duration = Duration.zero;
    notifyListeners();

    // player.getDuration().then(
    //   (value) => (value) {
    //     print(value);
    //     _duration = value;
    //     notifyListeners();
    //   },
    // );
    // player.getCurrentPosition().then((value) => {_position = value});

    _initStreams();
  }

  void _initStreams() {
    _durationSubscription = _player.onDurationChanged.listen((Duration d) {
      _duration = d;
      notifyListeners();
    });

    _positionSubscription = _player.onPositionChanged.listen((Duration p) {
      _position = p;
      notifyListeners();
    });

    _playerCompleteSubscription = _player.onPlayerComplete.listen((_) {
      _position = Duration.zero;
      _isPlaying = false;
      notifyListeners();
    });
  }

  void play(SongData s) {
    _current = s;
    _isPlaying = true;
    _position = Duration.zero;
    _duration = s.duration ?? const Duration(minutes: 3);
    // _startTicker();
    notifyListeners();
  }

  Future<void> toggle() async {
    _isPlaying = !_isPlaying;
    if (_isPlaying) {
      await _player.resume();
      // _startTicker();
    } else {
      await _player.pause();
      // _ticker?.cancel();
    }
    notifyListeners();
  }

  void setCurrentSong(SongData song) {
    this._current = song;
    this._player.setSource(UrlSource('$songBaseUrl${song.id}.mp3'));
  }

  void next() {
    // TODO: integrar com fila/playlist
  }

  // void _startTicker() {
  //   _ticker?.cancel();
  //   _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
  //     if (!_isPlaying) return;
  //     final nextPos = _position + const Duration(seconds: 1);
  //     _position = nextPos >= _duration ? _duration : nextPos;
  //     if (_position >= _duration) {
  //       _isPlaying = false;
  //       _ticker?.cancel();
  //     }
  //     notifyListeners();
  //   });
  // }

  void changeTimeMusicPlaying(double miliseconds) {
    _player.seek(Duration(milliseconds: miliseconds.round()));
    notifyListeners();
  }

  @override
  void dispose() {
    // _ticker?.cancel();
    super.dispose();
  }
}
