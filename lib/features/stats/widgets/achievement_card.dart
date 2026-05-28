import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/app_theme.dart';

class AchievementCard extends StatelessWidget {
  final int bestStreak;
  final double accuracy;

  const AchievementCard({
    super.key,
    required this.bestStreak,
    required this.accuracy,
  });

  String get _title {
    if (bestStreak >= 10) return 'Quantum Master';
    if (bestStreak >= 7) return 'Boson Hunter';
    if (accuracy >= 0.9) return 'Sharp Mind';
    if (accuracy >= 0.7) return 'Field Explorer';
    return 'Curious Learner';
  }

  String get _subtitle {
    if (bestStreak >= 10) return 'Reached 10-streak perfection.';
    if (bestStreak >= 7) return 'Identified $bestStreak in a row.';
    if (accuracy >= 0.9) return '90%+ accuracy maintained.';
    if (accuracy >= 0.7) return 'Solid understanding of the field.';
    return 'Every question brings you closer.';
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star_rounded,
                  color: AppTheme.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _title,
                    style: GoogleFonts.inter(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _subtitle,
                    style: GoogleFonts.inter(
                      color: AppTheme.primary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
