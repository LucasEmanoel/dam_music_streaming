import 'dart:io';

import 'package:dam_music_streaming/data/services/api_service.dart';
import 'package:dam_music_streaming/domain/models/user_data_l.dart';
import 'package:dam_music_streaming/ui/core/ui/custom_snack.dart';
import 'package:dam_music_streaming/ui/core/ui/image_edit.dart';
import 'package:dam_music_streaming/ui/core/ui/input_global.dart';
import 'package:dam_music_streaming/ui/core/ui/loading.dart';
import 'package:dam_music_streaming/ui/core/user/view_model/user_view_model.dart';
import 'package:dam_music_streaming/ui/profile/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileEntryView extends StatelessWidget {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  ProfileEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final UserViewModel userViewModel = context.read<UserViewModel>();
    final ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    final UsuarioData? userProfile = profileViewModel?.userProfile;

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Consumer<ProfileViewModel>(
      builder: (context, profileViewModel, child) {
        _fullNameController.text = userProfile?.fullName ?? '';
        _usernameController.text = userProfile?.username ?? '';

        if(profileViewModel.isLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Editar Perfil',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
              elevation: 0,
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomLoadingIndicator(),
                  SizedBox(height: 16),
                  Text('Salvando...'),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: theme.iconTheme.color,
                size: 30,
              ),
              onPressed: () {
                profileViewModel.setStackIndex(0);
              },
            ),
            title: const Text(
              'Editar Perfil',
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
            elevation: 0,
            centerTitle: true,
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Form(
                  key: _formKey,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            children: [
                              ImageRoundEdit(
                                localImageFile:
                                    profileViewModel.pickedImageFile,
                                networkImageUrl: profileViewModel
                                    .entityBeingEdited
                                    ?.profilePicUrl,
                                onTap: () => _selectCoverProfile(
                                  context,
                                  profileViewModel,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Column(
                                spacing: 16,
                                children: [
                                  ProfileTextInputField(
                                    label: 'Nome',
                                    controller: _fullNameController,
                                    onChanged: (v) =>
                                        profileViewModel
                                                .entityBeingEdited!
                                                .fullName =
                                            v,
                                  ),
                                  ProfileTextInputField(
                                    label: 'Username',
                                    controller: _usernameController,
                                    onChanged: (v) => v != null
                                        ? profileViewModel
                                                  .entityBeingEdited!
                                                  .username =
                                              v
                                        : null,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 35),
                              FilledButton(
                                style: ButtonStyle(
                                  minimumSize: WidgetStateProperty.all(
                                    const Size(200, 50),
                                  ),
                                  backgroundColor: WidgetStateProperty.all(
                                    Color(0xFF6C63FF),
                                  ),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(12),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  updateProfileInfo(
                                    context,
                                    profileViewModel,
                                    userViewModel,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Salvar",
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: Color(0xFFFFFFFF),
                                      size: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void updateProfileInfo(
    BuildContext context,
    ProfileViewModel profileViewModel,
    UserViewModel userViewModel,
  ) async {
    print('updateProfileInfo ${profileViewModel.entityBeingEdited}');
    await profileViewModel.updateLoggedUser();

    profileViewModel.setStackIndex(0);
    
    showCustomSnackBar(
      context: context,
      message: 'Usuário Atualizado',
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
    );

  }
}

Future<void> _selectCoverProfile(
  BuildContext context,
  ProfileViewModel vm,
) async {
  await showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              GestureDetector(
                child: Text("Take a picture"),
                onTap: () async {
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    final file = File(image.path);
                    vm.setPickedImage(file);
                  }
                  Navigator.of(ctx).pop();
                },
              ),
              Padding(padding: EdgeInsets.all(10)),
              GestureDetector(
                child: Text("Select From Gallery"),
                onTap: () async {
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    final file = File(image.path);
                    vm.setPickedImage(file);
                  }
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class ProfileTextInputField extends StatelessWidget {
  final String _label;
  final TextEditingController _controller;
  final void Function(String?) _onChanged;

  const ProfileTextInputField({
    super.key,
    required String label,
    required TextEditingController controller,
    required void Function(String?) onChanged,
  }) : _label = label,
       _controller = controller,
       _onChanged = onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            _label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          TextFormField(
            controller: _controller,
            style: TextStyle(fontSize: 14),
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            onChanged: _onChanged,
          ),
        ],
      ),
    );
  }
}
