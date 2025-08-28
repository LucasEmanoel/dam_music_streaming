import 'package:flutter/material.dart';
import "package:loading_animation_widget/loading_animation_widget.dart";

class CustomLoadingIndicator extends StatelessWidget {
  final double size;
  final Color leftDotColor;
  final Color rightDotColor;

  const CustomLoadingIndicator({
    super.key,
    this.size = 60.0,
    this.leftDotColor = const Color(0xFF1A1A3F),
    this.rightDotColor = const Color(0xFF6C63FF),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.flickr(
        leftDotColor: leftDotColor,
        rightDotColor: rightDotColor,
        size: size,
      ),
    );
  }
}