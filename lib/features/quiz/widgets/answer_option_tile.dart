import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/app_theme.dart';

enum AnswerState { idle, correct, wrong }

class AnswerOptionTile extends StatelessWidget {
  final String text;
  final AnswerState state;
  final VoidCallback? onTap;

  const AnswerOptionTile({
    super.key,
    required this.text,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color borderColor;
    final Color textColor;
    final Widget radio;

    switch (state) {
      case AnswerState.correct:
        bg = AppTheme.correctBg;
        borderColor = AppTheme.correct;
        textColor = AppTheme.correct;
        radio = _FilledCircle(
          color: AppTheme.correct,
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 13),
        );
      case AnswerState.wrong:
        bg = AppTheme.wrongBg;
        borderColor = AppTheme.wrong;
        textColor = AppTheme.wrong;
        radio = _FilledCircle(
          color: AppTheme.wrong,
          child: const Icon(Icons.close_rounded, color: Colors.white, size: 13),
        );
      case AnswerState.idle:
        bg = AppTheme.cardLight;
        borderColor = AppTheme.borderLight;
        textColor = AppTheme.textDark;
        radio = Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.textDarkMuted.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
        );
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.inter(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: state != AnswerState.idle
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 12),
            radio,
          ],
        ),
      ),
    );
  }
}

class _FilledCircle extends StatelessWidget {
  final Color color;
  final Widget child;
  const _FilledCircle({required this.color, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Center(child: child),
      );
}
