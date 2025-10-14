import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Color(0xFF1E40AF);
  static const primaryLight = Color(0xFF3B82F6);
  static const accentCyan = Color(0xFF06B6D4);
  static const secondary = Color(0xFF059669);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const background = Color(0xFFF8F9FA);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);

  static final light = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: surface,
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: secondary,
      // note: avoid using background (deprecated) - prefer surface for scaffolds
      surface: surface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    // Use the modern TextTheme names (display/ headline/ body) to be compatible with latest SDKs.
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: textPrimary),
      displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: textPrimary),
      bodyLarge: TextStyle(fontSize: 16, color: textPrimary),
      bodyMedium: TextStyle(fontSize: 14, color: textSecondary),
      headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary),
      headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textPrimary),
      bodySmall: TextStyle(fontSize: 12, color: textSecondary),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
      titleMedium: TextStyle(fontSize: 14, color: textSecondary),
    ),
    // cardTheme removed for compatibility with this SDK's ThemeData signature.
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      buttonColor: primary,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: const Color(0xFF0F1724),
    colorScheme: ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: const Color(0xFF111827),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white60),
      headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
      titleMedium: TextStyle(fontSize: 14, color: Colors.white70),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      buttonColor: primary,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
