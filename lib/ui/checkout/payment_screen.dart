import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../data/models/user_model.dart';
import '../../data/services/payment_service.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../app/routes.dart';

class PaymentScreen extends StatefulWidget {
  final UserAddress address;
  final String timeSlot;

  const PaymentScreen({
    super.key,
    required this.address,
    required this.timeSlot,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod _method = PaymentMethod.card;
  bool _processing = false;

  Future<void> _pay() async {
    setState(() => _processing = true);
    final auth = context.read<AuthProvider>();
    final cart = context.read<CartProvider>();
    final user = auth.user!;

    final result = await PaymentService().initiatePayment(
      context: context,
      amount: cart.total,
      email: user.email,
      phone: user.phone,
      name: user.name,
      method: _method,
    );

    if (!mounted) return;

    if (!result.success) {
      setState(() => _processing = false);
      SnackbarHelper.showError(
          context, result.errorMessage ?? 'Payment failed.');
      return;
    }

    // Create order
    final order = await context.read<OrderProvider>().placeOrder(
          userId: user.id,
          items: cart.items.toList(),
          subtotal: cart.subtotal,
          deliveryFee: CartProvider.deliveryFee,
          total: cart.total,
          promoCode: cart.promoCode,
          discount: cart.discountAmount,
          address: widget.address,
          timeSlot: widget.timeSlot,
          paymentMethod: _method == PaymentMethod.card
              ? 'Card'
              : 'Mobile Money',
          paymentReference: result.transactionRef ?? '',
        );

    if (!mounted) return;

    if (order == null) {
      setState(() => _processing = false);
      SnackbarHelper.showError(context, 'Order creation failed. Contact support.');
      return;
    }

    cart.clear();
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.orderConfirmation,
      arguments: order,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Payment')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Order summary
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
                Text('Order Summary', style: AppTextStyles.headlineSmall),
                const SizedBox(height: 14),
                ...cart.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.name} × ${item.quantity} ${item.unit}',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                        Text(
                          Formatters.currency(item.totalPrice),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),
                _Row('Subtotal', Formatters.currency(cart.subtotal)),
                _Row('Delivery', Formatters.currency(CartProvider.deliveryFee)),
                if (cart.discountAmount > 0)
                  _Row(
                    'Discount',
                    '-${Formatters.currency(cart.discountAmount)}',
                    color: AppColors.freshGreen,
                  ),
                const SizedBox(height: 8),
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

          // Delivery details
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.chipBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivery Details', style: AppTextStyles.titleLarge),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.address.fullAddress,
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(widget.timeSlot, style: AppTextStyles.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Payment method
          Text('Payment Method', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),
          _MethodTile(
            icon: Icons.credit_card_outlined,
            title: 'Card Payment',
            subtitle: 'Visa, Mastercard',
            isSelected: _method == PaymentMethod.card,
            onTap: () => setState(() => _method = PaymentMethod.card),
          ),
          const SizedBox(height: 10),
          _MethodTile(
            icon: Icons.phone_android_outlined,
            title: 'Mobile Money',
            subtitle: 'MTN MoMo, Airtel Money',
            isSelected: _method == PaymentMethod.mobileMoney,
            onTap: () => setState(() => _method = PaymentMethod.mobileMoney),
          ),
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
            16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: ElevatedButton(
          onPressed: _processing ? null : _pay,
          child: _processing
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Text(
                  'Pay ${Formatters.currency(cart.total)}',
                ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _Row(this.label, this.value, {this.color});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
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
                color: color ?? AppColors.textPrimary,
              ),
            ),
          ],
        ),
      );
}

class _MethodTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _MethodTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.chipBackground : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.divider,
              width: isSelected ? 2 : 0.8,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.chipBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.titleLarge),
                    Text(subtitle, style: AppTextStyles.caption),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle_rounded,
                    color: AppColors.primary, size: 22),
            ],
          ),
        ),
      );
}
