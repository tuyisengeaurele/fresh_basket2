import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../providers/cart_provider.dart';

class PromoCodeField extends StatefulWidget {
  const PromoCodeField({super.key});

  @override
  State<PromoCodeField> createState() => _PromoCodeFieldState();
}

class _PromoCodeFieldState extends State<PromoCodeField> {
  final _ctrl = TextEditingController();
  bool _isApplying = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    final code = _ctrl.text.trim();
    if (code.isEmpty) return;
    setState(() => _isApplying = true);
    final error = await context.read<CartProvider>().applyPromoCode(code);
    if (!mounted) return;
    setState(() => _isApplying = false);
    if (error != null) {
      SnackbarHelper.showError(context, error);
    } else {
      final discount = context.read<CartProvider>().discountPercent;
      SnackbarHelper.showSuccess(context, '${discount.round()}% discount applied!');
      _ctrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final hasPromo = cart.promoCode != null;

    if (hasPromo) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.chipBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primaryLight.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.local_offer_outlined,
                color: AppColors.primary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cart.promoCode!,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '${cart.discountPercent.round()}% discount applied',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => context.read<CartProvider>().removePromoCode(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
                padding: EdgeInsets.zero,
              ),
              child: const Text('Remove'),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _ctrl,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              hintText: 'Promo code',
              prefixIcon: Icon(Icons.local_offer_outlined),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: _isApplying ? null : _apply,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(80, 54),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: _isApplying
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : const Text('Apply'),
          ),
        ),
      ],
    );
  }
}
