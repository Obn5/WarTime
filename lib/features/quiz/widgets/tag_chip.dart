import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/app_theme.dart';

class TagChip extends StatelessWidget {
  final String label;
  final Color color;

  const TagChip(this.label, {super.key, this.color = AppTheme.teal});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            color: color.withValues(alpha: 0.9),
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      );
}
