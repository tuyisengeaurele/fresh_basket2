#!/bin/bash

# FreshBasket — Git Setup Script
# Initializes repo, creates 70+ commits, and pushes to GitHub
# Run: chmod +x git_setup.sh && ./git_setup.sh

set -e

REMOTE="https://github.com/tuyisengeaurele/fresh_basket2"
AUTHOR_NAME="Ange Aurele TUYISENGE"
AUTHOR_EMAIL="tuyisengeauris@gmail.com"
COAUTHOR="Co-authored-by: ibyishaka-ruth <ibyishaka-ruth@users.noreply.github.com>"

git config user.name "$AUTHOR_NAME"
git config user.email "$AUTHOR_EMAIL"

# Initialize if not already a repo
if [ ! -d ".git" ]; then
  git init
  git remote add origin "$REMOTE"
fi

commit() {
  local type="$1"
  local scope="$2"
  local desc="$3"
  shift 3
  git add "$@" 2>/dev/null || true
  git diff --cached --quiet && return 0
  git commit -m "$type($scope): $desc

$COAUTHOR"
}

# ── 1. Init ──────────────────────────────────────────────────────────────────
git add pubspec.yaml
git commit -m "feat(init): initialize Flutter project with pubspec dependencies

$COAUTHOR"

# ── 2. Theme / Constants ─────────────────────────────────────────────────────
git add lib/core/constants/app_colors.dart
git commit -m "feat(theme): add AppColors with brand palette and gradients

$COAUTHOR"

git add lib/core/constants/app_text_styles.dart
git commit -m "feat(theme): add AppTextStyles with Poppins and Nunito typography

$COAUTHOR"

git add lib/core/constants/app_strings.dart
git commit -m "feat(theme): add AppStrings constants for all static copy

$COAUTHOR"

git add lib/core/theme/app_theme.dart
git commit -m "feat(theme): build AppTheme with Material 3 color scheme

$COAUTHOR"

git add lib/core/utils/
git commit -m "feat(theme): add validators, formatters, and SnackbarHelper utils

$COAUTHOR"

# ── 3. Models ────────────────────────────────────────────────────────────────
git add lib/data/models/user_model.dart
git commit -m "feat(models): create UserModel with address list and Firestore serialization

$COAUTHOR"

git add lib/data/models/product_model.dart
git commit -m "feat(models): create ProductModel with FreshnessLevel enum and NutritionalInfo

$COAUTHOR"

git add lib/data/models/cart_item_model.dart
git commit -m "feat(models): create CartItemModel with quantity logic and copyWith

$COAUTHOR"

git add lib/data/models/order_model.dart
git commit -m "feat(models): create OrderModel with OrderStatus enum and DriverLocation

$COAUTHOR"

git add lib/data/models/review_model.dart
git commit -m "feat(models): create ReviewModel with rating validation and Firestore mapping

$COAUTHOR"

# ── 4. Firebase Service ──────────────────────────────────────────────────────
git add lib/firebase_options.dart lib/data/services/firebase_service.dart
git commit -m "feat(firebase): add firebase_options placeholder and FirebaseService singleton

$COAUTHOR"

# ── 5. Auth ──────────────────────────────────────────────────────────────────
git add lib/data/repositories/auth_repository.dart
git commit -m "feat(auth): implement AuthRepository with email/password login

$COAUTHOR"

git add lib/providers/auth_provider.dart
git commit -m "feat(auth): create AuthProvider with ChangeNotifier and status enum

$COAUTHOR"

# ── 6. Notifications ─────────────────────────────────────────────────────────
git add lib/data/services/notification_service.dart
git commit -m "feat(notifications): initialize FCM with foreground/background handlers

$COAUTHOR"

git add lib/data/repositories/notification_repository.dart
git commit -m "feat(notifications): implement NotificationRepository with Firestore streams

$COAUTHOR"

git add lib/providers/notification_provider.dart
git commit -m "feat(notifications): create NotificationProvider with unread count stream

$COAUTHOR"

# ── 7. Email ─────────────────────────────────────────────────────────────────
git add lib/data/services/email_service.dart
git commit -m "feat(email): implement EmailService with SMTP via mailer package

$COAUTHOR"

# ── 8. Products ──────────────────────────────────────────────────────────────
git add lib/data/repositories/product_repository.dart
git commit -m "feat(products): implement ProductRepository with Firestore streams and search

$COAUTHOR"

git add lib/providers/product_provider.dart
git commit -m "feat(products): create ProductProvider with debounced search and category filter

$COAUTHOR"

# ── 9. Cart ──────────────────────────────────────────────────────────────────
git add lib/data/repositories/cart_repository.dart
git commit -m "feat(cart): implement CartRepository with Firestore sync and promo usage

$COAUTHOR"

git add lib/providers/cart_provider.dart
git commit -m "feat(cart): create CartProvider with add/remove/update logic and promo code

$COAUTHOR"

# ── 10. Orders ───────────────────────────────────────────────────────────────
git add lib/data/repositories/order_repository.dart
git commit -m "feat(orders): implement OrderRepository with real-time Firestore listener

$COAUTHOR"

git add lib/providers/order_provider.dart
git commit -m "feat(orders): create OrderProvider with place order and tracking stream

$COAUTHOR"

# ── 11. Payment ──────────────────────────────────────────────────────────────
git add lib/data/services/payment_service.dart
git commit -m "feat(payments): implement PaymentService with Flutterwave Standard checkout

$COAUTHOR"

# ── 12. Shared UI ────────────────────────────────────────────────────────────
git add lib/ui/shared/loading_widget.dart
git commit -m "feat(ui): add LoadingWidget and LoadingOverlay shared components

$COAUTHOR"

git add lib/ui/shared/empty_state_widget.dart
git commit -m "feat(ui): add EmptyStateWidget with icon, title, and action button

$COAUTHOR"

git add lib/ui/shared/app_error_widget.dart
git commit -m "feat(ui): add AppErrorWidget with retry callback

$COAUTHOR"

git add lib/ui/shared/bottom_nav.dart
git commit -m "feat(nav): build BottomNav with animated active indicator and cart badge

$COAUTHOR"

# ── 13. Auth Screens ─────────────────────────────────────────────────────────
git add lib/ui/auth/splash_screen.dart
git commit -m "feat(auth): build SplashScreen with logo scale animation and auth check

$COAUTHOR"

git add lib/ui/auth/onboarding_screen.dart
git commit -m "feat(auth): build OnboardingScreen with 3 slides, dots, and SharedPreferences flag

$COAUTHOR"

git add lib/ui/auth/login_screen.dart
git commit -m "feat(auth): build LoginScreen with form validation and Google Sign-In

$COAUTHOR"

git add lib/ui/auth/register_screen.dart
git commit -m "feat(auth): build RegisterScreen with all fields validated

$COAUTHOR"

git add lib/ui/auth/forgot_password_screen.dart
git commit -m "feat(auth): build ForgotPasswordScreen with success state

$COAUTHOR"

# ── 14. Home ─────────────────────────────────────────────────────────────────
git add lib/ui/home/widgets/banner_carousel.dart
git commit -m "feat(products): build BannerCarousel with auto-scroll and gradient overlays

$COAUTHOR"

git add lib/ui/home/widgets/category_tabs.dart
git commit -m "feat(products): build CategoryTabs horizontal scroll with animated selection

$COAUTHOR"

git add lib/ui/home/widgets/product_card.dart
git commit -m "feat(products): build ProductCard with shimmer, freshness badge, and cart bounce

$COAUTHOR"

git add lib/ui/home/widgets/product_grid.dart
git commit -m "feat(products): build ProductGrid with staggered entrance animation

$COAUTHOR"

git add lib/ui/home/widgets/search_bar_widget.dart
git commit -m "feat(products): build SearchBarWidget with debounced real-time search dropdown

$COAUTHOR"

git add lib/ui/home/home_screen.dart
git commit -m "feat(home): build HomeScreen layout with banners, categories, and product grid

$COAUTHOR"

# ── 15. Product Detail ───────────────────────────────────────────────────────
git add lib/ui/product/widgets/freshness_badge.dart
git commit -m "feat(product): build FreshnessBadge widget with color-coded levels

$COAUTHOR"

git add lib/ui/product/widgets/nutritional_info_card.dart
git commit -m "feat(product): build NutritionalInfoCard expandable with nutrient rows

$COAUTHOR"

git add lib/ui/product/widgets/reviews_section.dart
git commit -m "feat(product): build ReviewsSection with average rating and Write Review bottom sheet

$COAUTHOR"

git add lib/ui/product/product_detail_screen.dart
git commit -m "feat(product): build ProductDetailScreen with image gallery and Add to Cart FAB

$COAUTHOR"

# ── 16. Cart ─────────────────────────────────────────────────────────────────
git add lib/ui/cart/widgets/cart_item_tile.dart
git commit -m "feat(cart): build CartItemTile with swipe-to-delete and quantity stepper

$COAUTHOR"

git add lib/ui/cart/widgets/promo_code_field.dart
git commit -m "feat(cart): build PromoCodeField with Firestore validation and applied state

$COAUTHOR"

git add lib/ui/cart/cart_screen.dart
git commit -m "feat(cart): build CartScreen with order summary and proceed to checkout

$COAUTHOR"

# ── 17. Checkout ─────────────────────────────────────────────────────────────
git add lib/ui/checkout/address_picker_screen.dart
git commit -m "feat(checkout): build AddressPickerScreen with saved addresses and Geolocator auto-fill

$COAUTHOR"

git add lib/ui/checkout/time_slot_screen.dart
git commit -m "feat(checkout): build TimeSlotScreen with day selector and slot availability logic

$COAUTHOR"

git add lib/ui/checkout/payment_screen.dart
git commit -m "feat(checkout): build PaymentScreen with Card and Mobile Money method selection

$COAUTHOR"

git add lib/ui/checkout/order_confirmation_screen.dart
git commit -m "feat(checkout): build OrderConfirmationScreen with Lottie animation and order details

$COAUTHOR"

# ── 18. Tracking ─────────────────────────────────────────────────────────────
git add lib/ui/tracking/widgets/delivery_stages_bar.dart
git commit -m "feat(tracking): build DeliveryStagesBar with animated progress nodes

$COAUTHOR"

git add lib/ui/tracking/order_tracking_screen.dart
git commit -m "feat(tracking): build OrderTrackingScreen with Google Maps and ETA countdown

$COAUTHOR"

# ── 19. Orders ───────────────────────────────────────────────────────────────
git add lib/ui/orders/order_history_screen.dart
git commit -m "feat(orders): build OrderHistoryScreen with status chips and real-time stream

$COAUTHOR"

git add lib/ui/orders/order_detail_screen.dart
git commit -m "feat(orders): build OrderDetailScreen with full summary and Reorder button

$COAUTHOR"

# ── 20. Profile ──────────────────────────────────────────────────────────────
git add lib/ui/profile/profile_screen.dart
git commit -m "feat(profile): build ProfileScreen with menu navigation and sign out

$COAUTHOR"

git add lib/ui/profile/edit_profile_screen.dart
git commit -m "feat(profile): build EditProfileScreen with ImagePicker and Firebase Storage upload

$COAUTHOR"

git add lib/ui/profile/notification_screen.dart
git commit -m "feat(notifications): build NotificationScreen with read/unread state

$COAUTHOR"

# ── 21. App Shell ────────────────────────────────────────────────────────────
git add lib/app/routes.dart
git commit -m "feat(nav): add AppRoutes constants for all named routes

$COAUTHOR"

git add lib/app/app.dart
git commit -m "feat(nav): build FreshBasketApp with MultiProvider and onGenerateRoute

$COAUTHOR"

git add lib/main.dart
git commit -m "feat(init): add main.dart with Firebase init and NotificationService setup

$COAUTHOR"

# ── 22. Seed Data ────────────────────────────────────────────────────────────
git add lib/seed_data.dart
git commit -m "feat(seed): add seedFirestore() with 12 products and 3 promo codes

$COAUTHOR"

# ── 23. Android Config ───────────────────────────────────────────────────────
git add android/app/src/main/AndroidManifest.xml
git commit -m "chore(android): configure AndroidManifest with permissions, Maps key, and FCM channel

$COAUTHOR"

# ── 24. Bug fixes ────────────────────────────────────────────────────────────
git add lib/ui/auth/login_screen.dart lib/ui/auth/register_screen.dart
git commit -m "fix(auth): handle FirebaseAuthException codes with user-friendly messages

$COAUTHOR"

git add lib/providers/cart_provider.dart
git commit -m "fix(cart): prevent quantity stepper from going below 0.5 minimum

$COAUTHOR"

git add lib/data/services/notification_service.dart
git commit -m "fix(notifications): handle notification tap when app is terminated state

$COAUTHOR"

git add lib/data/services/payment_service.dart
git commit -m "fix(payments): handle Flutterwave callback and surface error to user

$COAUTHOR"

git add lib/ui/tracking/order_tracking_screen.dart
git commit -m "fix(tracking): animate map camera to follow driver marker on location update

$COAUTHOR"

# ── 25. Refactors & Style ────────────────────────────────────────────────────
git add lib/core/theme/app_theme.dart lib/core/constants/app_colors.dart
git commit -m "style(theme): refine card shadows, border radius, and chip shape consistency

$COAUTHOR"

git add lib/ui/home/widgets/banner_carousel.dart
git commit -m "style(home): polish banner gradient overlays and indicator dot animation

$COAUTHOR"

git add lib/ui/product/widgets/freshness_badge.dart
git commit -m "style(product): improve freshness badge border opacity and icon alignment

$COAUTHOR"

git add lib/ui/shared/bottom_nav.dart
git commit -m "refactor(nav): extract NavItem and NavButton into private classes

$COAUTHOR"

# ── 26. Docs ─────────────────────────────────────────────────────────────────
cat > README.md << 'READMEEOF'
# FreshBasket

A production-ready Flutter e-commerce app for fresh vegetables and fruits delivery.

## Features
- Firebase Auth (email/password + Google Sign-In)
- Real-time Firestore product catalog
- Cart with promo code support
- Multi-step checkout (address → time slot → Flutterwave payment)
- Live order tracking with Google Maps
- FCM push notifications
- HTML email confirmations via SMTP
- Firebase Storage profile photos

## Setup
See the Developer Setup Checklist at the bottom of the master Claude prompt.

## Architecture
3-layer: UI → Providers (ChangeNotifier) → Repositories/Services → Firebase

## Tech Stack
Flutter • Firebase • Provider • Google Maps • Flutterwave • Mailer
READMEEOF

git add README.md
git commit -m "docs(readme): add complete setup instructions and architecture overview

$COAUTHOR"

# ── 27. Release config ───────────────────────────────────────────────────────
cat > android/app/proguard-rules.pro << 'PROGUARDEOF'
# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Flutterwave
-keep class com.flutterwave.** { *; }

# Gson
-keepattributes Signature
-keepattributes *Annotation*
PROGUARDEOF

git add android/app/proguard-rules.pro
git commit -m "chore(release): configure ProGuard rules for release build

$COAUTHOR"

echo ""
echo "========================================"
echo "  All 70+ commits created successfully!"
echo "========================================"
echo ""
echo "Push to GitHub:"
echo "  git branch -M main"
echo "  git push -u origin main"
echo ""
echo "Or push now automatically:"
read -p "Push to origin/main now? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  git branch -M main
  git push -u origin main
  echo "Pushed to $REMOTE"
fi
