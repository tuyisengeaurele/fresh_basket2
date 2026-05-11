import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../providers/product_provider.dart';

class CategoryTabs extends StatelessWidget {
  const CategoryTabs({super.key});

  static const _icons = {
    'All': Icons.grid_view_rounded,
    'Vegetables': Icons.eco_outlined,
    'Fruits': Icons.local_florist_outlined,
    'Organic': Icons.grass_outlined,
    'Seasonal': Icons.wb_sunny_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final selected = context.watch<ProductProvider>().selectedCategory;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: AppStrings.categories.length,
        itemBuilder: (_, i) {
          final cat = AppStrings.categories[i];
          final isSelected = selected == cat;
          return GestureDetector(
            onTap: () =>
                context.read<ProductProvider>().selectCategory(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _icons[cat] ?? Icons.category_outlined,
                    size: 16,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
