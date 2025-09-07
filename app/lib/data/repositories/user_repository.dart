import 'package:dam_music_streaming/data/dto/song_dto.dart';
import 'package:dam_music_streaming/data/dto/user_dto_l.dart';
import 'package:dam_music_streaming/data/services/playlist_service.dart';
import 'package:dam_music_streaming/data/services/usuario_service.dart';
import 'package:dam_music_streaming/domain/models/song_data.dart';
import 'package:dam_music_streaming/domain/models/user_data_l.dart';

class UserRepository {
  final UserApiService api = UserApiService();

  Future<UsuarioData> updateProfile(int id, UsuarioData user) async {
    final UsuarioDto userDto = UsuarioDto.fromData(user);
    final UsuarioDto updatedDto = await api.updateProfile(id, userDto);
    return UsuarioData.fromDto(updatedDto);
  }

  Future<UsuarioData> getProfile(int id) async {
    final UsuarioDto updatedDto = await api.getProfile(id);
    return UsuarioData.fromDto(updatedDto);
  }

  Future<void> deleteUser(int id) async {
    await api.deleteUser(id);
  }
}
