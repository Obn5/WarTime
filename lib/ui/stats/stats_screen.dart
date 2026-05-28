import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../state/quiz_provider.dart';
import '../shared/pressable.dart';
import '../shared/theme_dropdown.dart';
import 'widgets/achievement_card.dart';
import 'widgets/stat_card.dart';

class StatsScreen extends StatelessWidget {
  final bool isComplete;
  final bool isStandalone;

  const StatsScreen({
    super.key,
    required this.isComplete,
    this.isStandalone = false,
  });

  String _fmtTime(int ms) {
    if (ms == 0) return '—';
    if (ms < 1000) return '${ms}ms';
    return '${(ms / 1000).toStringAsFixed(1)}s';
  }

  String _speedLabel(int ms) {
    if (ms == 0) return '—';
    if (ms < 3000) return 'Superluminal';
    if (ms < 7000) return 'Fast';
    if (ms < 15000) return 'Steady';
    return 'Methodical';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final c = Theme.of(context).extension<AppColors>()!;
    final accuracy = provider.accuracy;
    final pct = (accuracy * 100).round();
    final avgMs = provider.avgTimeMs;

    return Scaffold(
      backgroundColor: c.bg,
      body: Column(
        children: [
          // ── Top nav ──────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  if (isStandalone)
                    Pressable(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: c.cardDark,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: c.border),
                        ),
                        child: Icon(Icons.arrow_back_rounded,
                            color: c.textSecondary, size: 16),
                      ),
                    )
                  else
                    const SizedBox(width: 32),
                  const SizedBox(width: 12),
                  Icon(Icons.grid_view_rounded, color: c.primary, size: 15),
                  const SizedBox(width: 6),
                  Text(
                    AppConstants.appName,
                    style: GoogleFonts.inter(
                      color: c.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  const ThemeDropdown(),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
              child: Column(
                children: [
                  // Mission Complete badge
                  if (isComplete) ...[
                    const SizedBox(height: 20),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.elasticOut,
                      tween: Tween(begin: 0.6, end: 1.0),
                      builder: (_, v, child) =>
                          Transform.scale(scale: v, child: child),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: c.green.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: c.green.withValues(alpha: 0.4),
                            width: 2,
                          ),
                        ),
                        child: Icon(Icons.verified_rounded,
                            color: c.green, size: 34),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Mission Complete',
                      style: GoogleFonts.inter(
                        color: c.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Quantum state stabilized. Synchronization optimal.',
                      style: GoogleFonts.inter(
                          color: c.textSecondary, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                  ] else ...[
                    const SizedBox(height: 20),
                    Text(
                      'ANALYTICS',
                      style: AppTheme.labelSmall(c.textSecondary).copyWith(
                        letterSpacing: 3,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Accuracy card
                  StatCard(
                    label: 'Accuracy Rate',
                    icon: Icons.track_changes_rounded,
                    fullWidth: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$pct%',
                              style: GoogleFonts.inter(
                                color: c.textPrimary,
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                height: 1,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                pct >= 80 ? '+strong result' : 'keep going',
                                style: GoogleFonts.inter(
                                  color: pct >= 80
                                      ? c.green
                                      : c.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOut,
                            tween: Tween(begin: 0, end: accuracy),
                            builder: (_, v, __) => LinearProgressIndicator(
                              value: v,
                              backgroundColor: c.cardDark,
                              valueColor: AlwaysStoppedAnimation<Color>(c.green),
                              minHeight: 6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Speed + Tries
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: 'Avg Speed',
                          icon: Icons.timer_outlined,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _fmtTime(avgMs),
                                style: GoogleFonts.inter(
                                  color: c.textPrimary,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: c.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _speedLabel(avgMs),
                                  style: GoogleFonts.inter(
                                    color: c.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          label: 'Total Tries',
                          icon: Icons.repeat_rounded,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${provider.totalAttempts}',
                                style: GoogleFonts.inter(
                                  color: c.textPrimary,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                provider.totalAttempts -
                                            provider.totalCorrect >
                                        0
                                    ? '${provider.totalAttempts - provider.totalCorrect} Critical Errors'
                                    : 'No errors!',
                                style: GoogleFonts.inter(
                                    color: c.textSecondary, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Best streak
                  StatCard(
                    label: 'Best Streak',
                    icon: Icons.local_fire_department_rounded,
                    fullWidth: true,
                    child: Row(
                      children: [
                        Text(
                          '${provider.bestStreak}',
                          style: GoogleFonts.inter(
                            color: c.primary,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          ' / ${AppConstants.streakGoal}',
                          style: GoogleFonts.inter(
                            color: c.textSecondary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: SizedBox(
                            width: 80,
                            child: TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOut,
                              tween: Tween(
                                begin: 0,
                                end: provider.bestStreak /
                                    AppConstants.streakGoal,
                              ),
                              builder: (_, v, __) => LinearProgressIndicator(
                                value: v,
                                backgroundColor: c.cardDark,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(c.primary),
                                minHeight: 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  AchievementCard(
                    bestStreak: provider.bestStreak,
                    accuracy: accuracy,
                  ),
                  const SizedBox(height: 28),

                  if (!isStandalone)
                    Row(
                      children: [
                        Expanded(
                          child: Pressable(
                            onTap: () {
                              provider.reset();
                              Navigator.popUntil(
                                  context, (r) => r.isFirst);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: c.border),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Home',
                                style: GoogleFonts.inter(
                                  color: c.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Pressable(
                            onTap: provider.startQuiz,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: c.green,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Retry',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
