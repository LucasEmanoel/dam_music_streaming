import 'package:flutter/material.dart';
import 'package:dam_music_streaming/domain/models/album_data.dart';
import 'package:dam_music_streaming/data/repositories/album_repository.dart';

class AlbumViewModel extends ChangeNotifier {
  final AlbumRepository _repository = AlbumRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<AlbumData> _albums = [];
  List<AlbumData> get albums => _albums;

  AlbumData? _albumBeingViewed;
  AlbumData? get albumBeingViewed => _albumBeingViewed;

  Future<void> viewAlbum(int albumId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _albumBeingViewed = await _repository.fetchDetailedById(albumId);
    } catch (e) {
      print("Erro ao carregar detalhes do álbum: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearAlbumBeingViewed() {
    _albumBeingViewed = null;
    notifyListeners();
  }
}
