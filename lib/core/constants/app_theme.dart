import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 161, 166, 170),
    cardColor: const Color.fromARGB(255, 177, 171, 171),
    dividerColor: const Color.fromARGB(255, 220, 220, 221),
    hoverColor: const Color.fromARGB(255, 177, 179, 180).withOpacity(0.7),

    // Text themes
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: Color(0xFF1E293B),
      ),
      titleLarge: TextStyle(
        color: Color(0xFF1E293B),
      ),
      titleMedium: TextStyle(
        color: Color(0xFF334155),
      ),
      titleSmall: TextStyle(
        color: Color(0xFF475569),
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF334155),
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF475569),
      ),
      bodySmall: TextStyle(
        color: Color(0xFF64748B),
      ),
    ).apply(
      bodyColor: const Color(0xFF334155),
      displayColor: const Color(0xFF1E293B),
    ),

    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color.fromARGB(255, 194, 197, 195),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color.fromARGB(255, 82, 2, 119)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color.fromARGB(255, 177, 138, 11)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accent),
      ),
      labelStyle: const TextStyle(color: Color(0xFF64748B)),
      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.accent;
        }
        return const Color.fromARGB(255, 236, 235, 235);
      }),
      side: const BorderSide(color: Color(0xFFCBD5E1)),
    ),

    // Icon theme
    iconTheme: const IconThemeData(
      color: Color(0xFF64748B),
    ),

    // Card theme
    cardTheme: CardTheme(
      color: const Color.fromARGB(255, 161, 151, 151),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
    ),

    // Button themes
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.accent),
        foregroundColor: WidgetStateProperty.all(Colors.white),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(const Color(0xFF64748B)),
        overlayColor:
            WidgetStateProperty.all(AppColors.accent.withOpacity(0.1)),
      ),
    ),

    // Popup menu theme
    popupMenuTheme: PopupMenuThemeData(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Additional properties
    colorScheme: ColorScheme.light(
      primary: AppColors.accent,
      secondary: const Color(0xFF64748B),
      surface: Colors.white,
      error: Colors.red.shade400,
    ),

    // Material theme
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

    // Visual Density
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkSurface,
    dividerColor: Colors.white.withOpacity(0.1),
    hoverColor: AppColors.hoverDark,

    // Text themes
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
      ),
      titleSmall: TextStyle(
        color: Colors.white70,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        color: Colors.white70,
      ),
      bodySmall: TextStyle(
        color: Colors.white70,
      ),
    ).apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),

    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.darkSurface,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accent),
      ),
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white54),
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.accent;
        }
        return AppColors.darkSurface;
      }),
      side: BorderSide(color: Colors.white.withOpacity(0.1)),
    ),

    // Icon theme
    iconTheme: const IconThemeData(
      color: Colors.white70,
    ),

    // Card theme
    cardTheme: CardTheme(
      color: AppColors.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
    ),

    // Button themes
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.accent),
        foregroundColor: WidgetStateProperty.all(Colors.white),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.white70),
        overlayColor:
            WidgetStateProperty.all(AppColors.accent.withOpacity(0.1)),
      ),
    ),

    // Popup menu theme
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.darkSurface,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Additional properties
    colorScheme: ColorScheme.dark(
      primary: AppColors.accent,
      secondary: AppColors.secondary,
      surface: AppColors.darkSurface,
      error: Colors.red.shade400,
    ),

    // Material theme
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

    // Visual Density
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
