import 'package:flutter/material.dart';

class AppColors {
  // Base colors
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color accent = Color(0xFF03A9F4);
  static const Color error = Color(0xFFB00020);

  // Light theme colors
  static const Color primaryLight = Color(0xFF2196F3);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1A1C1E);
  static const Color lightTextSecondary = Color(0xFF666666);

  // Dark theme colors
  static const Color primaryDark = Color(0xFF1A1C1E);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);

  // On colors
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onBackground = Color(0xFF000000);
  static const Color onSurface = Color(0xFF000000);
  static const Color onError = Color(0xFFFFFFFF);

  // Priority colors
  static final Map<String, Color> priorityColors = {
    'critical': Colors.red.shade400,
    'high': Colors.orange.shade400,
    'medium': Colors.yellow.shade700,
    'low': Colors.green.shade400,
  };

  // Add these color getters
  static Color get background => isDarkMode ? backgroundDark : backgroundLight;
  static Color get card => isDarkMode ? cardDark : cardLight;
  static Color get textPrimary =>
      isDarkMode ? darkTextPrimary : lightTextPrimary;
  static Color get textSecondary =>
      isDarkMode ? darkTextSecondary : lightTextSecondary;

  // Add this helper
  static bool get isDarkMode =>
      WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
}
