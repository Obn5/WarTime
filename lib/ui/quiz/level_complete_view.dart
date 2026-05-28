import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../shared/pressable.dart';

class LevelCompleteView extends StatelessWidget {
  final int levelIndex;       // 0-based
  final int totalLevels;
  final int correct;
  final int total;
  final double accuracy;
  final int xpEarned;
  final VoidCallback onNext;

  const LevelCompleteView({
    super.key,
    required this.levelIndex,
    required this.totalLevels,
    required this.correct,
    required this.total,
    required this.accuracy,
    required this.xpEarned,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final pct = (accuracy * 100).round();

    final Color rankColor;
    final String rankLabel;
    final IconData rankIcon;
    if (pct == 100) {
      rankColor = c.primary;
      rankLabel = 'PERFECT';
      rankIcon = Icons.auto_awesome_rounded;
    } else if (pct >= 80) {
      rankColor = c.greenMid;
      rankLabel = 'GREAT';
      rankIcon = Icons.verified_rounded;
    } else if (pct >= 60) {
      rankColor = c.primary;
      rankLabel = 'GOOD';
      rankIcon = Icons.thumb_up_rounded;
    } else {
      rankColor = c.tealLight;
      rankLabel = 'KEEP GOING';
      rankIcon = Icons.trending_up_rounded;
    }

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              // Level progress indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(totalLevels, (i) {
                  final done = i <= levelIndex;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 200 + i * 40),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: done ? 24 : 8,
                    height: 4,
                    decoration: BoxDecoration(
                      color: done
                          ? c.primary
                          : c.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),

              const Spacer(),

              // Badge
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                tween: Tween(begin: 0.5, end: 1.0),
                builder: (_, v, child) =>
                    Transform.scale(scale: v, child: child),
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        rankColor.withValues(alpha: 0.25),
                        rankColor.withValues(alpha: 0.08),
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: rankColor.withValues(alpha: 0.45), width: 2),
                  ),
                  child: Icon(rankIcon, color: rankColor, size: 40),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'LEVEL ${levelIndex + 1} COMPLETE',
                style: GoogleFonts.inter(
                  color: c.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                rankLabel,
                style: GoogleFonts.inter(
                  color: rankColor,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$correct / $total correct',
                style: GoogleFonts.inter(
                    color: c.textPrimary, fontSize: 16),
              ),

              const SizedBox(height: 40),

              // Stats row
              Row(
                children: [
                  _Stat(label: 'ACCURACY', value: '$pct%', color: rankColor, c: c),
                  _Divider(c: c),
                  _Stat(label: 'XP EARNED', value: '+$xpEarned', color: c.primary, c: c),
                  _Divider(c: c),
                  _Stat(
                    label: 'NEXT LEVEL',
                    value: '${levelIndex + 2} / $totalLevels',
                    color: c.tealLight,
                    c: c,
                  ),
                ],
              ),

              const Spacer(),

              // Next level button
              Pressable(
                onTap: onNext,
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [c.green, c.greenMid],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: c.green.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Level ${levelIndex + 2}',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded,
                          color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final AppColors c;
  const _Stat(
      {required this.label,
      required this.value,
      required this.color,
      required this.c});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Text(value,
                style: GoogleFonts.inter(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1)),
            const SizedBox(height: 4),
            Text(label,
                style: GoogleFonts.inter(
                    color: c.textSecondary,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2)),
          ],
        ),
      );
}

class _Divider extends StatelessWidget {
  final AppColors c;
  const _Divider({required this.c});

  @override
  Widget build(BuildContext context) => Container(
        width: 1, height: 40, color: c.border);
}
