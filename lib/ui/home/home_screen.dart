import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/product_provider.dart';
import '../../app/routes.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/category_tabs.dart';
import 'widgets/product_grid.dart';
import 'widgets/product_card.dart';
import 'widgets/search_bar_widget.dart';
import '../shared/empty_state_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().initialize();
    });
  }

  Future<void> _refresh() async {
    context.read<ProductProvider>().initialize();
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final products = context.watch<ProductProvider>();
    final notifCount = context.watch<NotificationProvider>().unreadCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _refresh,
          child: CustomScrollView(
            slivers: [
              // App bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      // Logo + greeting
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FreshBasket',
                              style: AppTextStyles.headlineLarge.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            if (user != null)
                              Text(
                                'Hello, ${user.name.split(' ').first}!',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Notification bell
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            color: AppColors.textPrimary,
                            onPressed: () => Navigator.pushNamed(
                                context, AppRoutes.notifications),
                          ),
                          if (notifCount > 0)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: const BoxDecoration(
                                  color: AppColors.secondary,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  notifCount > 9 ? '9+' : '$notifCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Location pill
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Kigali, Rwanda',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),

              // Search
              const SliverToBoxAdapter(child: SearchBarWidget()),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // Banners
              const SliverToBoxAdapter(child: BannerCarousel()),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Categories
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Shop by Category', style: AppTextStyles.headlineSmall),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: CategoryTabs()),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Featured products — horizontal scroll
              if (products.featured.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Text(
                      'Featured Products',
                      style: AppTextStyles.headlineSmall,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 230,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemCount: products.featured.length,
                      itemBuilder: (_, i) => SizedBox(
                        width: 160,
                        child: ProductCard(product: products.featured[i]),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],

              // Best Sellers
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text('Best Sellers', style: AppTextStyles.headlineSmall),
                ),
              ),

              // Products grid
              SliverToBoxAdapter(
                child: products.isLoading
                    ? ProductGrid(products: const [], isLoading: true)
                    : products.all.isEmpty
                        ? EmptyStateWidget(
                            icon: Icons.eco_outlined,
                            title: 'No Products Found',
                            subtitle: 'Try a different category or refresh.',
                            actionLabel: 'Refresh',
                            onAction: _refresh,
                          )
                        : ProductGrid(products: products.all),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
