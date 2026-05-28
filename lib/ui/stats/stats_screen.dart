import 'dart:math';
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
    final errors = provider.totalAttempts - provider.totalCorrect;
    final xpInLevel = provider.xp % AppConstants.xpPerLevel;
    final xpProgress = xpInLevel / AppConstants.xpPerLevel;

    return Scaffold(
      backgroundColor: c.bg,
      body: Column(
        children: [
          // ── Top nav ──────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                        fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  const ThemeDropdown(),
                ],
              ),
            ),
          ),

          // ── Scrollable content ───────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
              child: Column(
                children: [
                  // Mission Complete header
                  if (isComplete) ...[
                    const SizedBox(height: 16),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.elasticOut,
                      tween: Tween(begin: 0.6, end: 1.0),
                      builder: (_, v, child) =>
                          Transform.scale(scale: v, child: child),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              c.green.withValues(alpha: 0.2),
                              c.green.withValues(alpha: 0.06),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: c.green.withValues(alpha: 0.35)),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.verified_rounded,
                                color: c.green, size: 40),
                            const SizedBox(height: 8),
                            Text(
                              'Mission Complete',
                              style: GoogleFonts.inter(
                                color: c.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Quantum state stabilized.',
                              style: GoogleFonts.inter(
                                  color: c.textSecondary, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ] else ...[
                    const SizedBox(height: 8),
                    Text(
                      'ANALYTICS',
                      style: AppTheme.labelSmall(c.textSecondary)
                          .copyWith(letterSpacing: 3, fontSize: 11),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ── Accuracy gauge ───────────────────────────
                  _AccuracyGauge(accuracy: accuracy, pct: pct, c: c),
                  const SizedBox(height: 8),

                  if (provider.selectedTopic != null)
                    Text(
                      provider.selectedTopic!.name,
                      style: GoogleFonts.inter(
                          color: c.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  const SizedBox(height: 24),

                  // ── XP / Level card ──────────────────────────
                  _XpCard(
                    xp: provider.xp,
                    level: provider.level,
                    xpProgress: xpProgress,
                    xpInLevel: xpInLevel,
                    c: c,
                  ),
                  const SizedBox(height: 12),

                  // ── 2×2 stat mini-cards ──────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _MiniStat(
                          icon: Icons.timer_outlined,
                          label: 'Avg Speed',
                          value: _fmtTime(avgMs),
                          sub: _speedLabel(avgMs),
                          c: c,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _MiniStat(
                          icon: Icons.local_fire_department_rounded,
                          label: 'Best Streak',
                          value: '${provider.bestStreak}',
                          sub: '/ ${AppConstants.streakGoal} goal',
                          accent: c.primary,
                          c: c,
                          progress: provider.bestStreak /
                              AppConstants.streakGoal,
                          progressColor: c.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _MiniStat(
                          icon: Icons.repeat_rounded,
                          label: 'Total Tries',
                          value: '${provider.totalAttempts}',
                          sub: '${provider.totalCorrect} correct',
                          c: c,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _MiniStat(
                          icon: Icons.close_rounded,
                          label: 'Errors',
                          value: '$errors',
                          sub: errors == 0
                              ? 'Clean run!'
                              : 'mistakes made',
                          accent: errors == 0 ? c.green : c.wrong,
                          c: c,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ── Quintet history ──────────────────────────
                  if (provider.quintetHistory.isNotEmpty) ...[
                    _QuintetHistory(
                        history: provider.quintetHistory, c: c),
                    const SizedBox(height: 14),
                  ],

                  // ── Achievement card ─────────────────────────
                  AchievementCard(
                    bestStreak: provider.bestStreak,
                    accuracy: accuracy,
                  ),
                  const SizedBox(height: 28),

                  // ── Action buttons ───────────────────────────
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [c.green, c.greenMid],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: c.green.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Retry',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.replay_rounded,
                                      color: Colors.white, size: 15),
                                ],
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

// ── Circular accuracy gauge ────────────────────────────────────

class _AccuracyGauge extends StatelessWidget {
  final double accuracy;
  final int pct;
  final AppColors c;

  const _AccuracyGauge(
      {required this.accuracy, required this.pct, required this.c});

  Color get _color {
    if (pct >= 80) return c.green;
    if (pct >= 60) return c.primary;
    return c.wrong;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOut,
      tween: Tween(begin: 0, end: accuracy),
      builder: (_, value, __) => Column(
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: CustomPaint(
              painter: _GaugePainter(
                value: value,
                fillColor: _color,
                trackColor: c.cardDark,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(value * 100).round()}%',
                      style: GoogleFonts.inter(
                        color: c.textPrimary,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'accuracy',
                      style: GoogleFonts.inter(
                          color: c.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final Color fillColor;
  final Color trackColor;

  const _GaugePainter(
      {required this.value,
      required this.fillColor,
      required this.trackColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const strokeWidth = 10.0;
    const startAngle = pi * 0.75;
    const sweepAngle = pi * 1.5;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    if (value > 0) {
      final fillPaint = Paint()
        ..color = fillColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle * value.clamp(0.0, 1.0),
        false,
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.value != value || old.fillColor != fillColor;
}

// ── XP / Level card ────────────────────────────────────────────

class _XpCard extends StatelessWidget {
  final int xp;
  final int level;
  final double xpProgress;
  final int xpInLevel;
  final AppColors c;

  const _XpCard({
    required this.xp,
    required this.level,
    required this.xpProgress,
    required this.xpInLevel,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    final toNext = AppConstants.xpPerLevel - xpInLevel;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            c.primary.withValues(alpha: 0.12),
            c.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  c.primary.withValues(alpha: 0.25),
                  c.primary.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(color: c.primary.withValues(alpha: 0.3)),
            ),
            child: Center(
              child: Text(
                '$level',
                style: GoogleFonts.inter(
                  color: c.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Level $level',
                      style: GoogleFonts.inter(
                        color: c.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '$xp XP total',
                      style: GoogleFonts.inter(
                        color: c.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOut,
                    tween: Tween(begin: 0, end: xpProgress),
                    builder: (_, v, __) => LinearProgressIndicator(
                      value: v,
                      backgroundColor: c.cardDark,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(c.primary),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$toNext XP to Level ${level + 1}',
                  style: GoogleFonts.inter(
                      color: c.textSecondary, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mini stat card ─────────────────────────────────────────────

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String sub;
  final Color? accent;
  final double? progress;
  final Color? progressColor;
  final AppColors c;

  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
    required this.c,
    this.accent,
    this.progress,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final col = accent ?? c.textPrimary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: c.textSecondary, size: 13),
              const SizedBox(width: 5),
              Text(
                label.toUpperCase(),
                style: GoogleFonts.inter(
                  color: c.textSecondary,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.inter(
              color: col,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          if (progress != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                tween: Tween(begin: 0, end: progress!.clamp(0.0, 1.0)),
                builder: (_, v, __) => LinearProgressIndicator(
                  value: v,
                  backgroundColor: c.cardDark,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(progressColor ?? col),
                  minHeight: 4,
                ),
              ),
            ),
            const SizedBox(height: 5),
          ],
          Text(
            sub,
            style: GoogleFonts.inter(
              color: accent != null
                  ? col.withValues(alpha: 0.7)
                  : c.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quintet history bar chart ──────────────────────────────────

class _QuintetHistory extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  final AppColors c;

  const _QuintetHistory({required this.history, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart_rounded,
                  color: c.textSecondary, size: 13),
              const SizedBox(width: 5),
              Text(
                'ROUND HISTORY',
                style: GoogleFonts.inter(
                  color: c.textSecondary,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Text(
                '${history.length} rounds',
                style: GoogleFonts.inter(
                    color: c.textMuted, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: history.asMap().entries.map((entry) {
                final i = entry.key;
                final h = entry.value;
                final correct = h['correct'] as int;
                final total = h['total'] as int;
                final ratio = correct / total;
                final barColor = ratio >= 0.8
                    ? c.green
                    : ratio >= 0.5
                        ? c.primary
                        : c.wrong;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: i < history.length - 1 ? 6 : 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '$correct/$total',
                          style: GoogleFonts.inter(
                            color: barColor,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: ratio),
                          duration: Duration(
                              milliseconds: 400 + i * 80),
                          curve: Curves.easeOut,
                          builder: (_, v, __) => Container(
                            height: 56 * v + 4,
                            decoration: BoxDecoration(
                              color: barColor.withValues(alpha: 0.8),
                              borderRadius:
                                  BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'R${i + 1}',
                          style: GoogleFonts.inter(
                            color: c.textMuted,
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
