import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_colors.dart';
import '../../shared/pressable.dart';

enum AnswerState { idle, correct, wrong }

class AnswerOptionTile extends StatelessWidget {
  final String text;
  final AnswerState state;
  final VoidCallback? onTap;
  final int animIndex;

  const AnswerOptionTile({
    super.key,
    required this.text,
    required this.state,
    this.onTap,
    this.animIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;

    final Color bg;
    final Color borderColor;
    final Color textColor;
    final Widget radio;

    switch (state) {
      case AnswerState.correct:
        bg = c.correctBg;
        borderColor = c.correct;
        textColor = c.correct;
        radio = _FilledCircle(
          color: c.correct,
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 13),
        );
      case AnswerState.wrong:
        bg = c.wrongBg;
        borderColor = c.wrong;
        textColor = c.wrong;
        radio = _FilledCircle(
          color: c.wrong,
          child: const Icon(Icons.close_rounded, color: Colors.white, size: 13),
        );
      case AnswerState.idle:
        bg = c.cardLight;
        borderColor = c.borderLight;
        textColor = c.textDark;
        radio = Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: c.textDarkMuted.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
        );
    }

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 260 + animIndex * 55),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset((1 - v) * 24, 0),
          child: child,
        ),
      ),
      child: Pressable(
        onTap: state == AnswerState.idle ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
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
