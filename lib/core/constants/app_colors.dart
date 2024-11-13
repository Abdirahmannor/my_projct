import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color lightBackground =
      Color(0xFFF8FAFC); // Very light blue-white
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure white
  static const Color lightBorder = Color(0xFFE2E8F0); // Light gray border
  static const Color lightDivider = Color(0xFFEDF2F7); // Very light divider
  static const Color lightTextPrimary = Color(0xFF1E293B); // Dark blue-gray
  static const Color lightTextSecondary = Color(0xFF64748B); // Medium blue-gray
  static const Color lightTextHint = Color(0xFF94A3B8); // Light blue-gray

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F172A); // Deep blue-gray
  static const Color darkSurface = Color(0xFF1E293B); // Lighter blue-gray
  static const Color darkBorder = Color(0xFF334155); // Medium blue-gray
  static const Color darkDivider = Color(0xFF1E293B); // Dark divider
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Almost white
  static const Color darkTextSecondary = Color(0xFFCBD5E1); // Light gray
  static const Color darkTextHint = Color(0xFF64748B); // Medium gray

  // Brand Colors - Same for both themes
  static const Color primary = Color(0xFF3B82F6); // Bright blue
  static const Color secondary = Color(0xFF6366F1); // Indigo
  static const Color accent = Color(0xFF3B82F6); // Bright blue

  // Status Colors - Vibrant for both themes
  static const Color success = Color(0xFF22C55E); // Green
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF3B82F6); // Blue

  // Priority Colors
  static const Color priorityHigh = Color(0xFFEF4444); // Red
  static const Color priorityMedium = Color(0xFFF59E0B); // Amber
  static const Color priorityLow = Color(0xFF22C55E); // Green

  // Status Colors
  static const Color statusNotStarted = Color(0xFF64748B); // Gray
  static const Color statusInProgress = Color(0xFF3B82F6); // Blue
  static const Color statusOnHold = Color(0xFFF59E0B); // Amber
  static const Color statusCompleted = Color(0xFF22C55E); // Green

  // Interactive States
  static const Color hoverLight = Color(0xFFF1F5F9); // Very light blue
  static const Color hoverDark = Color(0xFF334155); // Dark blue-gray
  static const Color pressedLight = Color(0xFFE2E8F0); // Light gray
  static const Color pressedDark = Color(0xFF475569); // Medium blue-gray

  // Overlay and Shadow Colors
  static final Color overlayLight = Colors.black.withOpacity(0.1);
  static final Color overlayDark = Colors.black.withOpacity(0.4);
  static final Color shadowLight = Colors.black.withOpacity(0.05);
  static final Color shadowDark = Colors.black.withOpacity(0.2);

  // Gradients
  static const List<Color> primaryGradient = [
    Color(0xFF3B82F6), // Start with primary
    Color(0xFF6366F1), // End with secondary
  ];

  static const List<Color> darkGradient = [
    Color(0xFF1E293B), // Dark surface
    Color(0xFF334155), // Slightly lighter
  ];

  // Helper method to get theme-aware colors
  static Color getThemeAwareColor(
    BuildContext context, {
    required Color lightThemeColor,
    required Color darkThemeColor,
  }) {
    return Theme.of(context).brightness == Brightness.light
        ? lightThemeColor
        : darkThemeColor;
  }
}
