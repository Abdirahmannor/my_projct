import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class BaseStyles {
  // Colors
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'not started':
        return Colors.grey.shade400;
      case 'in progress':
        return Colors.blue.shade400;
      case 'on hold':
        return Colors.orange.shade400;
      case 'completed':
        return Colors.green.shade400;
      default:
        return Colors.grey;
    }
  }

  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return Colors.red.shade600;
      case 'high':
        return Colors.red.shade400;
      case 'medium':
        return Colors.orange.shade400;
      case 'low':
        return Colors.green.shade400;
      default:
        return Colors.grey;
    }
  }

  // Text Styles
  static TextStyle getTitleStyle(BuildContext context,
      {bool isHovered = false}) {
    return Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isHovered ? AppColors.accent : null,
            ) ??
        const TextStyle();
  }

  static TextStyle getSubtitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor,
            ) ??
        const TextStyle();
  }

  // Decorations
  static BoxDecoration getItemDecoration(
    BuildContext context, {
    bool isHovered = false,
    bool isSelected = false,
  }) {
    return BoxDecoration(
      color: isHovered
          ? Theme.of(context).hoverColor
          : isSelected
              ? AppColors.accent.withOpacity(0.1)
              : Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: isSelected ? AppColors.accent : Theme.of(context).dividerColor,
        width: 1,
      ),
      boxShadow: isHovered
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    );
  }

  static BoxDecoration getHeaderDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      border: Border(
        bottom: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
    );
  }

  // Progress Indicators
  static Widget buildProgressIndicator(
    BuildContext context,
    double value, {
    Color? color,
    double size = 40,
  }) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: CircularProgressIndicator(
        value: value,
        backgroundColor: Theme.of(context).dividerColor.withOpacity(0.2),
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.accent.withOpacity(0.9),
        ),
        strokeWidth: 4,
      ),
    );
  }
}
