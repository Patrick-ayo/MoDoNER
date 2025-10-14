import 'package:flutter/material.dart';

class AppThemes {
  static const Color primaryLight = Color(0xFF1E40AF);
  static const Color primaryDark = Color(0xFF3B82F6);
  
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: MaterialColor(0xFF1E40AF, {
      50: Color(0xFFEFF6FF),
      100: Color(0xFFDBEAFE),
      200: Color(0xFFBFDBFE),
      300: Color(0xFF93C5FD),
      400: Color(0xFF60A5FA),
      500: Color(0xFF3B82F6),
      600: Color(0xFF2563EB),
      700: Color(0xFF1D4ED8),
      800: Color(0xFF1E40AF),
      900: Color(0xFF1E3A8A),
    }),
    colorScheme: const ColorScheme.light(
      primary: primaryLight,
      secondary: Color(0xFF059669),
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF111827),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryLight,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primarySwatch: MaterialColor(0xFF3B82F6, {
      50: Color(0xFF1E3A8A),
      100: Color(0xFF1E40AF),
      200: Color(0xFF1D4ED8),
      300: Color(0xFF2563EB),
      400: Color(0xFF3B82F6),
      500: Color(0xFF60A5FA),
      600: Color(0xFF93C5FD),
      700: Color(0xFFBFDBFE),
      800: Color(0xFFDBEAFE),
      900: Color(0xFFEFF6FF),
    }),
    colorScheme: const ColorScheme.dark(
      primary: primaryDark,
      secondary: Color(0xFF10B981),
      surface: Color(0xFF374151),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFFF9FAFB),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF374151),
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF374151),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
