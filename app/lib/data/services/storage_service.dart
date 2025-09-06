import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadPlaylistCover({
    required int playlistId,
    required File imageFile,
  }) async {
    try {
      final ref = _storage.ref('playlist_covers/$playlistId.jpg');
      final uploadTask = await ref.putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print('Erro no upload para o Firebase Storage: $e');
      rethrow;
    }
  }

  Future<void> deletePlaylistCover(int id) async {}
}
