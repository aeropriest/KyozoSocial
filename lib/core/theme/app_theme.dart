import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App theme configuration for KyozoSocial
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Kyozo brand colors (matching Next.js design)
  static const Color accentPink = Color(0xFFE94E8A); // #e94e8a
  static const Color accentPurple = Color(0xFF8A4EE9); // #8a4ee9
  static const Color accentBlue = Color(0xFF4E8AE9); // #4e8ae9

  // Background colors (light theme)
  static const Color backgroundColor = Color(0xFFFFFFFF); // White
  static const Color cardBackgroundColor = Color(0xFFEEEEEE); // Light gray cards
  static const Color surfaceColor = Colors.white;

  // Text colors (light theme)
  static const Color textPrimaryColor = Color(0xFF333333); // #333
  static const Color textSecondaryColor = Color(0xFF666666); // #666
  static const Color headingColor = Color(0xFF222222); // #222

  // UI colors
  static const Color borderColor = Color(0xFFE0E0E0); // #e0e0e0
  static const Color inputBackgroundColor = Color(0xFFF9F9F9); // #f9f9f9
  static const Color errorColor = Color(0xFFE94E4E); // #e94e4e

  // Gradient colors for text
  static const List<Color> gradientColors = [
    Color(0xFF8B5CF6), // Purple
    Color(0xFF06B6D4), // Cyan
  ];

  // Create the theme data
  static ThemeData get lightTheme {
    // Use Poppins font (keeping existing font for now, can switch to Geist later)
    final TextTheme poppinsTextTheme = GoogleFonts.poppinsTextTheme();
    final String? poppinsFont = GoogleFonts.poppins().fontFamily;
    
    return ThemeData(
      fontFamily: poppinsFont,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentPink,
        brightness: Brightness.light,
        primary: accentPink,
        secondary: accentPurple,
        tertiary: accentBlue,
        error: errorColor,
        surface: surfaceColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: headingColor,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentPink,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentPink,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // Fully rounded like Next.js
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentPink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimaryColor,
          side: const BorderSide(color: accentPink, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      // Apply Poppins font with Kyozo styling
      textTheme: poppinsTextTheme.copyWith(
        displayLarge: poppinsTextTheme.displayLarge?.copyWith(
          color: headingColor,
          fontWeight: FontWeight.w300, // Thinner weight like Next.js
        ),
        displayMedium: poppinsTextTheme.displayMedium?.copyWith(
          color: headingColor,
          fontWeight: FontWeight.w300,
        ),
        displaySmall: poppinsTextTheme.displaySmall?.copyWith(
          color: headingColor,
          fontWeight: FontWeight.w300,
        ),
        headlineLarge: poppinsTextTheme.headlineLarge?.copyWith(
          color: headingColor,
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: poppinsTextTheme.headlineMedium?.copyWith(
          color: headingColor,
          fontWeight: FontWeight.w400,
        ),
        headlineSmall: poppinsTextTheme.headlineSmall?.copyWith(
          color: headingColor,
          fontWeight: FontWeight.w400,
        ),
        titleLarge: poppinsTextTheme.titleLarge?.copyWith(
          color: headingColor,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: poppinsTextTheme.titleMedium?.copyWith(
          color: textPrimaryColor,
          fontWeight: FontWeight.w400,
        ),
        bodyLarge: poppinsTextTheme.bodyLarge?.copyWith(
          color: textPrimaryColor,
          fontWeight: FontWeight.w300,
        ),
        bodyMedium: poppinsTextTheme.bodyMedium?.copyWith(
          color: textPrimaryColor,
          fontWeight: FontWeight.w300,
        ),
        bodySmall: poppinsTextTheme.bodySmall?.copyWith(
          color: textSecondaryColor,
          fontWeight: FontWeight.w300,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // More rounded
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentPink, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      cardTheme: CardThemeData(
        color: cardBackgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
