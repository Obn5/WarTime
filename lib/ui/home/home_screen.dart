import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/constants.dart';
import '../../state/quiz_provider.dart';
import '../../data/services/json_service.dart';
import '../quiz/quiz_screen.dart';
import '../shared/pressable.dart';
import '../shared/theme_dropdown.dart';
import '../stats/stats_screen.dart';
import 'topics_screen.dart';
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
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => const QuizScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 280),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final c = Theme.of(context).extension<AppColors>()!;
    final quizSet = provider.quizSet;

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
                  Icon(Icons.grid_view_rounded, color: c.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    quizSet?.name ?? AppConstants.appName,
                    style: GoogleFonts.inter(
                      color: c.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  if (provider.totalAttempts > 0) ...[
                    Pressable(
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
                          color: c.cardDark,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: c.border),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.bar_chart_rounded,
                                color: c.primary, size: 15),
                            const SizedBox(width: 5),
                            Text(
                              '${(provider.accuracy * 100).round()}%',
                              style: GoogleFonts.inter(
                                color: c.primary,
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
                  const ThemeDropdown(),
                ],
              ),
            ),
          ),

          // ── Body ─────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Welcome, Explorer',
                    style: GoogleFonts.inter(
                      color: c.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppConstants.appTagline,
                    style: GoogleFonts.inter(
                        color: c.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 28),

                  ImportCard(
                    onBrowse: () => _importJson(context),
                    onSample: () => _loadSample(context),
                    hasQuiz: quizSet != null,
                    quizName: quizSet?.name,
                  ),

                  if (quizSet != null) ...[
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Text(
                          'Select Topic',
                          style: GoogleFonts.inter(
                            color: c.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Pressable(
                          onTap: () => Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, anim, __) =>
                                  const TopicsScreen(),
                              transitionsBuilder: (_, anim, __, child) =>
                                  FadeTransition(
                                opacity: CurvedAnimation(
                                    parent: anim, curve: Curves.easeOut),
                                child: child,
                              ),
                              transitionDuration:
                                  const Duration(milliseconds: 250),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 2),
                            child: Row(
                              children: [
                                Text(
                                  'View All',
                                  style: GoogleFonts.inter(
                                    color: c.primary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Icon(Icons.arrow_forward_ios_rounded,
                                    color: c.primary, size: 11),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      height: 230,
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

                    if (provider.selectedTopic != null)
                      Pressable(
                        onTap: () => _startQuiz(context),
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: c.green,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Start Learning',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded,
                                  color: Colors.white, size: 18),
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
                            color: c.textMuted.withValues(alpha: 0.35),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Import a JSON file to begin',
                            style: GoogleFonts.inter(
                                color: c.textSecondary, fontSize: 14),
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
