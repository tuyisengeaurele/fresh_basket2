import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/review_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../providers/auth_provider.dart';

class ReviewsSection extends StatelessWidget {
  final String productId;
  final double avgRating;
  final int reviewCount;

  const ReviewsSection({
    super.key,
    required this.productId,
    required this.avgRating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    final repo = ProductRepository();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Reviews', style: AppTextStyles.headlineSmall),
            TextButton.icon(
              onPressed: () => _showWriteReview(context),
              icon: const Icon(Icons.rate_review_outlined, size: 16),
              label: const Text('Write a Review'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              avgRating.toStringAsFixed(1),
              style: AppTextStyles.displayMedium.copyWith(
                color: AppColors.primary,
                fontSize: 36,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RatingBarIndicator(
                  rating: avgRating,
                  itemBuilder: (_, __) => const Icon(
                    Icons.star_rounded,
                    color: AppColors.starYellow,
                  ),
                  itemCount: 5,
                  itemSize: 18,
                ),
                const SizedBox(height: 4),
                Text(
                  '$reviewCount reviews',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<ReviewModel>>(
          stream: repo.watchReviews(productId),
          builder: (_, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(strokeWidth: 2));
            }
            if (!snap.hasData || snap.data!.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No reviews yet. Be the first!',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                ),
              );
            }
            return Column(
              children: snap.data!
                  .take(5)
                  .map((r) => _ReviewTile(review: r))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  void _showWriteReview(BuildContext context) {
    double _rating = 4;
    final textCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Write a Review', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 20),
              Center(
                child: RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  itemCount: 5,
                  itemSize: 36,
                  itemBuilder: (_, __) => const Icon(
                    Icons.star_rounded,
                    color: AppColors.starYellow,
                  ),
                  onRatingUpdate: (r) => setModalState(() => _rating = r),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: textCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Share your experience with this product...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (textCtrl.text.trim().isEmpty) return;
                  final user = context.read<AuthProvider>().user;
                  if (user == null) return;
                  final review = ReviewModel(
                    id: '',
                    productId: productId,
                    userId: user.id,
                    userName: user.name,
                    userPhotoUrl: user.photoUrl,
                    rating: _rating,
                    comment: textCtrl.text.trim(),
                    createdAt: DateTime.now(),
                  );
                  await ProductRepository().submitReview(review);
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Submit Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ReviewModel review;

  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.chipBackground,
                  child: Text(
                    review.userName.isNotEmpty
                        ? review.userName[0].toUpperCase()
                        : 'U',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.userName, style: AppTextStyles.titleLarge),
                      Text(
                        Formatters.relativeTime(review.createdAt),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                RatingBarIndicator(
                  rating: review.rating,
                  itemBuilder: (_, __) => const Icon(
                    Icons.star_rounded,
                    color: AppColors.starYellow,
                  ),
                  itemCount: 5,
                  itemSize: 14,
                ),
              ],
            ),
            if (review.comment.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                review.comment,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: 10),
            const Divider(),
          ],
        ),
      );
}
