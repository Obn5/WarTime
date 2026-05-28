import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/app_theme.dart';

class StatCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget child;
  final bool fullWidth;

  const StatCard({
    super.key,
    required this.label,
    required this.icon,
    required this.child,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.textSecondary, size: 14),
                const SizedBox(width: 6),
                Text(
                  label.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      );
}
