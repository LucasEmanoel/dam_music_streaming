// lib/components/confirmation_dialog.dart

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
          Icon(
            Icons.warning,
            color: Color(0xFFE6A919),
            size: 48,
          ),
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
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: Text(txtBtn),
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsPadding: EdgeInsets.only(bottom: 20),
    );
  }
}