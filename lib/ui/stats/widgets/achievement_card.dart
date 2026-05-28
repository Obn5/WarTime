import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_colors.dart';

class AchievementCard extends StatelessWidget {
  final int bestStreak;
  final double accuracy;

  const AchievementCard({
    super.key,
    required this.bestStreak,
    required this.accuracy,
  });

  _AchievementTier get _tier {
    if (bestStreak >= 10) return _AchievementTier.quantumMaster;
    if (bestStreak >= 7) return _AchievementTier.bosonHunter;
    if (accuracy >= 0.9) return _AchievementTier.sharpMind;
    if (accuracy >= 0.7) return _AchievementTier.fieldExplorer;
    return _AchievementTier.curiousLearner;
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final tier = _tier;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: tier.gradientColors(c),
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: tier.accentColor(c).withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: tier.accentColor(c).withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: tier.accentColor(c).withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                  color: tier.accentColor(c).withValues(alpha: 0.3)),
            ),
            child: Icon(tier.icon, color: tier.accentColor(c), size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      tier.title,
                      style: GoogleFonts.inter(
                        color: c.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: tier.accentColor(c).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: tier.accentColor(c).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        tier.badge,
                        style: GoogleFonts.inter(
                          color: tier.accentColor(c),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  tier.subtitle(bestStreak),
                  style: GoogleFonts.inter(
                    color: c.textSecondary,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _AchievementTier {
  quantumMaster,
  bosonHunter,
  sharpMind,
  fieldExplorer,
  curiousLearner,
}

extension _TierProps on _AchievementTier {
  String get title {
    switch (this) {
      case _AchievementTier.quantumMaster:
        return 'Quantum Master';
      case _AchievementTier.bosonHunter:
        return 'Boson Hunter';
      case _AchievementTier.sharpMind:
        return 'Sharp Mind';
      case _AchievementTier.fieldExplorer:
        return 'Field Explorer';
      case _AchievementTier.curiousLearner:
        return 'Curious Learner';
    }
  }

  String get badge {
    switch (this) {
      case _AchievementTier.quantumMaster:
        return 'ELITE';
      case _AchievementTier.bosonHunter:
        return 'ADVANCED';
      case _AchievementTier.sharpMind:
        return 'PROFICIENT';
      case _AchievementTier.fieldExplorer:
        return 'EXPLORER';
      case _AchievementTier.curiousLearner:
        return 'BEGINNER';
    }
  }

  String subtitle(int streak) {
    switch (this) {
      case _AchievementTier.quantumMaster:
        return 'Reached 10-streak perfection. Maximum resonance.';
      case _AchievementTier.bosonHunter:
        return 'Identified $streak particles in a row. Impressive!';
      case _AchievementTier.sharpMind:
        return '90%+ accuracy maintained. Exceptional precision.';
      case _AchievementTier.fieldExplorer:
        return 'Solid grasp of the field. Keep pushing.';
      case _AchievementTier.curiousLearner:
        return 'Every question brings you closer to mastery.';
    }
  }

  IconData get icon {
    switch (this) {
      case _AchievementTier.quantumMaster:
        return Icons.auto_awesome_rounded;
      case _AchievementTier.bosonHunter:
        return Icons.bolt_rounded;
      case _AchievementTier.sharpMind:
        return Icons.psychology_rounded;
      case _AchievementTier.fieldExplorer:
        return Icons.explore_rounded;
      case _AchievementTier.curiousLearner:
        return Icons.school_rounded;
    }
  }

  Color accentColor(AppColors c) {
    switch (this) {
      case _AchievementTier.quantumMaster:
        return c.primary;
      case _AchievementTier.bosonHunter:
        return c.tealLight;
      case _AchievementTier.sharpMind:
        return c.greenMid;
      case _AchievementTier.fieldExplorer:
        return c.primary;
      case _AchievementTier.curiousLearner:
        return c.textSecondary;
    }
  }

  List<Color> gradientColors(AppColors c) {
    final accent = accentColor(c);
    return [
      accent.withValues(alpha: 0.1),
      c.surface,
      c.cardDark,
    ];
  }
}
