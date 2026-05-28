import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color bg;
  final Color surface;
  final Color cardDark;
  final Color cardLight;
  final Color cardWhite;
  final Color primary;
  final Color green;
  final Color greenMid;
  final Color teal;
  final Color tealLight;
  final Color correct;
  final Color correctBg;
  final Color wrong;
  final Color wrongBg;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textDark;
  final Color textDarkMid;
  final Color textDarkMuted;
  final Color border;
  final Color borderLight;
  final bool isLight;
  final List<List<Color>> topicGradients;

  const AppColors({
    required this.bg,
    required this.surface,
    required this.cardDark,
    required this.cardLight,
    required this.cardWhite,
    required this.primary,
    required this.green,
    required this.greenMid,
    required this.teal,
    required this.tealLight,
    required this.correct,
    required this.correctBg,
    required this.wrong,
    required this.wrongBg,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textDark,
    required this.textDarkMid,
    required this.textDarkMuted,
    required this.border,
    required this.borderLight,
    this.isLight = false,
    this.topicGradients = _slateGradients,
  });

  List<Color> gradientFor(int index) =>
      topicGradients[index % topicGradients.length];

  // ── Terra (light green / earth) ───────────────────────────
  static const terra = AppColors(
    bg: Color(0xFFEFF1EB),
    surface: Color(0xFFFFFFFF),
    cardDark: Color(0xFFE4EAD8),
    cardLight: Color(0xFFFFFFFF),
    cardWhite: Color(0xFFFAFCF8),
    primary: Color(0xFF4A7C59),
    green: Color(0xFF4A7C59),
    greenMid: Color(0xFF5E9870),
    teal: Color(0xFF3D6B4A),
    tealLight: Color(0xFF7AB893),
    correct: Color(0xFF4A7C59),
    correctBg: Color(0xFFD4EAD8),
    wrong: Color(0xFFC0392B),
    wrongBg: Color(0xFFFDEAEA),
    textPrimary: Color(0xFF1C2B1E),
    textSecondary: Color(0xFF6B6358),
    textMuted: Color(0xFFADADA5),
    textDark: Color(0xFF1C2B1E),
    textDarkMid: Color(0xFF4A4040),
    textDarkMuted: Color(0xFF6B6358),
    border: Color(0xFFCED4C8),
    borderLight: Color(0xFFE4EAD8),
    isLight: true,
    topicGradients: _terraGradients,
  );

  // ── Slate & Ember (dark) ──────────────────────────────────
  static const slateEmber = AppColors(
    bg: Color(0xFF16181F),
    surface: Color(0xFF1E2029),
    cardDark: Color(0xFF252836),
    cardLight: Color(0xFFF0E8D5),
    cardWhite: Color(0xFFFAF6EE),
    primary: Color(0xFFC4A66A),
    green: Color(0xFF4A7C59),
    greenMid: Color(0xFF5E9870),
    teal: Color(0xFF3D5070),
    tealLight: Color(0xFF677796),
    correct: Color(0xFF4A7C59),
    correctBg: Color(0xFFD4EAD8),
    wrong: Color(0xFFC0392B),
    wrongBg: Color(0xFFFDEAEA),
    textPrimary: Color(0xFFE8EAF0),
    textSecondary: Color(0xFF717784),
    textMuted: Color(0xFF404454),
    textDark: Color(0xFF1C1E2A),
    textDarkMid: Color(0xFF3A3C4A),
    textDarkMuted: Color(0xFF717784),
    border: Color(0xFF2E3040),
    borderLight: Color(0xFFD4C4A0),
    isLight: false,
    topicGradients: _slateGradients,
  );

  static const List<List<Color>> _terraGradients = [
    [Color(0xFF1A3A2A), Color(0xFF2D6B4A), Color(0xFF0A2A1A)],
    [Color(0xFF2A3A1A), Color(0xFF4A6B2A), Color(0xFF1A2A0A)],
    [Color(0xFF1A2A3A), Color(0xFF2A4A6B), Color(0xFF0A1A2A)],
    [Color(0xFF3A2A1A), Color(0xFF6B4A2A), Color(0xFF2A1A0A)],
    [Color(0xFF2A1A3A), Color(0xFF4A2A6B), Color(0xFF1A0A2A)],
    [Color(0xFF1A3A3A), Color(0xFF2A6B6B), Color(0xFF0A2A2A)],
  ];

  static const List<List<Color>> _slateGradients = [
    [Color(0xFF0D2137), Color(0xFF1A4A6B), Color(0xFF0A3020)],
    [Color(0xFF1C0A2A), Color(0xFF3D1060), Color(0xFF1A0A0A)],
    [Color(0xFF1A2A0A), Color(0xFF3D5A1A), Color(0xFF0A1A1A)],
    [Color(0xFF2A1A0A), Color(0xFF5A3010), Color(0xFF1A0A0A)],
    [Color(0xFF0A1A2A), Color(0xFF1A3A5A), Color(0xFF0A0A2A)],
    [Color(0xFF1A0A1A), Color(0xFF4A1A3A), Color(0xFF0A0A1A)],
  ];

  @override
  AppColors copyWith({
    Color? bg, Color? surface, Color? cardDark, Color? cardLight,
    Color? cardWhite, Color? primary, Color? green, Color? greenMid,
    Color? teal, Color? tealLight, Color? correct, Color? correctBg,
    Color? wrong, Color? wrongBg, Color? textPrimary, Color? textSecondary,
    Color? textMuted, Color? textDark, Color? textDarkMid,
    Color? textDarkMuted, Color? border, Color? borderLight,
    bool? isLight, List<List<Color>>? topicGradients,
  }) => AppColors(
    bg: bg ?? this.bg,
    surface: surface ?? this.surface,
    cardDark: cardDark ?? this.cardDark,
    cardLight: cardLight ?? this.cardLight,
    cardWhite: cardWhite ?? this.cardWhite,
    primary: primary ?? this.primary,
    green: green ?? this.green,
    greenMid: greenMid ?? this.greenMid,
    teal: teal ?? this.teal,
    tealLight: tealLight ?? this.tealLight,
    correct: correct ?? this.correct,
    correctBg: correctBg ?? this.correctBg,
    wrong: wrong ?? this.wrong,
    wrongBg: wrongBg ?? this.wrongBg,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    textMuted: textMuted ?? this.textMuted,
    textDark: textDark ?? this.textDark,
    textDarkMid: textDarkMid ?? this.textDarkMid,
    textDarkMuted: textDarkMuted ?? this.textDarkMuted,
    border: border ?? this.border,
    borderLight: borderLight ?? this.borderLight,
    isLight: isLight ?? this.isLight,
    topicGradients: topicGradients ?? this.topicGradients,
  );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      bg: l(bg, other.bg),
      surface: l(surface, other.surface),
      cardDark: l(cardDark, other.cardDark),
      cardLight: l(cardLight, other.cardLight),
      cardWhite: l(cardWhite, other.cardWhite),
      primary: l(primary, other.primary),
      green: l(green, other.green),
      greenMid: l(greenMid, other.greenMid),
      teal: l(teal, other.teal),
      tealLight: l(tealLight, other.tealLight),
      correct: l(correct, other.correct),
      correctBg: l(correctBg, other.correctBg),
      wrong: l(wrong, other.wrong),
      wrongBg: l(wrongBg, other.wrongBg),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      textMuted: l(textMuted, other.textMuted),
      textDark: l(textDark, other.textDark),
      textDarkMid: l(textDarkMid, other.textDarkMid),
      textDarkMuted: l(textDarkMuted, other.textDarkMuted),
      border: l(border, other.border),
      borderLight: l(borderLight, other.borderLight),
      isLight: t < 0.5 ? isLight : other.isLight,
      topicGradients: t < 0.5 ? topicGradients : other.topicGradients,
    );
  }
}
