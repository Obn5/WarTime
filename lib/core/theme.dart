import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import '../state/theme_provider.dart';

class AppTheme {
  static ThemeData build(ColorMode mode) {
    final c = mode == ColorMode.terra ? AppColors.terra : AppColors.slateEmber;
    final base = c.isLight ? ThemeData.light() : ThemeData.dark();
    return ThemeData(
      brightness: c.isLight ? Brightness.light : Brightness.dark,
      scaffoldBackgroundColor: c.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: c.primary,
        brightness: c.isLight ? Brightness.light : Brightness.dark,
        primary: c.green,
        surface: c.surface,
        onPrimary: Colors.white,
        onSurface: c.textPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
      extensions: [c],
      useMaterial3: true,
    );
  }

  static TextStyle labelSmall(Color color) => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
        color: color,
      );
}
