import 'package:flutter/material.dart';

class BaseUtils {
  // Date formatting
  static String formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  static String formatCompactDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  // Time formatting
  static String formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Due date calculations
  static String getDueStatus(DateTime dueDate) {
    final now = DateTime.now();
    final daysRemaining = dueDate.difference(now).inDays;

    if (daysRemaining < 0) {
      return '${daysRemaining.abs()}d overdue';
    } else if (daysRemaining == 0) {
      return 'Due today';
    } else {
      return '${daysRemaining}d remaining';
    }
  }

  // Color utilities
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

  // String utilities
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  // Progress calculations
  static double calculateProgress(int completed, int total) {
    if (total == 0) return 0.0;
    return completed / total;
  }
}
