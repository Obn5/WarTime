import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/answer_option_tile.dart';
import 'stats_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();

    switch (provider.phase) {
      case QuizPhase.complete:
        return const StatsScreen(isComplete: true);
      case QuizPhase.quintetStats:
        return _QuintetView(
          history: provider.quintetHistory.last,
          streak: provider.correctStreak,
          totalCorrect: provider.totalCorrect,
          accuracy: provider.accuracy,
          onContinue: provider.continueAfterQuintet,
        );
      default:
        break;
    }

    final question = provider.currentQuestion;
    if (question == null) return const SizedBox();

    final selected = provider.selectedAnswer;
    final isRevealing = provider.phase == QuizPhase.revealing;
    final isCorrect = selected != null && selected == question.correctIndex;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Column(
        children: [
          // ── Top nav ────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      provider.reset();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: AppTheme.textSecondary, size: 16),
                    ),
                  ),
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
                  // LVL badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppTheme.primary.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      'LVL ${provider.level}',
                      style: GoogleFonts.inter(
                        color: AppTheme.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
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

          // ── Streak bar ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bolt_rounded,
                          color: AppTheme.primary, size: 15),
                      const SizedBox(width: 4),
                      Text(
                        'STREAK: ${provider.correctStreak}/10',
                        style: GoogleFonts.inter(
                          color: AppTheme.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                      const Spacer(),
                      // Topic + difficulty tags
                      if (provider.selectedTopic != null) ...[
                        _Tag(
                          provider.selectedTopic!.name,
                          AppTheme.teal,
                        ),
                        const SizedBox(width: 6),
                        _Tag(
                          provider.selectedTopic!.difficulty,
                          _difficultyColor(
                              provider.selectedTopic!.difficulty),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: provider.correctStreak / 10.0,
                      backgroundColor:
                          AppTheme.cardDark,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppTheme.green),
                      minHeight: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Question + options ─────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tags
                        if (question.tags.isNotEmpty) ...[
                          Wrap(
                            spacing: 6,
                            children: question.tags
                                .map((t) => _Tag(t, AppTheme.teal))
                                .toList(),
                          ),
                          const SizedBox(height: 12),
                        ],
                        Text(
                          question.question,
                          style: GoogleFonts.inter(
                            color: AppTheme.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        // Formula box
                        if (question.formula != null &&
                            question.formula!.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.cardDark,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: Text(
                              question.formula!,
                              style: GoogleFonts.sourceCodePro(
                                color: AppTheme.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Answer options
                  ...List.generate(question.options.length, (i) {
                    AnswerState state = AnswerState.idle;
                    if (isRevealing) {
                      if (i == question.correctIndex) {
                        state = AnswerState.correct;
                      } else if (i == selected) {
                        state = AnswerState.wrong;
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AnswerOptionTile(
                        text: question.options[i],
                        state: state,
                        onTap: isRevealing
                            ? null
                            : () => provider.submitAnswer(i),
                      ),
                    );
                  }),

                  // Explanation
                  if (isRevealing) ...[
                    const SizedBox(height: 4),
                    _ExplanationPanel(
                      isCorrect: isCorrect,
                      correctAnswer:
                          question.options[question.correctIndex],
                      explanation: question.explanation,
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: provider.nextQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              provider.correctStreak >= 10
                                  ? 'Mission Complete!'
                                  : 'Next Question',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward_rounded,
                                size: 16),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'answer  ·  flash  ·  explanation  ·  next card',
                      style: GoogleFonts.inter(
                        color: AppTheme.textMuted,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  const _Tag(this.text, this.color);

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(
          text.toUpperCase(),
          style: GoogleFonts.inter(
            color: color.withValues(alpha: 0.9),
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      );
}

class _ExplanationPanel extends StatelessWidget {
  final bool isCorrect;
  final String correctAnswer;
  final String explanation;

  const _ExplanationPanel({
    required this.isCorrect,
    required this.correctAnswer,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? AppTheme.correct : AppTheme.wrong;
    final bg = isCorrect ? AppTheme.correctBg : AppTheme.wrongBg;
    final border = isCorrect
        ? AppTheme.correct.withValues(alpha: 0.3)
        : AppTheme.wrong.withValues(alpha: 0.3);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                color: color,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isCorrect
                      ? 'Correct!'
                      : 'Wrong. Correct answer: $correctAnswer',
                  style: GoogleFonts.inter(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            explanation,
            style: GoogleFonts.inter(
              color: AppTheme.textDarkMid,
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quintet checkpoint view ──────────────────────────────────
class _QuintetView extends StatelessWidget {
  final Map<String, dynamic> history;
  final int streak;
  final int totalCorrect;
  final double accuracy;
  final VoidCallback onContinue;

  const _QuintetView({
    required this.history,
    required this.streak,
    required this.totalCorrect,
    required this.accuracy,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final correct = history['correct'] as int;
    final total = history['total'] as int;
    final pct = (correct / total * 100).round();

    final String label;
    final Color labelColor;
    if (pct == 100) {
      label = 'PERFECT';
      labelColor = AppTheme.primary;
    } else if (pct >= 80) {
      label = 'GREAT';
      labelColor = AppTheme.green;
    } else if (pct >= 60) {
      label = 'GOOD';
      labelColor = Colors.orange;
    } else {
      label = 'KEEP GOING';
      labelColor = AppTheme.wrong;
    }

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'QUINTET COMPLETE',
                style: GoogleFonts.inter(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: labelColor,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$correct / $total correct this round',
                style: GoogleFonts.inter(
                    color: AppTheme.textPrimary, fontSize: 16),
              ),
              const SizedBox(height: 40),
              _SRow(label: 'Round Accuracy', value: '$pct%'),
              Divider(
                  color: AppTheme.border, height: 28),
              _SRow(label: 'Current Streak', value: '$streak / 10'),
              _SRow(
                  label: 'Overall Accuracy',
                  value: '${(accuracy * 100).round()}%'),
              _SRow(label: 'Total Correct', value: '$totalCorrect'),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SRow extends StatelessWidget {
  final String label;
  final String value;
  const _SRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: GoogleFonts.inter(
                    color: AppTheme.textSecondary, fontSize: 14)),
            Text(value,
                style: GoogleFonts.inter(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      );
}
