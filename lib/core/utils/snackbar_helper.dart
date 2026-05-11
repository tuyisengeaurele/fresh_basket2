import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class SnackbarHelper {
  SnackbarHelper._();

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, AppColors.freshGreen, Icons.check_circle_outline_rounded);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, AppColors.error, Icons.error_outline_rounded);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message, AppColors.primary, Icons.info_outline_rounded);
  }

  static void showWarning(BuildContext context, String message) {
    _show(context, message, AppColors.secondary, Icons.warning_amber_rounded);
  }

  static void _show(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
