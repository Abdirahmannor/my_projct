import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../constants/app_colors.dart';
import 'base_item.dart';

class BaseDialogHelper {
  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
    String? confirmText,
    String? cancelText,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              cancelText ?? 'Cancel',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: iconColor,
            ),
            child: Text(confirmText ?? 'Confirm'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static void showSuccessMessage({
    required BuildContext context,
    required String message,
    required IconData icon,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: backgroundColor ?? AppColors.accent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                PhosphorIcons.warning(PhosphorIconsStyle.fill),
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
