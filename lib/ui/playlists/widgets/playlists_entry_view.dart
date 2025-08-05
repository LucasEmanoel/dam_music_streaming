import "dart:io";
import "package:path/path.dart";
import "package:dam_music_streaming/ui/core/ui/input_global.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:provider/provider.dart";

import "../view_model/playlist_view_model.dart";

class PlaylistEntryView extends StatelessWidget{
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Consumer<PlaylistViewModel>(
      builder: (context, vm, child) {
        if (vm.entityBeingEdited != null) {
          _nameController.text = vm.entityBeingEdited!.title;
          _descController.text = vm.entityBeingEdited!.author;
        }

        File coverPlaylistFile = File(join(vm.docsDir.path, "playlist_cover")); //vamos salvar localmente e colocar e mapear com banco

        if (!coverPlaylistFile.existsSync() && vm.entityBeingEdited?.id != null) {
          coverPlaylistFile = File(join(vm.docsDir.path, vm.entityBeingEdited!.id.toString()));
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                FocusScope.of(context).unfocus();
                vm.setStackIndex(0);
              },
            ),
            centerTitle: true,
            title: const Text('Nova Playlist'),
            elevation: 0,
            backgroundColor: theme.scaffoldBackgroundColor,
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Criar playlist"),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_right),
                ],
              ),
              onPressed: () {},
            ),
          ),
          body: Form(
            key: _formKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(

                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: coverPlaylistFile.existsSync() ? FileImage(coverPlaylistFile) : null,
                            child: coverPlaylistFile.existsSync() //TODO: sempre isso vai ter um valor, falar com thais
                                ? null
                                : Icon(
                                  Icons.music_note,
                                  size: 50,
                                  color: Colors.grey.shade600,
                            ),
                          ),
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 80,
                                backgroundColor: Colors.grey.shade300,
                                backgroundImage: coverPlaylistFile.existsSync() ? FileImage(coverPlaylistFile) : null,
                                child: coverPlaylistFile.existsSync()
                                    ? null
                                    : Icon(
                                  Icons.music_note,
                                  size: 50,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => _selectCoverPlaylist(context, vm),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: theme.colorScheme.primary,
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          CustomInputField(
                            controller: _nameController,
                            hintText: 'Nome da Playlist',
                            iconData: Icons.music_note,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'O nome é obrigatório.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomInputField(
                            controller: _descController,
                            hintText: 'Descrição',
                            iconData: Icons.description,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectCoverPlaylist(BuildContext context, PlaylistViewModel vm) async {
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
                    final image = await ImagePicker().pickImage(source: ImageSource.camera);
                    if (image != null) {
                      final file = File(image.path);
                      final dir = vm.docsDir;
                      await file.copy(join(dir.path, "playlist_cover"));
                      vm.triggerRebuild();
                    }
                    Navigator.of(ctx).pop();
                  },
                ),
                Padding(padding: EdgeInsets.all(10)),
                GestureDetector(
                  child: Text("Select From Gallery"),
                  onTap: () async {
                    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      final file = File(image.path);
                      final dir = vm.docsDir;
                      await file.copy(join(dir.path, "avatar"));
                      vm.triggerRebuild();
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

}