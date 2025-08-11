import 'dart:convert';

import 'package:dam_music_streaming/data/dto/playlist_dto.dart';
import 'package:http/http.dart' as http;

class PlaylistApiService {
  static final String _baseUrl = "https://68917f0f447ff4f11fbcb402.mockapi.io";

  static Future<List<PlaylistDto>> listAll() async{
    final url = Uri.parse('$_baseUrl/playlists');

    try{
      final res = await http.get(url);

      if(res.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(res.body);
        return jsonList
            .map((map) => PlaylistDto.fromMap(map as Map<String, dynamic>))
            .toList();
      } else {

        throw Exception('Falha no parsing do json');
      }
    } catch(e) {
      print('erro na req: $e');
      throw Exception('Err: $e');
    }
  }

  static Future<PlaylistDto> getById(String id) async {
    final url = Uri.parse('$_baseUrl/playlists/$id');
    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        return PlaylistDto.fromMap(jsonDecode(res.body));
      } else {
        throw Exception('Falha ao carregar playlist por ID');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  static Future<PlaylistDto> create(PlaylistDto playlist) async {
    final url = Uri.parse('$_baseUrl/playlists');
    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(playlist.toMap()),
      );

      if (res.statusCode == 201) {
        return PlaylistDto.fromMap(jsonDecode(res.body));
      } else {
        throw Exception('Falha ao criar playlist');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  static Future<PlaylistDto> update(String id, PlaylistDto playlist) async {
    final url = Uri.parse('$_baseUrl/playlists/$id');
    try {
      final res = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(playlist.toMap()),
      );

      if (res.statusCode == 200) {
        return PlaylistDto.fromMap(jsonDecode(res.body));
      } else {
        throw Exception('Falha ao atualizar playlist');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  static Future<void> delete(String id) async {
    final url = Uri.parse('$_baseUrl/playlists/$id');
    try {
      final res = await http.delete(url);

      if (res.statusCode != 200) {
        throw Exception('Falha ao deletar playlist');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }
}