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
}