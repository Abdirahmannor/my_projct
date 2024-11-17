import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../constants/app_colors.dart';

class BaseValidators {
  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  // Description validation
  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters';
    }
    return null;
  }

  // Date validation
  static String? validateDates(DateTime? startDate, DateTime? dueDate) {
    if (startDate == null) {
      return 'Start date is required';
    }
    if (dueDate == null) {
      return 'Due date is required';
    }
    if (dueDate.isBefore(startDate)) {
      return 'Due date cannot be before start date';
    }
    return null;
  }

  // Tasks validation
  static String? validateTasks(int tasks) {
    if (tasks <= 0) {
      return 'At least one task is required';
    }
    return null;
  }

  // Show error dialog
  static Future<void> showErrorDialog({
    required BuildContext context,
    required String message,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              PhosphorIcons.warning(PhosphorIconsStyle.fill),
              color: Colors.red.shade400,
              size: 24,
            ),
            const SizedBox(width: 12),
            const Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: AppColors.accent),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
        actionsPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
