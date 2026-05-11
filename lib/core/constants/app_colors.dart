import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF003300);
  static const Color secondary = Color(0xFFFF8F00);
  static const Color background = Color(0xFFF9FBF7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFD32F2F);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onBackground = Color(0xFF1A1A1A);
  static const Color onSurface = Color(0xFF1A1A1A);

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFFADB5BD);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color shadow = Color(0x1A000000);

  static const Color freshGreen = Color(0xFF2E7D32);
  static const Color goodAmber = Color(0xFFF9A825);
  static const Color limitedRed = Color(0xFFC62828);

  static const Color starYellow = Color(0xFFFFC107);
  static const Color chipBackground = Color(0xFFEBF5EB);
  static const Color chipSelected = Color(0xFF1B5E20);

  static LinearGradient get primaryGradient => const LinearGradient(
        colors: [primary, primaryLight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get freshnessGradient => const LinearGradient(
        colors: [primaryLight, secondary],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  static LinearGradient get bannerGradient => LinearGradient(
        colors: [primary.withOpacity(0.85), primaryLight.withOpacity(0.6)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
}
