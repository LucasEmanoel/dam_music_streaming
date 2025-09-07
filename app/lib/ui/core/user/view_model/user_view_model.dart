import 'dart:io';
import 'dart:math';

import 'package:dam_music_streaming/data/repositories/user_repository.dart';
import 'package:dam_music_streaming/domain/models/user_data_l.dart';
import 'package:flutter/cupertino.dart';

class UserViewModel extends ChangeNotifier {
  final Directory docsDir;
  final UserRepository _repository = UserRepository();

  UsuarioData? loggedUser;

  UserViewModel(this.docsDir);

  void setLoggedUser(UsuarioData userData) {
    loggedUser = userData;
    notifyListeners();
  }

  ImageProvider getUserProfilePicture() {
    if (loggedUser != null &&
        loggedUser!.profilePicUrl != null &&
        loggedUser!.profilePicUrl!.isNotEmpty) {
      return Image.network(loggedUser!.profilePicUrl!).image;
    }
    return Image.asset('assets/profile/default.jpg').image;
  }
}
