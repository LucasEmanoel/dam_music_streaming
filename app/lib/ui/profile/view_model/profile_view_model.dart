import 'dart:io';

import 'package:dam_music_streaming/data/repositories/user_repository.dart';
import 'package:dam_music_streaming/data/services/storage_service.dart';
import 'package:dam_music_streaming/domain/models/user_data_l.dart';
import 'package:dam_music_streaming/ui/core/user/view_model/user_view_model.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  int _stackIndex = 0;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UsuarioData? entityBeingEdited;
  UsuarioData? userProfile;
  File? _pickedImageFile;
  File? get pickedImageFile => _pickedImageFile;

  int get stackIndex => _stackIndex;

  UserViewModel _userViewModel;

  final StorageService storageService = StorageService();
  final UserRepository repository = UserRepository();

  ProfileViewModel(this._userViewModel);

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

  Future<void> getUserProfile() async {
    _isLoading = true;
    notifyListeners();

    int id = _userViewModel.loggedUser!.id!;

    try {
      userProfile = await repository.getProfile(id);
      _userViewModel.setLoggedUser(userProfile!);
    } catch (e) {
      print('error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateLoggedUser() async {
    if (entityBeingEdited == null) return;

    if (entityBeingEdited!.fullName!.isEmpty &&
        entityBeingEdited!.username!.isEmpty)
      return;

    int id = userProfile!.id!;

    if (_pickedImageFile != null) {
      final imageUrl = await storageService.uploadUserProfilePicture(
        profileId: id,
        imageFile: _pickedImageFile!,
      );
      entityBeingEdited!.profilePicUrl = imageUrl;
    }

    UsuarioData responseUser = await repository.updateProfile(
      id,
      entityBeingEdited!,
    );

    userProfile = responseUser;
    notifyListeners();
    _userViewModel.loggedUser = responseUser;
    notifyListeners();
  }

  Future<void> deleteUser() async {
    await repository.deleteUser(userProfile!.id!);

    try {
      userProfile = null;
      _userViewModel.loggedUser = null;
      _isLoading = true;
      notifyListeners();
    } catch (e) {
      print('error: $e');
    }
  }

  void setPickedImage(File? file) {
    _pickedImageFile = file;
    notifyListeners();
  }
}
