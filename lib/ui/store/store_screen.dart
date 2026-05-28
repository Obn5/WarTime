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
  final Map<int, String> _addedDiff = {}; // index → difficulty label added
  String _difficulty = 'medium';
  String? _error;

  static const _difficulties = ['easy', 'medium', 'hard'];
  static const _diffLabels  = ['Easy', 'Medium', 'Hard'];
  static const _diffColors  = [
    Color(0xFF4A7C59),
    Color(0xFFC4A66A),
    Color(0xFFC0392B),
  ];

  Future<void> _add(int index) async {
    setState(() { _loading.add(index); _error = null; });
    try {
      final pack = DownloadService.catalog[index];
      final topic = await DownloadService.downloadTopic(pack, _difficulty);
      if (!mounted) return;
      if (topic == null) {
        setState(() => _error = 'Could not load "${pack.name}". Try again.');
      } else {
        context.read<QuizProvider>().addTopic(topic);
        setState(() => _addedDiff[index] = _difficulty);
        _showSnack('${pack.name} added to your collection!');
      }
    } catch (_) {
      if (mounted) setState(() => _error = 'No internet. Check your connection.');
    } finally {
      if (mounted) setState(() => _loading.remove(index));
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.inter(fontSize: 13)),
      backgroundColor: const Color(0xFF4A7C59),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final topicCount = context.watch<QuizProvider>().quizSet?.topics.length ?? 0;
    final catalog = DownloadService.catalog;

    return Scaffold(
      backgroundColor: c.bg,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36, height: 36,
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
                  Text('Topic Store',
                      style: GoogleFonts.inter(
                          color: c.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  // Collection badge
                  if (topicCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: c.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: c.primary.withValues(alpha: 0.3)),
                      ),
                      child: Row(children: [
                        Icon(Icons.collections_bookmark_rounded,
                            color: c.primary, size: 13),
                        const SizedBox(width: 5),
                        Text('$topicCount loaded',
                            style: GoogleFonts.inter(
                                color: c.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700)),
                      ]),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ── Profile banner ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D2137), Color(0xFF1C0A2A), Color(0xFF2A1A0A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: Colors.white10),
              ),
              child: Stack(
                children: [
                  // Background glow
                  Positioned(
                    right: -20, top: -20,
                    child: Container(
                      width: 130, height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFC4A66A).withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    child: Row(
                      children: [
                        // Profile image
                        Container(
                          width: 72, height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFFC4A66A).withValues(alpha: 0.6),
                                width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFC4A66A).withValues(alpha: 0.2),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/dum.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Topic Store',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '24 categories · Powered by Open Trivia DB',
                                style: GoogleFonts.inter(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC4A66A).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: const Color(0xFFC4A66A)
                                          .withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  'Pick difficulty · Add topics · Play',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFC4A66A),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ── Difficulty tabs ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: c.cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.border),
              ),
              child: Row(
                children: List.generate(_difficulties.length, (i) {
                  final selected = _difficulty == _difficulties[i];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _difficulty = _difficulties[i]),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        height: 34,
                        decoration: BoxDecoration(
                          color: selected
                              ? _diffColors[i]
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        alignment: Alignment.center,
                        child: Text(_diffLabels[i],
                            style: GoogleFonts.inter(
                              color: selected
                                  ? Colors.white
                                  : c.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ── Hint / Error ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _error != null
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDEAEA),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xFFC0392B)
                              .withValues(alpha: 0.3)),
                    ),
                    child: Row(children: [
                      const Icon(Icons.error_outline_rounded,
                          color: Color(0xFFC0392B), size: 15),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(_error!,
                              style: GoogleFonts.inter(
                                  color: const Color(0xFFC0392B),
                                  fontSize: 12))),
                    ]))
                : Text(
                    'Pick a difficulty, then tap a topic to add it to your collection.',
                    style: GoogleFonts.inter(
                        color: c.textSecondary, fontSize: 12),
                  ),
          ),

          const SizedBox(height: 12),

          // ── Grid ────────────────────────────────────────────
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: catalog.length,
              itemBuilder: (context, i) {
                final pack = catalog[i];
                return _PackCard(
                  pack: pack,
                  cardIndex: i,
                  isLoading: _loading.contains(i),
                  addedDiff: _addedDiff[i],
                  selectedDiff: _difficulty,
                  onTap: _loading.contains(i) ? null : () => _add(i),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card ──────────────────────────────────────────────────────

class _PackCard extends StatelessWidget {
  final TopicPack pack;
  final int cardIndex;
  final bool isLoading;
  final String? addedDiff;
  final String selectedDiff;
  final VoidCallback? onTap;

  const _PackCard({
    required this.pack,
    required this.cardIndex,
    required this.isLoading,
    required this.addedDiff,
    required this.selectedDiff,
    required this.onTap,
  });

  static const _gradients = [
    [Color(0xFF0D2137), Color(0xFF1A4A6B)],
    [Color(0xFF1C0A2A), Color(0xFF3D1060)],
    [Color(0xFF0A2A0A), Color(0xFF2A5A20)],
    [Color(0xFF2A1A0A), Color(0xFF5A3010)],
    [Color(0xFF0A1A2A), Color(0xFF1A3A5A)],
    [Color(0xFF1A0A1A), Color(0xFF4A1A3A)],
    [Color(0xFF0A2A2A), Color(0xFF1A5A5A)],
    [Color(0xFF2A2A0A), Color(0xFF4A4A10)],
    [Color(0xFF1A0A2A), Color(0xFF3A1A5A)],
    [Color(0xFF2A0A0A), Color(0xFF5A1A1A)],
    [Color(0xFF0A1A0A), Color(0xFF1A3A1A)],
    [Color(0xFF1A1A0A), Color(0xFF3A3A10)],
  ];

  static const _diffColors = {
    'easy': Color(0xFF4A7C59),
    'medium': Color(0xFFC4A66A),
    'hard': Color(0xFFC0392B),
  };

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final grad = _gradients[cardIndex % _gradients.length];
    final isAdded = addedDiff != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: grad,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isAdded
                ? const Color(0xFF4A7C59).withValues(alpha: 0.7)
                : c.border.withValues(alpha: 0.35),
            width: isAdded ? 1.5 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(pack.emoji, style: const TextStyle(fontSize: 26)),
                  const Spacer(),
                  if (isAdded)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A7C59).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: const Color(0xFF4A7C59)
                                .withValues(alpha: 0.5)),
                      ),
                      child: Text(
                        addedDiff![0].toUpperCase() + addedDiff!.substring(1),
                        style: GoogleFonts.inter(
                            color: const Color(0xFF7AB893),
                            fontSize: 9,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(pack.name,
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(pack.description,
                  style: GoogleFonts.inter(
                      color: Colors.white54, fontSize: 9.5),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              _buildBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBtn() {
    if (isLoading) {
      return Container(
        height: 28,
        decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(8)),
        child: const Center(
          child: SizedBox(
            width: 13, height: 13,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: Colors.white60),
          ),
        ),
      );
    }

    final diffColor = _diffColors[selectedDiff] ?? const Color(0xFFC4A66A);
    final isAdded = addedDiff != null;

    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: isAdded
            ? Colors.white.withValues(alpha: 0.08)
            : diffColor.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: isAdded
                ? Colors.white24
                : diffColor.withValues(alpha: 0.5)),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          isAdded ? Icons.add_rounded : Icons.download_rounded,
          color: isAdded ? Colors.white54 : Colors.white70,
          size: 13,
        ),
        const SizedBox(width: 4),
        Text(
          isAdded ? 'Add Again' : 'Add to Quiz',
          style: GoogleFonts.inter(
              color: isAdded ? Colors.white54 : Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w600),
        ),
      ]),
    );
  }
}
