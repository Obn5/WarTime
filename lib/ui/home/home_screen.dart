import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/constants.dart';
import '../../state/quiz_provider.dart';
import '../../data/services/json_service.dart';
import '../../data/services/saved_quiz_service.dart';
import '../quiz/quiz_screen.dart';
import '../shared/pressable.dart';
import '../shared/theme_dropdown.dart';
import '../stats/stats_screen.dart';
import 'topics_screen.dart';
import 'widgets/import_card.dart';
import 'widgets/topic_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SavedQuizMeta> _saved = [];

  @override
  void initState() {
    super.initState();
    _refreshSaved();
  }

  Future<void> _refreshSaved() async {
    final list = await SavedQuizService.list();
    if (mounted) setState(() => _saved = list);
  }

  Future<void> _importJson() async {
    final quizSet = await JsonService.pickFile();
    if (quizSet != null && mounted) {
      context.read<QuizProvider>().loadQuizSet(quizSet);
      await _refreshSaved();
    }
  }

  Future<void> _loadSample() async {
    final quizSet = await JsonService.loadSample();
    if (quizSet != null && mounted) {
      context.read<QuizProvider>().loadQuizSet(quizSet);
    }
  }

  Future<void> _loadSaved(SavedQuizMeta meta) async {
    final quizSet = await JsonService.loadSaved(meta);
    if (quizSet != null && mounted) {
      context.read<QuizProvider>().loadQuizSet(quizSet);
    }
  }

  Future<void> _deleteSaved(SavedQuizMeta meta) async {
    await SavedQuizService.delete(meta.filename);
    await _refreshSaved();
  }

  void _startQuiz() {
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
          // ── Top nav ──────────────────────────────────────────
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
                              isComplete: false, isStandalone: true),
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

                  // ── Import card ─────────────────────────────
                  ImportCard(
                    onBrowse: _importJson,
                    onSample: _loadSample,
                    hasQuiz: quizSet != null,
                    quizName: quizSet?.name,
                  ),

                  // ── Saved quizzes ───────────────────────────
                  if (_saved.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Text(
                          'Saved Quizzes',
                          style: GoogleFonts.inter(
                            color: c.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: c.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_saved.length}',
                            style: GoogleFonts.inter(
                              color: c.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._saved.map((meta) => _SavedQuizRow(
                          meta: meta,
                          isActive: quizSet?.name == meta.name,
                          onLoad: () => _loadSaved(meta),
                          onDelete: () => _deleteSaved(meta),
                        )),
                  ],

                  // ── Topic selector ──────────────────────────
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
                        onTap: _startQuiz,
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
                  ] else if (_saved.isEmpty) ...[
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

// ── Saved quiz row ────────────────────────────────────────────

class _SavedQuizRow extends StatelessWidget {
  final SavedQuizMeta meta;
  final bool isActive;
  final VoidCallback onLoad;
  final VoidCallback onDelete;

  const _SavedQuizRow({
    required this.meta,
    required this.isActive,
    required this.onLoad,
    required this.onDelete,
  });

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: c.cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive
                ? c.primary.withValues(alpha: 0.5)
                : c.border,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Load button area
            Expanded(
              child: Pressable(
                onTap: onLoad,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 13),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isActive
                              ? c.primary.withValues(alpha: 0.15)
                              : c.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: isActive
                                  ? c.primary.withValues(alpha: 0.3)
                                  : c.border),
                        ),
                        child: Icon(
                          isActive
                              ? Icons.check_rounded
                              : Icons.folder_open_rounded,
                          color: isActive ? c.primary : c.textSecondary,
                          size: 17,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meta.name,
                              style: GoogleFonts.inter(
                                color: isActive
                                    ? c.primary
                                    : c.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isActive
                                  ? 'Currently loaded'
                                  : 'Saved · ${_timeAgo(meta.savedAt)}',
                              style: GoogleFonts.inter(
                                color: isActive
                                    ? c.primary.withValues(alpha: 0.7)
                                    : c.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isActive)
                        Text(
                          'Load',
                          style: GoogleFonts.inter(
                            color: c.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Delete button
            GestureDetector(
              onTap: onDelete,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Icon(Icons.delete_outline_rounded,
                    color: c.textMuted, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
