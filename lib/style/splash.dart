import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import '../core/app.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 500,
      splash: Icons.android,
      splashIconSize: 160,
      nextScreen: const MyApp(),
      splashTransition: SplashTransition.scaleTransition,
      backgroundColor: Colors.blue,
    );
  }
}
