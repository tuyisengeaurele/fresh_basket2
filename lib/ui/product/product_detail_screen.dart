import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/snackbar_helper.dart';
import '../../data/models/product_model.dart';
import '../../providers/cart_provider.dart';
import 'widgets/freshness_badge.dart';
import 'widgets/nutritional_info_card.dart';
import 'widgets/reviews_section.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  double _quantity = 1.0;

  void _increment() => setState(() => _quantity += 0.5);
  void _decrement() {
    if (_quantity > 0.5) setState(() => _quantity -= 0.5);
  }

  void _addToCart() {
    context.read<CartProvider>().addItem(widget.product, quantity: _quantity);
    SnackbarHelper.showSuccess(
      context,
      '${widget.product.name} added to cart.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final images = p.imageUrls.isNotEmpty ? p.imageUrls : [p.imageUrl];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Image sliver app bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            flexibleSpace: FlexibleSpaceBar(
              background: PageView.builder(
                itemCount: images.length,
                itemBuilder: (_, i) => CachedNetworkImage(
                  imageUrl: images[i],
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.chipBackground,
                    child: const Icon(
                      Icons.image_outlined,
                      size: 60,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + freshness
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(p.name, style: AppTextStyles.headlineLarge),
                      ),
                      const SizedBox(width: 12),
                      FreshnessBadge(level: p.freshnessLevel, large: true),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Rating
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: p.rating,
                        itemBuilder: (_, __) => const Icon(
                          Icons.star_rounded,
                          color: AppColors.starYellow,
                        ),
                        itemCount: 5,
                        itemSize: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${p.rating.toStringAsFixed(1)} (${p.reviewCount} reviews)',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price + quantity selector
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Formatters.currency(p.pricePerKg),
                            style: AppTextStyles.priceLarge,
                          ),
                          Text(
                            'per ${p.unit}',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Quantity selector
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _QtyButton(
                              icon: Icons.remove_rounded,
                              onTap: _decrement,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '${_quantity.toStringAsFixed(1)} ${p.unit}',
                                style: AppTextStyles.titleLarge,
                              ),
                            ),
                            _QtyButton(
                              icon: Icons.add_rounded,
                              onTap: _increment,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text('About', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    p.description,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nutritional info
                  if (p.nutritionalInfo != null) ...[
                    NutritionalInfoCard(info: p.nutritionalInfo!),
                    const SizedBox(height: 24),
                  ],

                  // Reviews
                  ReviewsSection(
                    productId: p.id,
                    avgRating: p.rating,
                    reviewCount: p.reviewCount,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _AddToCartBar(
        product: p,
        quantity: _quantity,
        onAdd: _addToCart,
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.chipBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
      );
}

class _AddToCartBar extends StatelessWidget {
  final ProductModel product;
  final double quantity;
  final VoidCallback onAdd;

  const _AddToCartBar({
    required this.product,
    required this.quantity,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.fromLTRB(
            20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total', style: AppTextStyles.bodySmall),
                Text(
                  Formatters.currency(product.pricePerKg * quantity),
                  style: AppTextStyles.priceLarge,
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                label: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      );
}
