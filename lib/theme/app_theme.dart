import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF7D23E0);
  static const Color bgColor = Colors.white;
  static const blackText = Colors.black;
  static const whiteText = Colors.white;
  static const greyText = Color(0xFF9C9C9C);
  static const errorColor = Color(0xFFE13B30);
  static const Color purple10 = Color.fromARGB(255, 238, 228, 250);
}

extension ThemeExtension on BuildContext {
  ThemeData get theme {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.bgColor,
      dividerColor: AppColors.greyText,
      indicatorColor: AppColors.errorColor,
      textTheme: TextTheme(
        titleLarge: GoogleFonts.caveat(
          fontSize: 44,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.whiteText,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.blackText,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.blackText,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.blackText,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.blackText,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.blackText,
        ),
      ),
    );
  }

  Color get primaryColor => theme.primaryColor;
  Color get backgroundColor => theme.scaffoldBackgroundColor;
}
