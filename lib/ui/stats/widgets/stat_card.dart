import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/theme.dart';

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
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: c.textSecondary, size: 14),
              const SizedBox(width: 6),
              Text(label.toUpperCase(), style: AppTheme.labelSmall(c.textSecondary)),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
