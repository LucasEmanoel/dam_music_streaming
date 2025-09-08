import "dart:io";

import "package:dam_music_streaming/domain/models/user_data_l.dart";
import "package:dam_music_streaming/main.dart";
import "package:dam_music_streaming/ui/core/ui/button_sheet.dart";
import "package:dam_music_streaming/ui/core/ui/custom_snack.dart";
import "package:dam_music_streaming/ui/core/ui/loading.dart";
import "package:dam_music_streaming/ui/core/ui/svg_icon.dart";
import "package:dam_music_streaming/ui/core/user/view_model/user_view_model.dart";
import "package:dam_music_streaming/ui/login/login_inicio.dart";
import "package:dam_music_streaming/ui/profile/view_model/profile_view_model.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class ProfileShowView extends StatelessWidget {
  const ProfileShowView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<ProfileViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) {
          return Scaffold(body: Center(child: CustomLoadingIndicator()));
        }

        final UserViewModel userViewModel = context.read<UserViewModel>();
        final ProfileViewModel profileViewModel = context
            .read<ProfileViewModel>();

        final UsuarioData profileUser = profileViewModel.userProfile!;

        return DefaultTabController(
          length: 4,
          child: Scaffold(
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
                        profileUser.fullName ?? 'Usuário sem nome :)',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        '@${profileUser.username}',
                        style: TextStyle(
                          color: Color(0xFFB7B0B0),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: TabBar(
              tabs: [
                GestureDetector(
                  child: Tab(
                    height: 60,
                    icon: SvgIcon(assetName: 'assets/icons/Home.svg', size: 35),
                  ),
                  onTap: () => {
                    _navigateToSpecificScreen(0, context, userViewModel),
                  },
                ),
                GestureDetector(
                  child: Tab(
                    height: 60,
                    icon: SvgIcon(
                      assetName: 'assets/icons/Search.svg',
                      size: 35,
                    ),
                  ),
                  onTap: () => {
                    _navigateToSpecificScreen(1, context, userViewModel),
                  },
                ),
                GestureDetector(
                  child: Tab(
                    height: 60,
                    icon: SvgIcon(assetName: 'assets/icons/Song.svg', size: 35),
                  ),
                  onTap: () => {
                    _navigateToSpecificScreen(2, context, userViewModel),
                  },
                ),
                GestureDetector(
                  child: Tab(
                    height: 60,
                    icon: SvgIcon(
                      assetName: 'assets/icons/Library.svg',
                      size: 35,
                    ),
                  ),
                  onTap: () => {
                    _navigateToSpecificScreen(3, context, userViewModel),
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _navigateToSpecificScreen(
    int index,
    BuildContext context,
    UserViewModel userViewModel,
  ) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            HomeScaffold(docsDir: userViewModel.docsDir, initialIndex: index),
      ),
    );
  }

  _showModalBottomSheet(BuildContext pageContext, ProfileViewModel pfvm) {
    return showModalBottomSheet(
      context: pageContext,
      builder: (BuildContext _context) {
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
                    Navigator.pop(_context);
                  },
                ),
                ButtonCustomSheet(
                  icon: 'Trash',
                  text: 'Apagar Perfil',
                  iconColor: Colors.red,
                  onTap: () => _deleteUserDialog(pageContext),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteUserDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: Container(
            height: 255,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 54,
                  color: Color(0xFFD08712),
                ),
                const Text(
                  'Atenção!',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  width: 220,
                  child: const Text(
                    'Apagar o seu perfil irá remover permamentemente todas as suas informações do sistema. \n Essa ação não é reversível. ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 24,
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () => {Navigator.of(ctx).pop()},
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Color(0xFFD2D2D2),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(8),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          final ProfileViewModel profileViewModel = context
                              .read<ProfileViewModel>();
                          final UserViewModel userViewModel = context
                              .read<UserViewModel>();

                          try {
                            await profileViewModel.deleteUser();
                          } catch (error) {
                            Navigator.of(ctx).pop();
                            Navigator.of(ctx).pop();

                            showCustomSnackBar(
                              context: context,
                              message: 'Erro ao remover usuário',
                              backgroundColor: Colors.red,
                              icon: Icons.error,
                            );

                            return;
                          }

                          Navigator.of(ctx).pop();

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) =>
                                  LoginInicio(docsDir: userViewModel.docsDir),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Color(0xFFFF3951),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(8),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Apagar',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
