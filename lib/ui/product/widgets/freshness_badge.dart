import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/product_model.dart';

class FreshnessBadge extends StatelessWidget {
  final FreshnessLevel level;
  final bool large;

  const FreshnessBadge({super.key, required this.level, this.large = false});

  Color get _color {
    switch (level) {
      case FreshnessLevel.fresh:
        return AppColors.freshGreen;
      case FreshnessLevel.good:
        return AppColors.goodAmber;
      case FreshnessLevel.limited:
        return AppColors.limitedRed;
    }
  }

  IconData get _icon {
    switch (level) {
      case FreshnessLevel.fresh:
        return Icons.verified_rounded;
      case FreshnessLevel.good:
        return Icons.check_circle_outline_rounded;
      case FreshnessLevel.limited:
        return Icons.timer_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = large ? 14.0 : 11.0;
    final padding = large
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 6)
        : const EdgeInsets.symmetric(horizontal: 8, vertical: 4);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: _color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: size + 2, color: _color),
          const SizedBox(width: 4),
          Text(
            level.label,
            style: TextStyle(
              color: _color,
              fontSize: size,
              fontWeight: FontWeight.w700,
              fontFamily: 'Nunito',
            ),
          ),
        ],
      ),
    );
  }
}
