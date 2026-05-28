import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/topic.dart';
import '../theme/app_theme.dart';

class TopicCard extends StatelessWidget {
  final Topic topic;
  final int index;
  final VoidCallback onTap;

  const TopicCard({
    super.key,
    required this.topic,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = AppTheme.gradientFor(index);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
        ),
        child: Stack(
          children: [
            // Subtle dot pattern overlay
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CustomPaint(painter: _DotPainter()),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      'PHYSICS',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    topic.name,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (topic.description.isNotEmpty)
                    Text(
                      topic.description,
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${topic.questions.length} questions',
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                      _DifficultyChip(difficulty: topic.difficulty),
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

class _DifficultyChip extends StatelessWidget {
  final String difficulty;
  const _DifficultyChip({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final Color color;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        color = const Color(0xFF4CAF50);
      case 'hard':
        color = const Color(0xFFEF5350);
      default:
        color = const Color(0xFFE4C693);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        difficulty,
        style: GoogleFonts.inter(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// Subtle dot-grid overlay
class _DotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;
    const spacing = 18.0;
    const radius = 1.2;
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
