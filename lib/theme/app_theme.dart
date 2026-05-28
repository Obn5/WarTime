import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Backgrounds ──────────────────────────────────────────
  static const Color bg = Color(0xFF140C07);
  static const Color surface = Color(0xFF1E1208);
  static const Color cardDark = Color(0xFF2A1810);

  // ── Light card surface (answer options, import box) ───────
  static const Color cardLight = Color(0xFFF0E8D5);
  static const Color cardWhite = Color(0xFFFAF6EE);

  // ── Brand ─────────────────────────────────────────────────
  static const Color primary = Color(0xFFE4C693);   // warm gold
  static const Color green = Color(0xFF3A6B4A);     // forest green CTA
  static const Color greenMid = Color(0xFF4E8A62);
  static const Color teal = Color(0xFF213D50);      // tertiary teal
  static const Color tealLight = Color(0xFF4A7E9A);

  // ── States ────────────────────────────────────────────────
  static const Color correct = Color(0xFF3A6B4A);
  static const Color correctBg = Color(0xFFD6EAD9);
  static const Color wrong = Color(0xFF8B2D2D);
  static const Color wrongBg = Color(0xFFEDD4D4);

  // ── Text on dark backgrounds ──────────────────────────────
  static const Color textPrimary = Color(0xFFF2E8D5);
  static const Color textSecondary = Color(0xFF8A6D55);
  static const Color textMuted = Color(0xFF5A4030);

  // ── Text on light (cream) backgrounds ────────────────────
  static const Color textDark = Color(0xFF1C0E07);
  static const Color textDarkMid = Color(0xFF5A3C28);
  static const Color textDarkMuted = Color(0xFF8A6D55);

  // ── Borders ───────────────────────────────────────────────
  static const Color border = Color(0xFF3D2510);
  static const Color borderLight = Color(0xFFD4C4A0);

  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: const ColorScheme.dark(
          primary: primary,
          surface: surface,
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ),
        useMaterial3: true,
      );

  // ── Shared text styles ────────────────────────────────────
  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
        color: textSecondary,
      );

  static TextStyle get tagStyle => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      );

  // ── Topic gradient palettes ───────────────────────────────
  static const List<List<Color>> topicGradients = [
    [Color(0xFF0D2137), Color(0xFF1A4A6B), Color(0xFF0A3020)],
    [Color(0xFF1C0A2A), Color(0xFF3D1060), Color(0xFF1A0A0A)],
    [Color(0xFF1A2A0A), Color(0xFF3D5A1A), Color(0xFF0A1A1A)],
    [Color(0xFF2A1A0A), Color(0xFF5A3010), Color(0xFF1A0A0A)],
    [Color(0xFF0A1A2A), Color(0xFF1A3A5A), Color(0xFF0A0A2A)],
    [Color(0xFF1A0A1A), Color(0xFF4A1A3A), Color(0xFF0A0A1A)],
  ];

  static List<Color> gradientFor(int index) =>
      topicGradients[index % topicGradients.length];
}
