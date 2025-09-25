import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primaryPurple = Color(0xFF5A4C8E);
  static const Color primaryPurpleLight = Color(0xFF7A6CAE);
  static const Color primaryPurpleDark = Color(0xFF3A2C6E);
  static const Color primaryPurpleLighter = Color(0xFFE8D7F1); // Light purple used for borders
  
  // Background colors
  static const Color background = Colors.white;
  static const Color cardBackground = Color(0xFFF5F5F5);
  static const Color recordButtonBackground = Color(0xFFF8F5F1); // Off-white for record button
  static const Color avatarBackground = Color(0xFFFFF8E7); // Light yellow for avatar backgrounds
  
  // Text colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);
  static const Color pressAndHoldColor = Color(0xFF6A5B99); // Purple for press and hold text
  
  // Button colors
  static const Color buttonEnabled = primaryPurple;
  static const Color buttonDisabled = Color(0xFFCCCCCC);
  static const Color recordButtonDot = Color(0xFFFF6266); // Red dot for record button
  
  // Other UI colors
  static const Color divider = Color(0xFFEEEEEE);
  static const Color border = Color(0xFFE0E0E0);
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF4CAF50);
  static const Color childProfileBorder = Color(0xFF8FD3A5); // Green border for child profiles
  static const Color parentProfileBorder = Color(0xFF4CAF50); // Green border for parent profile
}