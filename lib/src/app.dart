import 'package:flutter/material.dart';

import 'features/splash/splash_screen.dart';
import 'theme/app_theme.dart';

class RadarSafiApp extends StatelessWidget {
  const RadarSafiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RadarSafi',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const SplashScreen(),
    );
  }
}
