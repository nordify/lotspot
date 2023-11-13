import 'package:flutter/material.dart';
import 'package:lotspot/app/color_palette.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: columbiaBlue,
      body: Center(child: Image.asset('assets/logo.png')),
    );
  }
}