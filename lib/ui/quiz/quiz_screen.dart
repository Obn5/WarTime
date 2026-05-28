import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../state/quiz_provider.dart';
import '../stats/stats_screen.dart';
import 'quintet_view.dart';
import 'widgets/answer_option_tile.dart';
import 'widgets/explanation_panel.dart';
import 'widgets/question_card.dart';
import 'widgets/streak_bar.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();

    switch (provider.phase) {
      case QuizPhase.complete:
        return const StatsScreen(isComplete: true);
      case QuizPhase.quintetStats:
        return QuintetView(
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
    if (question == null) return const SizedBox.shrink();

    final selected = provider.selectedAnswer;
    final isRevealing = provider.phase == QuizPhase.revealing;
    final isCorrect =
        selected != null && selected == question.correctIndex;

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
                  // Close
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

                  // App name
                  const Icon(Icons.grid_view_rounded,
                      color: AppTheme.primary, size: 15),
                  const SizedBox(width: 6),
                  Text(
                    AppConstants.appName,
                    style: GoogleFonts.inter(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
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

                  // Avatar
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
            child: StreakBar(
              streak: provider.correctStreak,
              topic: provider.selectedTopic,
            ),
          ),
          const SizedBox(height: 16),

          // ── Scrollable question + options ──────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Question card
                  QuestionCard(
                    question: question,
                    topicName: provider.selectedTopic?.name,
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

                  // Explanation + next button
                  if (isRevealing) ...[
                    const SizedBox(height: 4),
                    ExplanationPanel(
                      isCorrect: isCorrect,
                      correctAnswer:
                          question.options[question.correctIndex],
                      explanation: question.explanation,
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: provider.nextQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              provider.correctStreak >=
                                      AppConstants.streakGoal
                                  ? 'Mission Complete!'
                                  : 'Next Question',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
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
}
