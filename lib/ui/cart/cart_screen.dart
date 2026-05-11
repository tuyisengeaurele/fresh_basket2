import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../providers/cart_provider.dart';
import '../../app/routes.dart';
import '../shared/empty_state_widget.dart';
import 'widgets/cart_item_tile.dart';
import 'widgets/promo_code_field.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Cart (${cart.itemCount})'),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Clear Cart'),
                  content: const Text(
                      'Remove all items from your cart?'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                    TextButton(
                      onPressed: () {
                        cart.clear();
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                          foregroundColor: AppColors.error),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ),
              child: Text(
                'Clear',
                style: AppTextStyles.labelLarge
                    .copyWith(color: AppColors.error),
              ),
            ),
        ],
      ),
      body: cart.isEmpty
          ? EmptyStateWidget(
              icon: Icons.shopping_cart_outlined,
              title: 'Your cart is empty',
              subtitle: 'Add fresh produce to get started.',
              actionLabel: 'Start Shopping',
              onAction: () => Navigator.popUntil(context, (r) => r.isFirst),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Items
                ...cart.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CartItemTile(item: item),
                  ),
                ),
                const SizedBox(height: 8),

                // Promo code
                const PromoCodeField(),
                const SizedBox(height: 20),

                // Order summary card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider, width: 0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order Summary',
                          style: AppTextStyles.headlineSmall),
                      const SizedBox(height: 16),
                      _SummaryRow(
                          label: 'Subtotal',
                          value: Formatters.currency(cart.subtotal)),
                      _SummaryRow(
                          label: 'Delivery Fee',
                          value: Formatters.currency(CartProvider.deliveryFee)),
                      if (cart.discountAmount > 0)
                        _SummaryRow(
                          label:
                              'Discount (${cart.discountPercent.round()}%)',
                          value:
                              '-${Formatters.currency(cart.discountAmount)}',
                          valueColor: AppColors.freshGreen,
                        ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: AppTextStyles.headlineSmall),
                          Text(
                            Formatters.currency(cart.total),
                            style: AppTextStyles.priceLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : Container(
              padding: EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  MediaQuery.of(context).padding.bottom + 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border:
                    Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.addressPicker),
                child: const Text('Proceed to Checkout'),
              ),
            ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

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
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
          ],
        ),
      );
}
