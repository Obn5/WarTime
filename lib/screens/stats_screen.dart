import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';

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

  String _achievement(int bestStreak, double accuracy) {
    if (bestStreak >= 10) return 'Quantum Master';
    if (bestStreak >= 7) return 'Boson Hunter';
    if (accuracy >= 0.9) return 'Sharp Mind';
    if (accuracy >= 0.7) return 'Field Explorer';
    return 'Curious Learner';
  }

  String _achievementSub(int bestStreak, double accuracy) {
    if (bestStreak >= 10) return 'Reached 10-streak perfection.';
    if (bestStreak >= 7) return 'Identified $bestStreak in a row.';
    if (accuracy >= 0.9) return '90%+ accuracy maintained.';
    if (accuracy >= 0.7) return 'Solid understanding of the field.';
    return 'Every question brings you closer.';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final accuracy = provider.accuracy;
    final pct = (accuracy * 100).round();
    final avgMs = provider.avgTimeMs;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Column(
        children: [
          // ── Top nav ──────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  if (isStandalone)
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppTheme.cardDark,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: const Icon(Icons.arrow_back_rounded,
                            color: AppTheme.textSecondary, size: 16),
                      ),
                    )
                  else
                    const SizedBox(width: 32),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      const Icon(Icons.grid_view_rounded,
                          color: AppTheme.primary, size: 15),
                      const SizedBox(width: 6),
                      Text(
                        'Fields & Quarks',
                        style: GoogleFonts.inter(
                          color: AppTheme.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: const Icon(Icons.person_outline_rounded,
                        color: AppTheme.textSecondary, size: 16),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Column(
                children: [
                  // ── Mission Complete badge ──────────────
                  if (isComplete) ...[
                    const SizedBox(height: 20),
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: AppTheme.green.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppTheme.green.withValues(alpha: 0.4),
                            width: 2),
                      ),
                      child: const Icon(Icons.verified_rounded,
                          color: AppTheme.green, size: 34),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Mission Complete',
                      style: GoogleFonts.inter(
                        color: AppTheme.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Quantum state stabilized. Synchronization optimal.',
                      style: GoogleFonts.inter(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                  ] else ...[
                    const SizedBox(height: 20),
                    Text(
                      'ANALYTICS',
                      style: GoogleFonts.inter(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ── Accuracy card ────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'ACCURACY RATE',
                              style: AppTheme.labelSmall,
                            ),
                            const Spacer(),
                            const Icon(Icons.track_changes_rounded,
                                color: AppTheme.primary, size: 16),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$pct%',
                              style: GoogleFonts.inter(
                                color: AppTheme.textPrimary,
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
                                      ? AppTheme.green
                                      : AppTheme.textSecondary,
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
                          child: LinearProgressIndicator(
                            value: accuracy,
                            backgroundColor: AppTheme.cardDark,
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(
                                    AppTheme.green),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Speed + Tries row ────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'Avg Speed',
                          icon: Icons.timer_outlined,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _fmtTime(avgMs),
                                style: GoogleFonts.inter(
                                  color: AppTheme.textPrimary,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _speedLabel(avgMs),
                                  style: GoogleFonts.inter(
                                    color: AppTheme.primary,
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
                        child: _StatCard(
                          label: 'Total Tries',
                          icon: Icons.repeat_rounded,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${provider.totalAttempts}',
                                style: GoogleFonts.inter(
                                  color: AppTheme.textPrimary,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                provider.totalAttempts - provider.totalCorrect > 0
                                    ? '${provider.totalAttempts - provider.totalCorrect} Critical Errors'
                                    : 'No errors!',
                                style: GoogleFonts.inter(
                                  color: AppTheme.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Best streak ──────────────────────────
                  _StatCard(
                    label: 'Best Streak',
                    icon: Icons.local_fire_department_rounded,
                    fullWidth: true,
                    child: Row(
                      children: [
                        Text(
                          '${provider.bestStreak}',
                          style: GoogleFonts.inter(
                            color: AppTheme.primary,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          ' / 10',
                          style: GoogleFonts.inter(
                            color: AppTheme.textSecondary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: SizedBox(
                            width: 80,
                            child: LinearProgressIndicator(
                              value: provider.bestStreak / 10.0,
                              backgroundColor: AppTheme.cardDark,
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                      AppTheme.primary),
                              minHeight: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Achievement ──────────────────────────
                  Container(
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
                                _achievement(
                                    provider.bestStreak, accuracy),
                                style: GoogleFonts.inter(
                                  color: AppTheme.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _achievementSub(
                                    provider.bestStreak, accuracy),
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
                  ),
                  const SizedBox(height: 28),

                  // ── Action buttons ───────────────────────
                  if (!isStandalone)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              provider.reset();
                              Navigator.popUntil(
                                  context, (r) => r.isFirst);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.textPrimary,
                              side: const BorderSide(
                                  color: AppTheme.border),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14)),
                            ),
                            child: Text('Home',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: provider.startQuiz,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14)),
                              elevation: 0,
                            ),
                            child: Text('Retry',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700)),
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

class _StatCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget child;
  final bool fullWidth;

  const _StatCard({
    required this.label,
    required this.icon,
    required this.child,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.textSecondary, size: 14),
                const SizedBox(width: 6),
                Text(label, style: AppTheme.labelSmall),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      );
}
