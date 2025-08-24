// lib/components/confirmation_dialog.dart

import 'package:dam_music_streaming/ui/core/ui/svg_icon.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String txtBtn;
  final Color corBtn;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.txtBtn,
    required this.corBtn,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Column(
        children: [
          SvgIcon(assetName: 'assets/icons/Warning.svg', size: 48,color: Color(0xFFE6A919),),
          SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
          ),
        ],
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancelar"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.black,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: corBtn,
            foregroundColor: Colors.black,
          ),
          child: Text(txtBtn),
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsPadding: EdgeInsets.only(bottom: 20),
    );
  }
}