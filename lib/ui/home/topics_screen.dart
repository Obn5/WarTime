import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../state/quiz_provider.dart';
import '../../data/models/topic.dart';
import '../quiz/quiz_screen.dart';
import '../shared/pressable.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  String _filter = 'All';

  void _startQuiz(BuildContext context) {
    context.read<QuizProvider>().startQuiz();
    Navigator.pushReplacement(
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
    final topics = provider.quizSet?.topics ?? [];

    final filtered = _filter == 'All'
        ? topics
        : topics
            .where((t) => t.difficulty.toLowerCase() == _filter.toLowerCase())
            .toList();

    return Scaffold(
      backgroundColor: c.bg,
      body: Column(
        children: [
          // ── Top nav ─────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  Pressable(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: c.cardDark,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: c.border),
                      ),
                      child: Icon(Icons.arrow_back_rounded,
                          color: c.textSecondary, size: 16),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'All Topics',
                          style: GoogleFonts.inter(
                            color: c.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${topics.length} topics available',
                          style: GoogleFonts.inter(
                              color: c.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: c.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: c.primary.withValues(alpha: 0.25)),
                    ),
                    child: Text(
                      '${topics.length}',
                      style: GoogleFonts.inter(
                        color: c.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Filter chips ─────────────────────────────────────
          SizedBox(
            height: 36,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: ['All', 'Easy', 'Medium', 'Hard'].map((f) {
                final active = _filter == f;
                final chipColor = f == 'Easy'
                    ? const Color(0xFF4CAF50)
                    : f == 'Hard'
                        ? const Color(0xFFEF5350)
                        : c.primary;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Pressable(
                    onTap: () => setState(() => _filter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: active
                            ? chipColor.withValues(alpha: 0.15)
                            : c.cardDark,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: active
                              ? chipColor.withValues(alpha: 0.5)
                              : c.border,
                        ),
                      ),
                      child: Text(
                        f,
                        style: GoogleFonts.inter(
                          color: active ? chipColor : c.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // ── Topics grid ──────────────────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 48,
                            color: c.textMuted.withValues(alpha: 0.4)),
                        const SizedBox(height: 12),
                        Text(
                          'No $_filter topics',
                          style: GoogleFonts.inter(
                              color: c.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.82,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final topic = filtered[i];
                      final globalIndex = topics.indexOf(topic);
                      return _TopicGridCard(
                        topic: topic,
                        index: globalIndex,
                        isSelected:
                            provider.selectedTopic?.id == topic.id,
                        onTap: () => provider.selectTopic(topic),
                      );
                    },
                  ),
          ),

          // ── Start button ─────────────────────────────────────
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            child: provider.selectedTopic != null
                ? SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                      child: Pressable(
                        onTap: () => _startQuiz(context),
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [c.green, c.greenMid],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: c.green.withValues(alpha: 0.35),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Start · ${provider.selectedTopic!.name}',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded,
                                  color: Colors.white, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ── Topic grid card ────────────────────────────────────────────

class _TopicGridCard extends StatelessWidget {
  final Topic topic;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _TopicGridCard({
    required this.topic,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final gradient = c.gradientFor(index);
    final indexLabel = (index + 1).toString().padLeft(2, '0');

    return Pressable(
      onTap: onTap,
      scale: 0.97,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          border: isSelected
              ? Border.all(color: c.primary, width: 2)
              : Border.all(color: Colors.white.withValues(alpha: 0.07)),
          boxShadow: [
            BoxShadow(
              color: gradient[1].withValues(alpha: isSelected ? 0.45 : 0.2),
              blurRadius: isSelected ? 18 : 8,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CustomPaint(painter: _DotPainter()),
              ),
            ),
            Positioned(
              top: 0, left: 0, right: 0, height: 60,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.09),
                      Colors.transparent
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.18)),
                        ),
                        child: Text(
                          '#$indexLabel',
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (isSelected)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: c.primary, shape: BoxShape.circle),
                          child:
                              Icon(Icons.check_rounded, color: c.bg, size: 10),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    topic.name,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (topic.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      topic.description,
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 10,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const Spacer(),
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.1),
                    margin: const EdgeInsets.only(bottom: 8),
                  ),
                  Row(
                    children: [
                      Text(
                        '${topic.questions.length} Q',
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.55),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      _DifficultyDot(topic.difficulty),
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

class _DifficultyDot extends StatelessWidget {
  final String difficulty;
  const _DifficultyDot(this.difficulty);

  @override
  Widget build(BuildContext context) {
    final Color color;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        color = const Color(0xFF4CAF50);
      case 'hard':
        color = const Color(0xFFEF5350);
      default:
        color = Theme.of(context).extension<AppColors>()!.primary;
    }
    return Row(
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          difficulty,
          style: GoogleFonts.inter(
              color: color, fontSize: 9, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _DotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;
    const spacing = 16.0;
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
