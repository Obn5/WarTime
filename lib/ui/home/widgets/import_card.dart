import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_colors.dart';
import '../../shared/pressable.dart';

class ImportCard extends StatelessWidget {
  final VoidCallback onBrowse;
  final VoidCallback onSample;
  final bool hasQuiz;
  final String? quizName;

  const ImportCard({
    super.key,
    required this.onBrowse,
    required this.onSample,
    required this.hasQuiz,
    this.quizName,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: hasQuiz
              ? [c.green.withValues(alpha: 0.15), c.surface, c.cardDark]
              : [c.surface, c.cardDark, c.surface],
        ),
        border: Border.all(
          color: hasQuiz ? c.green.withValues(alpha: 0.5) : c.border,
          width: hasQuiz ? 1.5 : 1.0,
        ),
        boxShadow: hasQuiz
            ? [BoxShadow(color: c.green.withValues(alpha: 0.14), blurRadius: 24, offset: const Offset(0, 8))]
            : [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 14, offset: const Offset(0, 5))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Top gloss shine
            Positioned(
              top: 0, left: 0, right: 0, height: 70,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white.withValues(alpha: 0.05), Colors.transparent],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  // Icon badge
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: hasQuiz
                            ? [c.green.withValues(alpha: 0.22), c.green.withValues(alpha: 0.08)]
                            : [c.primary.withValues(alpha: 0.15), c.primary.withValues(alpha: 0.05)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: hasQuiz ? c.green.withValues(alpha: 0.35) : c.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Icon(
                      hasQuiz ? Icons.check_circle_outline_rounded : Icons.upload_file_rounded,
                      color: hasQuiz ? c.greenMid : c.primary,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    hasQuiz ? quizName ?? 'Lesson Loaded' : 'Import Lesson',
                    style: GoogleFonts.inter(color: c.textPrimary, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    hasQuiz
                        ? 'Select a topic below to start'
                        : 'Load a JSON file to unlock your quiz topics',
                    style: GoogleFonts.inter(color: c.textSecondary, fontSize: 12.5, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 1,
                    color: c.border.withValues(alpha: 0.6),
                    margin: const EdgeInsets.only(bottom: 18),
                  ),
                  Row(
                    children: [
                      Expanded(child: _Btn(label: 'Browse Files', icon: Icons.folder_open_rounded, onTap: onBrowse, primary: true, c: c)),
                      const SizedBox(width: 10),
                      Expanded(child: _Btn(label: 'Sample Quiz', icon: Icons.science_rounded, onTap: onSample, c: c)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool primary;
  final AppColors c;

  const _Btn({required this.label, required this.icon, required this.onTap, required this.c, this.primary = false});

  @override
  Widget build(BuildContext context) => Pressable(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          decoration: BoxDecoration(
            gradient: primary
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [c.green, c.greenMid],
                  )
                : null,
            color: primary ? null : c.cardDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primary ? c.green.withValues(alpha: 0.6) : c.border),
            boxShadow: primary
                ? [BoxShadow(color: c.green.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 3))]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: primary ? Colors.white : c.textSecondary, size: 15),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: primary ? Colors.white : c.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
}
