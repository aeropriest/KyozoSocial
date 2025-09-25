import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App theme configuration for MeetMaxi
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Primary colors
  static const Color primaryColor = Color(0xFF2196F3); // Blue
  static const Color primaryLightColor = Color(0xFF64B5F6); // Light Blue
  static const Color primaryDarkColor = Color(0xFF1976D2); // Dark Blue

  // Background colors
  static const Color backgroundColor = Colors.white;
  static const Color surfaceColor = Colors.white;

  // Text colors
  static const Color textPrimaryColor = Color(0xFF212121); // Dark Grey
  static const Color textSecondaryColor = Color(0xFF757575); // Medium Grey
  static const Color textLightColor = Color(0xFFBDBDBD); // Light Grey
  static const Color textDarkGreyColor = Color(0xFF333333); // Darker Grey for answers

  // Accent colors
  static const Color accentColor = Color(0xFF03A9F4); // Light Blue
  static const Color errorColor = Color(0xFFE53935); // Red

  // Create the theme data
  static ThemeData get lightTheme {
    // Get the base Poppins text theme
    final TextTheme poppinsTextTheme = GoogleFonts.poppinsTextTheme();
    final String? poppinsFont = GoogleFonts.poppins().fontFamily;
    
    return ThemeData(
      fontFamily: poppinsFont,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: accentColor,
        error: errorColor,
        background: backgroundColor,
        surface: surfaceColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: primaryColor,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
        ),
      ),
      // Apply Poppins font to the entire text theme
      textTheme: poppinsTextTheme.copyWith(
        displayLarge: poppinsTextTheme.displayLarge?.copyWith(
          color: textPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: poppinsTextTheme.displayMedium?.copyWith(
          color: textPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: poppinsTextTheme.displaySmall?.copyWith(
          color: textPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: poppinsTextTheme.headlineMedium?.copyWith(
          color: textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: poppinsTextTheme.headlineSmall?.copyWith(
          color: textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: poppinsTextTheme.titleLarge?.copyWith(
          color: textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: poppinsTextTheme.bodyLarge?.copyWith(
          color: textPrimaryColor,
        ),
        bodyMedium: poppinsTextTheme.bodyMedium?.copyWith(
          color: textPrimaryColor,
        ),
        bodySmall: poppinsTextTheme.bodySmall?.copyWith(
          color: textSecondaryColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor),
        ),
      ),
    );
  }
}
