import 'dart:io';

import 'package:flutter/material.dart';

class ImageRoundEdit extends StatelessWidget {

  final GestureTapCallback? onTap;
  final File? localImageFile;
  final String? networkImageUrl;

  const ImageRoundEdit({
    super.key,
    this.onTap,
    this.localImageFile,
    this.networkImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? backgroundImage;

    if (localImageFile != null) {
      backgroundImage = FileImage(localImageFile!);
    } else if (networkImageUrl != null && networkImageUrl!.isNotEmpty) {
      backgroundImage = NetworkImage(networkImageUrl!);
    }

    return Stack(
      children: [
        CircleAvatar(
          radius: 80,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: backgroundImage,
          child: backgroundImage == null
              ? Icon(
                Icons.music_note,
                size: 50,
                color: Colors.grey.shade600,
          )
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              radius: 20,
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}