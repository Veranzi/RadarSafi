import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData buildAppTheme() {
  final base = ThemeData(
    fontFamily: 'Poppins',
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentGreen,
      secondary: AppColors.accentBlue,
      surface: AppColors.surface,
      error: AppColors.danger,
    ),
  );

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.backgroundDeep,
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.accentGreen, width: 1.5),
      ),
      hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentGreen,
        foregroundColor: AppColors.backgroundDeep,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        minimumSize: const Size.fromHeight(56),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.textPrimary, width: 1.2),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        minimumSize: const Size.fromHeight(56),
      ),
    ),
  );
}
