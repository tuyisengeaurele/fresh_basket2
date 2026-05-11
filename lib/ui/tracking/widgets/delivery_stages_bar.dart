import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';

class DeliveryStagesBar extends StatelessWidget {
  final OrderStatus status;
  final DateTime createdAt;

  const DeliveryStagesBar({
    super.key,
    required this.status,
    required this.createdAt,
  });

  static const _stages = [
    _Stage(
      icon: Icons.check_circle_outline_rounded,
      label: 'Order Placed',
      status: OrderStatus.placed,
    ),
    _Stage(
      icon: Icons.restaurant_outlined,
      label: 'Preparing',
      status: OrderStatus.preparing,
    ),
    _Stage(
      icon: Icons.local_shipping_outlined,
      label: 'Out for Delivery',
      status: OrderStatus.dispatched,
    ),
    _Stage(
      icon: Icons.home_outlined,
      label: 'Delivered',
      status: OrderStatus.delivered,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentStep = status.step;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Delivery Status', style: AppTextStyles.headlineSmall),
        const SizedBox(height: 16),
        Row(
          children: List.generate(_stages.length * 2 - 1, (i) {
            if (i.isOdd) {
              // Connector line
              final stageIndex = i ~/ 2;
              final completed = currentStep > stageIndex;
              return Expanded(
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: completed ? AppColors.primary : AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }
            // Stage node
            final stageIndex = i ~/ 2;
            final stage = _stages[stageIndex];
            final completed = currentStep >= stage.status.step;
            final isCurrent = currentStep == stage.status.step;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: completed
                        ? AppColors.primary
                        : AppColors.chipBackground,
                    shape: BoxShape.circle,
                    border: isCurrent
                        ? Border.all(color: AppColors.primary, width: 3)
                        : null,
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 12,
                              spreadRadius: 2,
                            )
                          ]
                        : null,
                  ),
                  child: Icon(
                    stage.icon,
                    size: 20,
                    color: completed ? Colors.white : AppColors.textHint,
                  ),
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 8),
        // Labels row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _stages.map((s) {
            final completed = currentStep >= s.status.step;
            return SizedBox(
              width: 64,
              child: Text(
                s.label,
                style: AppTextStyles.caption.copyWith(
                  color: completed ? AppColors.primary : AppColors.textHint,
                  fontWeight:
                      completed ? FontWeight.w700 : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.chipBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Ordered at ${Formatters.time(createdAt)}',
                  style:
                      AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Stage {
  final IconData icon;
  final String label;
  final OrderStatus status;

  const _Stage({
    required this.icon,
    required this.label,
    required this.status,
  });
}
