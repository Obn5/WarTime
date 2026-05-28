import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/constants.dart';
import '../../../data/models/topic.dart';
import '../../../state/quiz_provider.dart';
import 'tag_chip.dart';

class StreakBar extends StatelessWidget {
  final int streak;
  final Topic? topic;

  const StreakBar({super.key, required this.streak, this.topic});

  Color _difficultyColor(String d, AppColors c) {
    switch (d.toLowerCase()) {
      case 'easy':
        return const Color(0xFF4CAF50);
      case 'hard':
        return const Color(0xFFEF5350);
      default:
        return c.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final provider = context.watch<QuizProvider>();
    final isLeveled = provider.isLeveledTopic;
    final levelIndex = provider.currentLevelIndex;
    final totalLevels = provider.totalLevels;
    final seen = provider.levelQuestionsSeen;
    final total = provider.levelQuestionsTotal;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.bolt_rounded, color: c.primary, size: 15),
              const SizedBox(width: 4),
              Text(
                'STREAK: $streak/${AppConstants.streakGoal}',
                style: GoogleFonts.inter(
                  color: c.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              // Level badge (only for leveled topics)
              if (isLeveled) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: c.teal.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: c.tealLight.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.layers_rounded,
                          color: c.tealLight, size: 10),
                      const SizedBox(width: 4),
                      Text(
                        'LVL ${levelIndex + 1}/$totalLevels',
                        style: GoogleFonts.inter(
                          color: c.tealLight,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
              ],
              if (topic != null) ...[
                TagChip(topic!.name),
                const SizedBox(width: 6),
                TagChip(
                  topic!.difficulty,
                  color: _difficultyColor(topic!.difficulty, c),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          // Streak progress
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              tween: Tween(
                  begin: 0, end: streak / AppConstants.streakGoal),
              builder: (_, v, __) => LinearProgressIndicator(
                value: v,
                backgroundColor: c.cardDark,
                valueColor: AlwaysStoppedAnimation<Color>(c.green),
                minHeight: 5,
              ),
            ),
          ),
          // Level question progress (only for leveled topics)
          if (isLeveled && total > 0) ...[
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                tween: Tween(begin: 0, end: seen / total),
                builder: (_, v, __) => LinearProgressIndicator(
                  value: v,
                  backgroundColor: c.cardDark,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(c.tealLight),
                  minHeight: 3,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '$seen / $total questions seen',
                style: GoogleFonts.inter(
                    color: c.textMuted, fontSize: 9),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
