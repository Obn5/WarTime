import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../data/services/download_service.dart';
import '../../state/quiz_provider.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final Set<int> _loading = {};
  final Set<int> _done = {};
  String? _error;

  Future<void> _download(int index) async {
    final pack = DownloadService.catalog[index];
    setState(() {
      _loading.add(index);
      _error = null;
    });

    try {
      final quizSet = await DownloadService.download(pack);
      if (!mounted) return;
      if (quizSet == null) {
        setState(() => _error = 'Failed to download "${pack.name}". Try again.');
      } else {
        context.read<QuizProvider>().loadQuizSet(quizSet);
        setState(() => _done.add(index));
        _showSuccess(pack.name);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'No internet connection or server error.');
      }
    } finally {
      if (mounted) setState(() => _loading.remove(index));
    }
  }

  void _showSuccess(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$name loaded! Go back to start the quiz.',
          style: GoogleFonts.inter(fontSize: 13),
        ),
        backgroundColor: const Color(0xFF4A7C59),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final catalog = DownloadService.catalog;

    return Scaffold(
      backgroundColor: c.bg,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: c.cardDark,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: c.border),
                      ),
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          color: c.textSecondary, size: 15),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Download Topics',
                    style: GoogleFonts.inter(
                      color: c.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Subtitle ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tap any topic to download 30 questions and start playing.',
                  style: GoogleFonts.inter(
                      color: c.textSecondary, fontSize: 13),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDEAEA),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xFFC0392B).withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline_rounded,
                            color: Color(0xFFC0392B), size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: GoogleFonts.inter(
                              color: const Color(0xFFC0392B),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Grid ────────────────────────────────────────────
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.05,
              ),
              itemCount: catalog.length,
              itemBuilder: (context, i) {
                final pack = catalog[i];
                final isLoading = _loading.contains(i);
                final isDone = _done.contains(i);
                return _PackCard(
                  pack: pack,
                  isLoading: isLoading,
                  isDone: isDone,
                  onTap: isLoading ? null : () => _download(i),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PackCard extends StatelessWidget {
  final TopicPack pack;
  final bool isLoading;
  final bool isDone;
  final VoidCallback? onTap;

  const _PackCard({
    required this.pack,
    required this.isLoading,
    required this.isDone,
    required this.onTap,
  });

  static const List<List<Color>> _gradients = [
    [Color(0xFF0D2137), Color(0xFF1A4A6B)],
    [Color(0xFF1C0A2A), Color(0xFF3D1060)],
    [Color(0xFF1A2A0A), Color(0xFF3D5A1A)],
    [Color(0xFF2A1A0A), Color(0xFF5A3010)],
    [Color(0xFF0A1A2A), Color(0xFF1A3A5A)],
    [Color(0xFF1A0A1A), Color(0xFF4A1A3A)],
    [Color(0xFF0A2A2A), Color(0xFF1A5A5A)],
    [Color(0xFF2A2A0A), Color(0xFF5A5A1A)],
    [Color(0xFF0A0A2A), Color(0xFF1A1A5A)],
    [Color(0xFF2A0A0A), Color(0xFF5A1A1A)],
  ];

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final idx = DownloadService.catalog.indexOf(pack);
    final grad = _gradients[idx % _gradients.length];

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: grad,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDone
                ? const Color(0xFF4A7C59)
                : c.border.withValues(alpha: 0.4),
            width: isDone ? 1.5 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(pack.emoji, style: const TextStyle(fontSize: 32)),
              const Spacer(),
              Text(
                pack.name,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                pack.description,
                style: GoogleFonts.inter(
                  color: Colors.white60,
                  fontSize: 10,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              _buildButton(c),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(AppColors c) {
    if (isLoading) {
      return Container(
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white60,
            ),
          ),
        ),
      );
    }

    if (isDone) {
      return Container(
        height: 30,
        decoration: BoxDecoration(
          color: const Color(0xFF4A7C59),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_rounded, color: Colors.white, size: 13),
            const SizedBox(width: 5),
            Text(
              'Loaded',
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.download_rounded, color: Colors.white70, size: 13),
          const SizedBox(width: 5),
          Text(
            'Download',
            style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
