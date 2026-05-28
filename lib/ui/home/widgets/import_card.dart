import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';

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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasQuiz
              ? AppTheme.green.withValues(alpha: 0.4)
              : AppTheme.border,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasQuiz
                    ? AppTheme.green.withValues(alpha: 0.3)
                    : AppTheme.border,
              ),
            ),
            child: Icon(
              hasQuiz
                  ? Icons.check_circle_outline_rounded
                  : Icons.upload_file_rounded,
              color: hasQuiz ? AppTheme.green : AppTheme.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            hasQuiz ? quizName ?? 'Lesson Loaded' : 'Import Lesson',
            style: GoogleFonts.inter(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hasQuiz
                ? 'Select a topic below to start'
                : 'Select a JSON file to load your quiz modules',
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _Btn(
                  label: 'Browse Files',
                  icon: Icons.folder_open_rounded,
                  onTap: onBrowse,
                  primary: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Btn(
                  label: 'Sample Quiz',
                  icon: Icons.science_rounded,
                  onTap: onSample,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool primary;

  const _Btn({
    required this.label,
    required this.icon,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: primary ? AppTheme.green : AppTheme.cardDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: primary ? AppTheme.green : AppTheme.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: primary ? Colors.white : AppTheme.textSecondary,
                size: 15,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: primary ? Colors.white : AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
}
