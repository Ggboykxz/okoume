import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Thème Material 3 d'Okoumé (clair + sombre), typographies Poppins / Roboto / Montserrat.
abstract final class AppTheme {
 static const poppins = 'Poppins';
 static const montserrat = 'Montserrat';
  static const inter = 'Inter';

 // --------------------------------------------------------------------- Clair
 static ColorScheme _lightScheme() => const ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFD8E9FF),
    onPrimaryContainer: Color(0xFF002F5C),
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFFFE1C7),
    onSecondaryContainer: Color(0xFF572300),
    tertiary: AppColors.success,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFC4F4D4),
    onTertiaryContainer: Color(0xFF00391C),
    error: AppColors.danger,
    onError: Colors.white,
    errorContainer: Color(0xFFFFDADF),
    onErrorContainer: Color(0xFF5C0018),
    surface: AppColors.surface,
    onSurface: AppColors.text,
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF7F9FC),
    surfaceContainer: Color(0xFFF1F4F9),
    surfaceContainerHigh: Color(0xFFEAEEF5),
    surfaceContainerHighest: Color(0xFFE3E8F0),
    onSurfaceVariant: AppColors.textSecondary,
    outline: Color(0xFFC3CBD8),
    outlineVariant: Color(0xFFE3E8EF),
    shadow: Color(0x1A1A1A2E),
    scrim: Color(0x99000000),
    inverseSurface: AppColors.text,
    onInverseSurface: Color(0xFFF5F7FA),
    inversePrimary: AppColors.primaryLight,
   );

 // ------------------------------------------------------------------ Sombre
 static ColorScheme _darkScheme() => const ColorScheme.dark(
    primary: Color(0xFF5BA8F5),
    onPrimary: Color(0xFF00325C),
    primaryContainer: Color(0xFF004684),
    onPrimaryContainer: Color(0xFFD8E9FF),
    secondary: Color(0xFFFF9A4D),
    onSecondary: Color(0xFF4A1E00),
    secondaryContainer: Color(0xFF6B2D00),
    onSecondaryContainer: Color(0xFFFFE1C7),
    tertiary: Color(0xFF57D98A),
    onTertiary: Color(0xFF00391C),
    tertiaryContainer: Color(0xFF00522A),
    onTertiaryContainer: Color(0xFFC4F4D4),
    error: Color(0xFFFF6B81),
    onError: Color(0xFF5C0018),
    errorContainer: Color(0xFF8C1130),
    onErrorContainer: Color(0xFFFFDADF),
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkText,
    surfaceContainerLowest: Color(0xFF0B0E13),
    surfaceContainerLow: AppColors.darkBackground,
    surfaceContainer: Color(0xFF20262F),
    surfaceContainerHigh: AppColors.darkSurfaceHigh,
    surfaceContainerHighest: Color(0xFF2C3442),
    onSurfaceVariant: AppColors.darkTextSecondary,
    outline: Color(0xFF3D4655),
    outlineVariant: Color(0xFF2A3140),
    shadow: Color(0x66000000),
    scrim: Color(0xBB000000),
    inverseSurface: AppColors.darkText,
    onInverseSurface: AppColors.text,
    inversePrimary: AppColors.primary,
   );

 // ---------------------------------------------------------------- Typographie
 // Tracking (letterSpacing) spécifique à la taille — Apple §15 :
 // négatif sur les grands titres, neutre en corps de texte.
 static TextTheme _textTheme() => const TextTheme(
    displaySmall: TextStyle(
      fontFamily: poppins, fontWeight: FontWeight.w700, fontSize: 34, height: 1.12, letterSpacing: -0.6),
    headlineMedium: TextStyle(
      fontFamily: poppins, fontWeight: FontWeight.w700, fontSize: 26, height: 1.15, letterSpacing: -0.5),
    headlineSmall: TextStyle(
      fontFamily: poppins, fontWeight: FontWeight.w700, fontSize: 22, height: 1.2, letterSpacing: -0.4),
    titleLarge: TextStyle(
      fontFamily: poppins, fontWeight: FontWeight.w700, fontSize: 18, height: 1.25, letterSpacing: -0.25),
    titleMedium: TextStyle(
      fontFamily: poppins, fontWeight: FontWeight.w600, fontSize: 16, height: 1.3, letterSpacing: -0.15),
    titleSmall: TextStyle(
      fontFamily: poppins, fontWeight: FontWeight.w600, fontSize: 14, height: 1.3, letterSpacing: -0.1),
    bodyLarge: TextStyle(fontFamily: AppTheme.inter, fontSize: 16, height: 1.45),
    bodyMedium: TextStyle(fontFamily: AppTheme.inter, fontSize: 14, height: 1.45),
    bodySmall: TextStyle(fontFamily: AppTheme.inter, fontSize: 12, height: 1.4),
    labelLarge: TextStyle(
      fontFamily: poppins, fontWeight: FontWeight.w600, fontSize: 14, height: 1.2, letterSpacing: 0.1),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.3, letterSpacing: 0.15),
    labelSmall: TextStyle(fontFamily: AppTheme.inter, fontSize: 11, fontWeight: FontWeight.w500, height: 1.3, letterSpacing: 0.2),
   );

 // --------------------------------------------------------------------- Base
 static ThemeData _base(ColorScheme cs, {required bool dark}) {
  return ThemeData(
   colorScheme: cs,
   scaffoldBackgroundColor:
     dark ? AppColors.darkBackground : AppColors.background,
   textTheme:
     _textTheme().apply(bodyColor: cs.onSurface, displayColor: cs.onSurface),
   // Transitions fluides type iOS (parallaxe horizontale + retour au bord).
   pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
     TargetPlatform.android: CupertinoPageTransitionsBuilder(),
     TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
     TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
    },
   ),
   appBarTheme: AppBarThemeData(
    backgroundColor: dark ? AppColors.darkBackground : cs.surface,
    foregroundColor: cs.onSurface,
    elevation: 0,
    scrolledUnderElevation: 2,
    surfaceTintColor: Colors.transparent,
    centerTitle: false,
    toolbarHeight: 64,
    titleSpacing: 16,
    titleTextStyle: TextStyle(
     fontFamily: poppins,
     fontWeight: FontWeight.w700,
     fontSize: 18,
     color: cs.onSurface,
    ),
   ),
   inputDecorationTheme: InputDecorationThemeData(
    filled: true,
    fillColor: dark ? AppColors.darkSurfaceHigh : const Color(0xFFF1F4F9),
    contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: TextStyle(
      color: cs.onSurfaceVariant, fontWeight: FontWeight.w500, fontSize: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: cs.primary, width: 1.4)),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: cs.error, width: 1.2)),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: cs.error, width: 1.4)),
   ),
   bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: cs.surface,
    modalBackgroundColor: cs.surface,
    surfaceTintColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
     borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
   ),
   snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: dark ? AppColors.darkSurfaceHigh : AppColors.text,
    contentTextStyle: TextStyle(
     fontSize: 13.5,
     fontWeight: FontWeight.w500,
     color: dark ? AppColors.darkText : Colors.white,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
   ),
   progressIndicatorTheme: ProgressIndicatorThemeData(color: cs.primary),
  );
 }

 static ThemeData light() => _base(_lightScheme(), dark: false);
 static ThemeData dark() => _base(_darkScheme(), dark: true);
}
