import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static final TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(
      color: AppColors.textLight,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.poppins(
      color: AppColors.textLight,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: GoogleFonts.inter(
      color: AppColors.textLight,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.inter(
      color: AppColors.textLight,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
  );

  static final TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(
      color: AppColors.textDark,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.poppins(
      color: AppColors.textDark,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: GoogleFonts.inter(
      color: AppColors.textDark,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.inter(
      color: AppColors.textDark,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
  );
}
