import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';

class QuintetView extends StatelessWidget {
  final Map<String, dynamic> history;
  final int streak;
  final int totalCorrect;
  final double accuracy;
  final VoidCallback onContinue;

  const QuintetView({
    super.key,
    required this.history,
    required this.streak,
    required this.totalCorrect,
    required this.accuracy,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final correct = history['correct'] as int;
    final total = history['total'] as int;
    final pct = (correct / total * 100).round();

    final String label;
    final Color labelColor;
    if (pct == 100) {
      label = 'PERFECT';
      labelColor = c.primary;
    } else if (pct >= 80) {
      label = 'GREAT';
      labelColor = c.green;
    } else if (pct >= 60) {
      label = 'GOOD';
      labelColor = Colors.orange;
    } else {
      label = 'KEEP GOING';
      labelColor = c.wrong;
    }

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'QUINTET COMPLETE',
                style: GoogleFonts.inter(
                  color: c.textSecondary,
                  fontSize: 11,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: labelColor,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$correct / $total correct this round',
                style: GoogleFonts.inter(color: c.textPrimary, fontSize: 16),
              ),
              const SizedBox(height: 40),
              _Row('Round Accuracy', '$pct%', c),
              Divider(color: c.border, height: 28),
              _Row('Current Streak', '$streak / 10', c),
              _Row('Overall Accuracy', '${(accuracy * 100).round()}%', c),
              _Row('Total Correct', '$totalCorrect', c),
              const SizedBox(height: 48),
              _ContinueBtn(onTap: onContinue, c: c),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final AppColors c;
  const _Row(this.label, this.value, this.c);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: GoogleFonts.inter(color: c.textSecondary, fontSize: 14)),
            Text(value,
                style: GoogleFonts.inter(
                    color: c.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      );
}

class _ContinueBtn extends StatefulWidget {
  final VoidCallback onTap;
  final AppColors c;
  const _ContinueBtn({required this.onTap, required this.c});

  @override
  State<_ContinueBtn> createState() => _ContinueBtnState();
}

class _ContinueBtnState extends State<_ContinueBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 90),
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: widget.c.green,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            'Continue',
            style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15),
          ),
        ),
      ),
    );
  }
}
