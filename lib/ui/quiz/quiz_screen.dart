import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/constants.dart';
import '../../state/quiz_provider.dart';
import '../shared/pressable.dart';
import '../shared/theme_dropdown.dart';
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
    final c = Theme.of(context).extension<AppColors>()!;

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
    final isCorrect = selected != null && selected == question.correctIndex;

    return Scaffold(
      backgroundColor: c.bg,
      body: Column(
        children: [
          // ── Top nav ─────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Pressable(
                    onTap: () {
                      provider.reset();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: c.cardDark,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: c.border),
                      ),
                      child: Icon(Icons.close_rounded,
                          color: c.textSecondary, size: 16),
                    ),
                  ),
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
                  // LVL badge
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: c.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: c.primary.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      'LVL ${provider.level}',
                      style: GoogleFonts.inter(
                        color: c.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const ThemeDropdown(),
                ],
              ),
            ),
          ),

          // ── Streak bar ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: StreakBar(
              streak: provider.correctStreak,
              topic: provider.selectedTopic,
            ),
          ),
          const SizedBox(height: 16),

          // ── Question + options ───────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Question card fades on new question
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: QuestionCard(
                      key: ValueKey(question.question),
                      question: question,
                      topicName: provider.selectedTopic?.name,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Answer options — staggered slide-in
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
                        key: ValueKey('${question.question}_$i'),
                        text: question.options[i],
                        state: state,
                        animIndex: i,
                        onTap: isRevealing ? null : () => provider.submitAnswer(i),
                      ),
                    );
                  }),

                  // Explanation + next
                  if (isRevealing) ...[
                    const SizedBox(height: 4),
                    ExplanationPanel(
                      isCorrect: isCorrect,
                      correctAnswer: question.options[question.correctIndex],
                      explanation: question.explanation,
                    ),
                    const SizedBox(height: 14),
                    Pressable(
                      onTap: provider.nextQuestion,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: c.green,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              provider.correctStreak >= AppConstants.streakGoal
                                  ? 'Mission Complete!'
                                  : 'Next Question',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward_rounded,
                                color: Colors.white, size: 16),
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
                          color: c.textMuted, fontSize: 10, letterSpacing: 0.5),
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
