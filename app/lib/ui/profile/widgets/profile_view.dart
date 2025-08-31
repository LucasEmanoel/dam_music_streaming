import 'dart:io';

import 'package:dam_music_streaming/ui/profile/view_model/profile_view_model.dart';
import 'package:dam_music_streaming/ui/profile/widgets/profile_entry_view.dart';
import 'package:dam_music_streaming/ui/profile/widgets/profile_show_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  final Directory _docsDir;

  const ProfileView({super.key, required Directory docsDir})
    : _docsDir = docsDir;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileViewModel>(
      create: (context) {
        final vm = ProfileViewModel();
        return vm;
      },
      child: Consumer<ProfileViewModel>(
        builder: (context, vm, child) {
          return IndexedStack(
            index: vm.stackIndex,
            children: [ProfileShowView(), ProfileEntryView()],
          );
        },
      ),
    );
  }
}
