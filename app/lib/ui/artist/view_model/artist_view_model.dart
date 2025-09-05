import 'package:flutter/material.dart';
import 'package:dam_music_streaming/domain/models/artist_data.dart';
import 'package:dam_music_streaming/data/repositories/artist_repository.dart';

class ArtistViewModel extends ChangeNotifier {
  final ArtistRepository _repository = ArtistRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<ArtistData> _artists = [];
  List<ArtistData> get artists => _artists;

  ArtistData? _artistBeingViewed;
  ArtistData? get artistBeingViewed => _artistBeingViewed;

  Future<void> viewArtist(int artistId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _artistBeingViewed = await _repository.fetchById(artistId);
    } catch (e) {
      print("Erro ao carregar detalhes do artista: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearArtistBeingViewed() {
    _artistBeingViewed = null;
    notifyListeners();
  }
}