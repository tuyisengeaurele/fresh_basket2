import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _current = 0;

  static const _banners = [
    _BannerData(
      title: 'Farm-to-Table\nFreshness',
      subtitle: 'Straight from local farms to your door',
      imageUrl: 'https://source.unsplash.com/800x400/?vegetables,farm',
      tag: 'Shop Now',
    ),
    _BannerData(
      title: 'Organic\nSelection',
      subtitle: 'Certified organic produce, zero pesticides',
      imageUrl: 'https://source.unsplash.com/800x400/?organic,fruits',
      tag: '20% Off',
    ),
    _BannerData(
      title: 'Seasonal\nSpecials',
      subtitle: "This week's best picks from Rwanda's farms",
      imageUrl: 'https://source.unsplash.com/800x400/?seasonal,produce',
      tag: 'Limited Time',
    ),
  ];

  @override
  Widget build(BuildContext context) => Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 170,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayCurve: Curves.easeInOutCubic,
              viewportFraction: 0.92,
              enlargeCenterPage: true,
              enlargeFactor: 0.05,
              onPageChanged: (i, _) => setState(() => _current = i),
            ),
            items: _banners
                .map((b) => _BannerCard(banner: b))
                .toList(),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _banners.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _current == i ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _current == i
                      ? AppColors.primary
                      : AppColors.divider,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      );
}

class _BannerData {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String tag;

  const _BannerData({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.tag,
  });
}

class _BannerCard extends StatelessWidget {
  final _BannerData banner;

  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: banner.imageUrl,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) =>
                  Container(color: AppColors.chipBackground),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.82),
                    AppColors.primaryLight.withOpacity(0.4),
                    Colors.transparent,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      banner.tag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    banner.title,
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    banner.subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
