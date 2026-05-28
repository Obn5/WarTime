import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/topic_card.dart';
import 'quiz_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _importJson(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      final json = utf8.decode(result.files.single.bytes!);
      if (context.mounted) context.read<QuizProvider>().loadFromJson(json);
    }
  }

  Future<void> _loadSample(BuildContext context) async {
    final json = await rootBundle.loadString('assets/sample_quiz.json');
    if (context.mounted) context.read<QuizProvider>().loadFromJson(json);
  }

  void _startQuiz(BuildContext context) {
    context.read<QuizProvider>().startQuiz();
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const QuizScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final quizSet = provider.quizSet;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Column(
        children: [
          // ── Dark top nav bar ──────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.grid_view_rounded,
                          color: AppTheme.primary, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        quizSet?.name ?? 'Fields & Quarks',
                        style: GoogleFonts.inter(
                          color: AppTheme.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (provider.totalAttempts > 0)
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const StatsScreen(
                                isComplete: false,
                                isStandalone: true)),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.cardDark,
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: AppTheme.border),
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

          // ── Scrollable content ────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
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
                    'Dive into the fundamental layers of the universe.',
                    style: GoogleFonts.inter(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Import card ───────────────────────────
                  _ImportCard(
                    onImport: () => _importJson(context),
                    onSample: () => _loadSample(context),
                    hasQuiz: quizSet != null,
                    quizName: quizSet?.name,
                  ),
                  const SizedBox(height: 32),

                  if (quizSet != null) ...[
                    // ── Select Topic ──────────────────────
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

                    // Horizontal scroll of topic cards
                    SizedBox(
                      height: 210,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: quizSet.topics.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                        itemBuilder: (ctx, i) {
                          final topic = quizSet.topics[i];
                          return GestureDetector(
                            onTap: () {
                              provider.selectTopic(topic);
                            },
                            child: Stack(
                              children: [
                                TopicCard(
                                    topic: topic,
                                    index: i,
                                    onTap: () =>
                                        provider.selectTopic(topic)),
                                if (provider.selectedTopic?.id ==
                                    topic.id)
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppTheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                          Icons.check_rounded,
                                          color: AppTheme.bg,
                                          size: 12),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Start button ──────────────────────
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
                                borderRadius:
                                    BorderRadius.circular(14)),
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
                  ] else
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Column(
                          children: [
                            Icon(Icons.explore_outlined,
                                size: 64,
                                color: AppTheme.textMuted
                                    .withValues(alpha: 0.4)),
                            const SizedBox(height: 12),
                            Text(
                              'Import a JSON file to begin',
                              style: GoogleFonts.inter(
                                  color: AppTheme.textSecondary,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
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

class _ImportCard extends StatelessWidget {
  final VoidCallback onImport;
  final VoidCallback onSample;
  final bool hasQuiz;
  final String? quizName;

  const _ImportCard({
    required this.onImport,
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
          color: hasQuiz ? AppTheme.green.withValues(alpha: 0.4) : AppTheme.border,
          width: 1.5,
          // dashed via a custom painter would need more work;
          // using solid + subtle color for simplicity
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
                style: BorderStyle.solid,
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
                : 'Select a JSON file to load custom scientific modules',
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
                child: _SmallBtn(
                  label: 'Browse Files',
                  icon: Icons.folder_open_rounded,
                  onTap: onImport,
                  primary: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SmallBtn(
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

class _SmallBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool primary;

  const _SmallBtn({
    required this.label,
    required this.icon,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: primary ? AppTheme.green : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: primary
                  ? AppTheme.green
                  : AppTheme.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: primary
                    ? Colors.white
                    : AppTheme.textSecondary,
                size: 15),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                color:
                    primary ? Colors.white : AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
