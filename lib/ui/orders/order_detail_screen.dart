import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../data/models/order_model.dart';
import '../../providers/cart_provider.dart';
import '../../app/routes.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('Order ${order.displayId}'),
          actions: [
            if (order.status == OrderStatus.dispatched ||
                order.status == OrderStatus.placed ||
                order.status == OrderStatus.preparing)
              TextButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.orderTracking,
                  arguments: order.id,
                ),
                child: const Text('Track'),
              ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Status badge
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: _statusColor(order.status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  order.status.label,
                  style: TextStyle(
                    color: _statusColor(order.status),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Order info
            _SectionCard(
              title: 'Order Information',
              children: [
                _InfoRow('Order ID', order.displayId),
                _InfoRow('Date', Formatters.dateTime(order.createdAt)),
                _InfoRow('Payment', order.paymentMethod),
                _InfoRow('Time Slot', order.timeSlot),
              ],
            ),
            const SizedBox(height: 16),

            // Items
            _SectionCard(
              title: 'Items (${order.items.length})',
              children: [
                ...order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: CachedNetworkImage(
                              imageUrl: item.imageUrl,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(
                                color: AppColors.chipBackground,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name,
                                  style: AppTextStyles.titleLarge),
                              Text(
                                '${item.quantity} ${item.unit} × ${Formatters.currency(item.pricePerKg)}',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          Formatters.currency(item.totalPrice),
                          style: AppTextStyles.priceTag.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Payment summary
            _SectionCard(
              title: 'Payment Summary',
              children: [
                _InfoRow('Subtotal', Formatters.currency(order.subtotal)),
                _InfoRow('Delivery Fee',
                    Formatters.currency(order.deliveryFee)),
                if (order.discount > 0)
                  _InfoRow(
                    'Discount',
                    '-${Formatters.currency(order.discount)}',
                    valueColor: AppColors.freshGreen,
                  ),
                const Divider(),
                _InfoRow(
                  'Total',
                  Formatters.currency(order.total),
                  isBold: true,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Delivery address
            _SectionCard(
              title: 'Delivery Address',
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.address.fullAddress,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Reorder button
            OutlinedButton.icon(
              onPressed: () async {
                await context.read<CartProvider>().reorder(order.items);
                if (context.mounted) {
                  SnackbarHelper.showSuccess(
                      context, 'Items added to cart!');
                }
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Reorder'),
            ),
          ],
        ),
      );

  Color _statusColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.placed:
        return Colors.blue;
      case OrderStatus.preparing:
        return AppColors.secondary;
      case OrderStatus.dispatched:
        return AppColors.primaryLight;
      case OrderStatus.delivered:
        return AppColors.freshGreen;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.headlineSmall),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _InfoRow(this.label, this.value, {this.valueColor, this.isBold = false});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight:
                    isBold ? FontWeight.w700 : FontWeight.w600,
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
          ],
        ),
      );
}
