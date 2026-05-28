import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/app_theme.dart';

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
    final correct = history['correct'] as int;
    final total = history['total'] as int;
    final pct = (correct / total * 100).round();

    final String label;
    final Color labelColor;
    if (pct == 100) {
      label = 'PERFECT';
      labelColor = AppTheme.primary;
    } else if (pct >= 80) {
      label = 'GREAT';
      labelColor = AppTheme.green;
    } else if (pct >= 60) {
      label = 'GOOD';
      labelColor = Colors.orange;
    } else {
      label = 'KEEP GOING';
      labelColor = AppTheme.wrong;
    }

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'QUINTET COMPLETE',
                style: GoogleFonts.inter(
                  color: AppTheme.textSecondary,
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
                style: GoogleFonts.inter(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              _StatRow(label: 'Round Accuracy', value: '$pct%'),
              Divider(color: AppTheme.border, height: 28),
              _StatRow(label: 'Current Streak', value: '$streak / 10'),
              _StatRow(
                label: 'Overall Accuracy',
                value: '${(accuracy * 100).round()}%',
              ),
              _StatRow(label: 'Total Correct', value: '$totalCorrect'),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: GoogleFonts.inter(
                    color: AppTheme.textSecondary, fontSize: 14)),
            Text(value,
                style: GoogleFonts.inter(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      );
}
