import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../data/models/order_model.dart';
import '../data/models/product_model.dart';
import '../data/models/user_model.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/order_provider.dart';
import '../providers/product_provider.dart';
import '../ui/auth/splash_screen.dart';
import '../ui/auth/onboarding_screen.dart';
import '../ui/auth/login_screen.dart';
import '../ui/auth/register_screen.dart';
import '../ui/auth/forgot_password_screen.dart';
import '../ui/shared/bottom_nav.dart';
import '../ui/product/product_detail_screen.dart';
import '../ui/checkout/address_picker_screen.dart';
import '../ui/checkout/time_slot_screen.dart';
import '../ui/checkout/payment_screen.dart';
import '../ui/checkout/order_confirmation_screen.dart';
import '../ui/tracking/order_tracking_screen.dart';
import '../ui/orders/order_detail_screen.dart';
import '../ui/profile/edit_profile_screen.dart';
import '../ui/profile/notification_screen.dart';
import 'routes.dart';

class FreshBasketApp extends StatelessWidget {
  const FreshBasketApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ],
        child: MaterialApp(
          title: 'FreshBasket',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: _generateRoute,
        ),
      );

  static Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _fade(const SplashScreen());

      case AppRoutes.onboarding:
        return _slide(const OnboardingScreen());

      case AppRoutes.login:
        return _fade(const LoginScreen());

      case AppRoutes.register:
        return _slide(const RegisterScreen());

      case AppRoutes.forgotPassword:
        return _slide(const ForgotPasswordScreen());

      case AppRoutes.home:
        return _fade(const MainNavShell());

      case AppRoutes.productDetail:
        final product = settings.arguments as ProductModel;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        );

      case AppRoutes.addressPicker:
        return _slide(const AddressPickerScreen());

      case AppRoutes.timeSlot:
        final address = settings.arguments as UserAddress;
        return _slide(TimeSlotScreen(address: address));

      case AppRoutes.payment:
        final args = settings.arguments as Map<String, dynamic>;
        return _slide(PaymentScreen(
          address: args['address'] as UserAddress,
          timeSlot: args['timeSlot'] as String,
        ));

      case AppRoutes.orderConfirmation:
        final order = settings.arguments as OrderModel;
        return _slide(OrderConfirmationScreen(order: order));

      case AppRoutes.orderTracking:
        final orderId = settings.arguments as String;
        return _slide(OrderTrackingScreen(orderId: orderId));

      case AppRoutes.orderDetail:
        final order = settings.arguments as OrderModel;
        return _slide(OrderDetailScreen(order: order));

      case AppRoutes.editProfile:
        return _slide(const EditProfileScreen());

      case AppRoutes.notifications:
        return _slide(const NotificationScreen());

      default:
        return _fade(const SplashScreen());
    }
  }

  static PageRouteBuilder _fade(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      );

  static PageRouteBuilder _slide(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      );
}
