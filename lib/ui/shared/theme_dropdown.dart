import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../state/theme_provider.dart';

class ThemeDropdown extends StatefulWidget {
  const ThemeDropdown({super.key});

  @override
  State<ThemeDropdown> createState() => _ThemeDropdownState();
}

class _ThemeDropdownState extends State<ThemeDropdown>
    with SingleTickerProviderStateMixin {
  final _link = LayerLink();
  OverlayEntry? _entry;
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _close();
    _ctrl.dispose();
    super.dispose();
  }

  void _open() {
    final c = Theme.of(context).extension<AppColors>()!;
    _entry = OverlayEntry(
      builder: (_) => _DropdownOverlay(
        link: _link,
        fade: _fade,
        slide: _slide,
        colors: c,
        onClose: _close,
      ),
    );
    Overlay.of(context).insert(_entry!);
    _ctrl.forward(from: 0);
  }

  void _close() {
    _entry?.remove();
    _entry = null;
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    return CompositedTransformTarget(
      link: _link,
      child: GestureDetector(
        onTap: () => _entry == null ? _open() : _close(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: c.cardDark,
            shape: BoxShape.circle,
            border: Border.all(color: c.border),
          ),
          child: Icon(
            Icons.tune_rounded,
            color: c.textSecondary,
            size: 17,
          ),
        ),
      ),
    );
  }
}

class _DropdownOverlay extends StatelessWidget {
  final LayerLink link;
  final Animation<double> fade;
  final Animation<Offset> slide;
  final AppColors colors;
  final VoidCallback onClose;

  const _DropdownOverlay({
    required this.link,
    required this.fade,
    required this.slide,
    required this.colors,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dismiss tap area
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onClose,
          ),
        ),
        CompositedTransformFollower(
          link: link,
          showWhenUnlinked: false,
          offset: const Offset(-140, 44),
          child: SlideTransition(
            position: slide,
            child: FadeTransition(
              opacity: fade,
              child: _DropdownPanel(colors: colors, onClose: onClose),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownPanel extends StatelessWidget {
  final AppColors colors;
  final VoidCallback onClose;

  const _DropdownPanel({required this.colors, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeProvider>();
    final c = colors;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 178,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'APPEARANCE',
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8,
                  color: c.textSecondary,
                ),
              ),
            ),
            _ThemeOption(
              label: 'Terra',
              subtitle: 'Light · Green earth',
              dotColor: const Color(0xFF4A7C59),
              bgColor: const Color(0xFFEFF1EB),
              isSelected: provider.mode == ColorMode.terra,
              colors: c,
              onTap: () {
                provider.setMode(ColorMode.terra);
                onClose();
              },
            ),
            const SizedBox(height: 6),
            _ThemeOption(
              label: 'Slate & Ember',
              subtitle: 'Dark · Amber glow',
              dotColor: const Color(0xFFC4A66A),
              bgColor: const Color(0xFF16181F),
              isSelected: provider.mode == ColorMode.slateEmber,
              colors: c,
              onTap: () {
                provider.setMode(ColorMode.slateEmber);
                onClose();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color dotColor;
  final Color bgColor;
  final bool isSelected;
  final AppColors colors;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.subtitle,
    required this.dotColor,
    required this.bgColor,
    required this.isSelected,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? c.primary.withValues(alpha: 0.12)
              : c.cardDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? c.primary.withValues(alpha: 0.4) : c.border,
          ),
        ),
        child: Row(
          children: [
            // Mini palette preview
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.black.withValues(alpha: 0.1)),
              ),
              child: Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      color: c.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: c.textSecondary,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_rounded, color: c.primary, size: 14),
          ],
        ),
      ),
    );
  }
}
