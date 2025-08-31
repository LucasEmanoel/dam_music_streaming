import "dart:io";

import "package:dam_music_streaming/domain/models/user_data_l.dart";
import "package:dam_music_streaming/ui/core/ui/button_sheet.dart";
import "package:dam_music_streaming/ui/core/user/view_model/user_view_model.dart";
import "package:dam_music_streaming/ui/profile/view_model/profile_view_model.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class ProfileShowView extends StatelessWidget {
  const ProfileShowView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final UserViewModel userViewModel = context.read<UserViewModel>();

    final UsuarioData loggedUser = userViewModel.loggedUser!;

    return Consumer<ProfileViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: theme.iconTheme.color,
                size: 30,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            title: const Text(
              'Perfil',
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.more_horiz_sharp,
                  color: theme.iconTheme.color,
                  size: 25,
                ),
                onPressed: () {
                  _showModalBottomSheet(context, vm);
                },
              ),
            ],
            elevation: 0,
            centerTitle: true,
          ),
          body: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  spacing: 3,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.indigoAccent,
                      maxRadius: 50,
                      backgroundImage: userViewModel.getUserProfilePicture(),
                    ),
                    Text(
                      loggedUser.fullName ?? 'Nome do user',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '@${loggedUser.username}',
                      style: TextStyle(color: Color(0xFFB7B0B0), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _showModalBottomSheet(BuildContext pageContext, ProfileViewModel pfvm) {
    return showModalBottomSheet(
      context: pageContext,
      builder: (BuildContext context) {
        return Container(
          width: 10000,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ButtonCustomSheet(
                  icon: 'Edit',
                  text: 'Editar Perfil',
                  onTap: () {
                    pfvm.startEditing();
                    pfvm.setStackIndex(1);
                    Navigator.pop(context);
                  },
                ),
                ButtonCustomSheet(
                  icon: 'Trash',
                  text: 'Apagar Perfil',
                  iconColor: Colors.red,
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
