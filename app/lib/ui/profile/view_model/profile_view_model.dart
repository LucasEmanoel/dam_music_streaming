import 'dart:io';

import 'package:dam_music_streaming/domain/models/user_data_l.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  int _stackIndex = 0;

  UsuarioData? entityBeingEdited;
  File? _pickedImageFile;

  int get stackIndex => _stackIndex;

  void setStackIndex(int index) {
    _stackIndex = index;
    if (index == 0) {
      entityBeingEdited = null;
      _pickedImageFile = null;
    }
    notifyListeners();
  }

  void startEditing() {
    _pickedImageFile = null;
    entityBeingEdited = UsuarioData(
      username: '',
      fullName: '',
      role: '',
      email: '',
    );
    notifyListeners();
  }
}
