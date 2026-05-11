import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/order_model.dart';
import '../../app/routes.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final OrderModel order;

  const OrderConfirmationScreen({super.key, required this.order});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  // Lottie animation — fallback to icon if asset missing
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: Lottie.asset(
                      'assets/animations/success.json',
                      controller: _ctrl,
                      onLoaded: (comp) {
                        _ctrl
                          ..duration = comp.duration
                          ..forward();
                      },
                      errorBuilder: (_, __, ___) => Container(
                        decoration: const BoxDecoration(
                          color: AppColors.chipBackground,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 80,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Order Confirmed!',
                    style: AppTextStyles.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your order ${widget.order.displayId} has been placed successfully.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Order details card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider, width: 0.5),
                    ),
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: Icons.tag_rounded,
                          label: 'Order ID',
                          value: widget.order.displayId,
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                          icon: Icons.payments_outlined,
                          label: 'Total Paid',
                          value: Formatters.currency(widget.order.total),
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                          icon: Icons.access_time_rounded,
                          label: 'Time Slot',
                          value: widget.order.timeSlot,
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                          icon: Icons.timer_outlined,
                          label: 'Est. Delivery',
                          value: widget.order.estimatedDelivery != null
                              ? Formatters.dateTime(
                                  widget.order.estimatedDelivery!)
                              : 'Within 3 hours',
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.orderTracking,
                      arguments: widget.order.id,
                    ),
                    icon: const Icon(Icons.location_searching_rounded, size: 20),
                    label: const Text('Track Order'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (r) => false,
                    ),
                    child: const Text('Continue Shopping'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(label,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      );
}
