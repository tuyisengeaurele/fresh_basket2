import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/product_model.dart';

class NutritionalInfoCard extends StatefulWidget {
  final NutritionalInfo info;

  const NutritionalInfoCard({super.key, required this.info});

  @override
  State<NutritionalInfoCard> createState() => _NutritionalInfoCardState();
}

class _NutritionalInfoCardState extends State<NutritionalInfoCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: AppColors.chipBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider, width: 0.5),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_dining_outlined,
                      color: AppColors.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Nutritional Info',
                      style: AppTextStyles.headlineSmall,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${widget.info.calories} kcal/100g',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
            if (_expanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    const Divider(),
                    const SizedBox(height: 8),
                    _NutrientRow(
                      label: 'Vitamins',
                      value: widget.info.vitamins,
                      icon: Icons.science_outlined,
                    ),
                    _NutrientRow(
                      label: 'Fiber',
                      value: widget.info.fiber,
                      icon: Icons.grass_outlined,
                    ),
                    _NutrientRow(
                      label: 'Protein',
                      value: widget.info.protein,
                      icon: Icons.fitness_center_outlined,
                    ),
                    _NutrientRow(
                      label: 'Carbs',
                      value: widget.info.carbs,
                      icon: Icons.grain_outlined,
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
}

class _NutrientRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _NutrientRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primaryLight),
            const SizedBox(width: 10),
            Text(label, style: AppTextStyles.bodyMedium),
            const Spacer(),
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
}
