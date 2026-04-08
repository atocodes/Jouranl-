import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class JournalAppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppLightColors.background,
    primaryTextTheme: GoogleFonts.dmSerifDisplayTextTheme(
      ThemeData.light().textTheme,
    ),
    colorScheme: const ColorScheme.light(
      primary: AppLightColors.primary,
      secondary: AppLightColors.secondary,
      surface: AppLightColors.surface,
      error: AppLightColors.error,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppLightColors.background,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppLightColors.primary),
      titleTextStyle: TextStyle(
        color: AppLightColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppLightColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    dividerColor: AppLightColors.divider,

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppLightColors.surface,
      hintStyle: const TextStyle(color: AppLightColors.textHint),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppLightColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),

    textTheme: GoogleFonts.dmSerifDisplayTextTheme(
      TextTheme(
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppLightColors.textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: AppLightColors.textPrimary),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppLightColors.textSecondary,
        ),
      ),
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppDarkColors.background,
    primaryTextTheme: GoogleFonts.dmSerifDisplayTextTheme(
      ThemeData.dark().textTheme,
    ),

    colorScheme: const ColorScheme.dark(
      primary: AppDarkColors.primary,
      secondary: AppDarkColors.secondary,
      surface: AppDarkColors.surface,
      error: AppDarkColors.error,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppDarkColors.background,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppDarkColors.primary),
      titleTextStyle: TextStyle(
        color: AppDarkColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppDarkColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    dividerColor: AppDarkColors.divider,

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppDarkColors.surface,
      hintStyle: const TextStyle(color: AppDarkColors.textHint),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppDarkColors.primary,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),

    textTheme: GoogleFonts.dmSerifDisplayTextTheme(
      TextTheme(
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppDarkColors.textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: AppDarkColors.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: AppDarkColors.textSecondary),
      ),
    ),
  );
}
