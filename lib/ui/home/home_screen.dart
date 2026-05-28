import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../state/quiz_provider.dart';
import '../../data/services/json_service.dart';
import '../quiz/quiz_screen.dart';
import '../stats/stats_screen.dart';
import 'widgets/import_card.dart';
import 'widgets/topic_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _importJson(BuildContext context) async {
    final quizSet = await JsonService.pickFile();
    if (quizSet != null && context.mounted) {
      context.read<QuizProvider>().loadQuizSet(quizSet);
    }
  }

  Future<void> _loadSample(BuildContext context) async {
    final quizSet = await JsonService.loadSample();
    if (quizSet != null && context.mounted) {
      context.read<QuizProvider>().loadQuizSet(quizSet);
    }
  }

  void _startQuiz(BuildContext context) {
    context.read<QuizProvider>().startQuiz();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QuizScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final quizSet = provider.quizSet;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Column(
        children: [
          // ── Top nav ───────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.grid_view_rounded,
                      color: AppTheme.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    quizSet?.name ?? AppConstants.appName,
                    style: GoogleFonts.inter(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  if (provider.totalAttempts > 0) ...[
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StatsScreen(
                            isComplete: false,
                            isStandalone: true,
                          ),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.cardDark,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.bar_chart_rounded,
                                color: AppTheme.primary, size: 15),
                            const SizedBox(width: 5),
                            Text(
                              '${(provider.accuracy * 100).round()}%',
                              style: GoogleFonts.inter(
                                color: AppTheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: const Icon(Icons.person_outline_rounded,
                        color: AppTheme.textSecondary, size: 18),
                  ),
                ],
              ),
            ),
          ),

          // ── Scrollable body ────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Welcome header
                  Text(
                    'Welcome, Explorer',
                    style: GoogleFonts.inter(
                      color: AppTheme.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppConstants.appTagline,
                    style: GoogleFonts.inter(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Import card
                  ImportCard(
                    onBrowse: () => _importJson(context),
                    onSample: () => _loadSample(context),
                    hasQuiz: quizSet != null,
                    quizName: quizSet?.name,
                  ),

                  if (quizSet != null) ...[
                    const SizedBox(height: 32),

                    // Topic header
                    Row(
                      children: [
                        Text(
                          'Select Topic',
                          style: GoogleFonts.inter(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'View All',
                          style: GoogleFonts.inter(
                            color: AppTheme.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Horizontal topic cards
                    SizedBox(
                      height: 210,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: quizSet.topics.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                        itemBuilder: (ctx, i) {
                          final topic = quizSet.topics[i];
                          return TopicCard(
                            topic: topic,
                            index: i,
                            isSelected:
                                provider.selectedTopic?.id == topic.id,
                            onTap: () => provider.selectTopic(topic),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Start button
                    if (provider.selectedTopic != null)
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => _startQuiz(context),
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
                                'Start Learning',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded,
                                  size: 18),
                            ],
                          ),
                        ),
                      ),
                  ] else ...[
                    const SizedBox(height: 48),
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.explore_outlined,
                            size: 64,
                            color: AppTheme.textMuted.withValues(alpha: 0.35),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Import a JSON file to begin',
                            style: GoogleFonts.inter(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
