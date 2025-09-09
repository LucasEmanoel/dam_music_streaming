import 'dart:async';
import 'dart:collection';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../../../domain/models/song_data.dart';

class PlayerViewModel extends ChangeNotifier {
  final songBaseUrl = 'https://dam-harmony.s3.us-east-1.amazonaws.com/';
  late final AudioPlayer _player;

  SongData? _current;
  bool _isPlaying = false;

  final Queue<SongData> _previousStack = Queue<SongData>();
  Queue<SongData> _queue = Queue<SongData>();
  Queue<SongData> get songsQueue => _queue;

  Duration? _position;
  Duration? _duration;

  SongData? get current => _current;
  bool get isPlaying => _isPlaying;
  Duration? get position => _position;
  Duration? get duration => _duration;
  String get durationText => _duration?.toString().split('.').first ?? '';
  String get positionText => _position?.toString().split('.').first ?? '';

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;

  Timer? _ticker;
  bool get hasTrack => _current != null;

  PlayerViewModel({required AudioPlayer player}) {
    this._player = player;
    this._position = Duration.zero;
    this._duration = Duration.zero;
    notifyListeners();

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

  void _setCurrentSong(SongData song) {
    this._current = song;
    this._player.setSource(UrlSource('$songBaseUrl${song.id}.mp3'));
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

  void addSongToQueue(SongData song) {
    _queue.addFirst(song);
  }

  void playOneSong(SongData song) {
    _player.stop();
    _position = Duration.zero;
    _duration = Duration.zero;

    _current = null;
    _queue.clear();
    _previousStack.clear();

    _setCurrentSong(song);
  }

  void addListToQueue({List<SongData>? list, int? index}) {
    if (list == null || list.isEmpty) return;

    _player.stop();
    _position = Duration.zero;
    _duration = Duration.zero;

    _current = null;
    _queue.clear();
    _previousStack.clear();

    list.forEach((SongData song) {
      _queue.add(song);
    });

    if (index != null) {
      setQueueAtIndex(index);
    } else {
      SongData firstSong = _queue.removeFirst();
      _current = firstSong;
    }

    _player.setSource(UrlSource('$songBaseUrl${_current!.id}.mp3'));
  }

  void jumpNextSong() {
    if (hasNextSong()) {
      SongData nextSong = _queue.removeFirst();
      _previousStack.addFirst(_current!);
      _position = Duration.zero;
      _duration = Duration.zero;
      _setCurrentSong(nextSong);
      notifyListeners();
    }
  }

  void jumpPreviousSong() {
    if (hasPreviousSong()) {
      SongData previousSong = _previousStack.removeFirst();
      _queue.addFirst(_current!);
      _position = Duration.zero;
      _duration = Duration.zero;
      _setCurrentSong(previousSong);
      notifyListeners();
    }
  }

  bool hasNextSong() {
    return _queue.isNotEmpty;
  }

  bool hasPreviousSong() {
    return _previousStack.isNotEmpty;
  }

  void clearQueue() {
    _queue.clear();
    _previousStack.clear();

    notifyListeners();
  }

  void reorderQueue(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;

    SongData temp = _queue.elementAt(oldIndex);
    List<SongData> tempList = _queue.toList();
    tempList.removeAt(oldIndex);
    tempList.insert(newIndex, temp);
    _queue = ListQueue.of(tempList);
    notifyListeners();
  }

  void setQueueAtIndex(int index) {
    _player.stop();
    _position = Duration.zero;
    _duration = Duration.zero;

    final newCurrent = _queue.elementAt(index);

    final before = _queue.take(index).toList();

    final after = _queue.skip(index + 1).toList();

    _previousStack.addAll(before);
    _previousStack.addLast(_current!);

    _queue
      ..clear()
      ..addAll(after);

    _setCurrentSong(newCurrent);

    notifyListeners();
  }

  @override
  void dispose() {
    // _ticker?.cancel();
    super.dispose();
  }
}
