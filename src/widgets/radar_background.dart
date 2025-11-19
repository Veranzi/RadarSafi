import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class RadarBackground extends StatelessWidget {
  const RadarBackground({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.backgroundMid, AppColors.backgroundDeep],
        ),
      ),
      child: SafeArea(
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
