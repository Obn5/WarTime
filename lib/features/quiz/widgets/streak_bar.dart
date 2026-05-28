import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/app_theme.dart';
import '../../../app/constants.dart';
import '../../../models/topic.dart';
import 'tag_chip.dart';

class StreakBar extends StatelessWidget {
  final int streak;
  final Topic? topic;

  const StreakBar({super.key, required this.streak, this.topic});

  Color _difficultyColor(String d) {
    switch (d.toLowerCase()) {
      case 'easy':
        return const Color(0xFF4CAF50);
      case 'hard':
        return const Color(0xFFEF5350);
      default:
        return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: AppTheme.primary, size: 15),
              const SizedBox(width: 4),
              Text(
                'STREAK: $streak/${AppConstants.streakGoal}',
                style: GoogleFonts.inter(
                  color: AppTheme.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              if (topic != null) ...[
                TagChip(topic!.name),
                const SizedBox(width: 6),
                TagChip(
                  topic!.difficulty,
                  color: _difficultyColor(topic!.difficulty),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: streak / AppConstants.streakGoal,
              backgroundColor: AppTheme.cardDark,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppTheme.green),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }
}
