import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      primaryColor: AppColors.primaryLight,
      cardColor: AppColors.cardLight,
      dividerColor: AppColors.textSecondaryLight.withOpacity(0.2),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.textLight),
        displayMedium: TextStyle(color: AppColors.textLight),
        displaySmall: TextStyle(color: AppColors.textLight),
        headlineMedium: TextStyle(color: AppColors.textLight),
        headlineSmall: TextStyle(color: AppColors.textLight),
        titleLarge: TextStyle(color: AppColors.textLight),
        titleMedium: TextStyle(color: AppColors.textLight),
        titleSmall: TextStyle(color: AppColors.textLight),
        bodyLarge: TextStyle(color: AppColors.textLight),
        bodyMedium: TextStyle(color: AppColors.textSecondaryLight),
        bodySmall: TextStyle(color: AppColors.textSecondaryLight),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textLight,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      primaryColor: AppColors.primaryDark,
      cardColor: AppColors.cardDark,
      dividerColor: AppColors.textSecondaryDark.withOpacity(0.2),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.textDark),
        displayMedium: TextStyle(color: AppColors.textDark),
        displaySmall: TextStyle(color: AppColors.textDark),
        headlineMedium: TextStyle(color: AppColors.textDark),
        headlineSmall: TextStyle(color: AppColors.textDark),
        titleLarge: TextStyle(color: AppColors.textDark),
        titleMedium: TextStyle(color: AppColors.textDark),
        titleSmall: TextStyle(color: AppColors.textDark),
        bodyLarge: TextStyle(color: AppColors.textDark),
        bodyMedium: TextStyle(color: AppColors.textSecondaryDark),
        bodySmall: TextStyle(color: AppColors.textSecondaryDark),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textDark,
      ),
    );
  }
}
