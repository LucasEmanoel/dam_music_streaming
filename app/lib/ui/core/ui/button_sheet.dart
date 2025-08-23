import 'package:dam_music_streaming/ui/core/ui/svg_icon.dart';
import 'package:flutter/material.dart';

class ButtonCustomSheet extends StatelessWidget {
  final String icon;
  final Color? iconColor;
  final Color? textColor;
  final Color? btnColor;
  final String text;
  final VoidCallback onTap;

  const ButtonCustomSheet({
    super.key,
    required this.icon,
    this.iconColor,
    this.textColor,
    this.btnColor,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: btnColor,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(16),

      ),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black
        ),
        onPressed: onTap,
        child: Row(
          children: [
            SvgIcon(assetName: 'assets/icons/$icon.svg', size: 22, color: iconColor,),
            SizedBox(width: 15),
            Text(text),
          ],
        ),
      ),
    );
  }
}