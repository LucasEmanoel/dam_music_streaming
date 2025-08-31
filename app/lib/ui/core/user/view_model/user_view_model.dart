import 'dart:io';

import 'package:dam_music_streaming/domain/models/user_data_l.dart';
import 'package:flutter/cupertino.dart';

class UserViewModel extends ChangeNotifier {
  final Directory docsDir;

  UsuarioData? loggedUser;
  File? userProfilePicture;

  UserViewModel(this.docsDir);

  void addLoggedUser(UsuarioData userData) {
    loggedUser = userData;
  }

  void setProfilePicture() {}

  ImageProvider getUserProfilePicture() {
    if (userProfilePicture != null) {}
    return Image.asset('assets/profile/default.jpg').image;
  }

  void updateLoggedUser(UsuarioData? updatedUser) {
    if (updatedUser == null) return;

    if (updatedUser.fullName!.isEmpty && updatedUser.username.isEmpty) return;

    loggedUser!.username = updatedUser.username;
    loggedUser!.fullName = updatedUser.fullName;
    notifyListeners();
  }
}
