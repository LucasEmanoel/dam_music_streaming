import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dam_music_streaming/ui/core/ui/svg_icon.dart';
import 'package:dam_music_streaming/ui/login/login_inicio.dart';

class SplashPage extends StatefulWidget {
  final Directory docsDir;
  const SplashPage({super.key, required this.docsDir});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl =
  AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  late final Animation<double> _fade =
  Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
    parent: _ctrl,
    curve: Curves.easeOut,
  ));

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _ctrl.forward();
    });

    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LoginInicio(docsDir: widget.docsDir),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF6C63FF);

    return Scaffold(
      backgroundColor: bg,
      body: FadeTransition(
        opacity: _fade,
        child: Center(
          child: const SvgIcon(
            assetName: 'assets/icons/Logo.svg',
            size: 100,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
