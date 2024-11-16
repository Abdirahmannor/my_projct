import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../lib/core/base/base_utils.dart';

void main() {
  group('BaseUtils Tests', () {
    group('Date Formatting', () {
      test('should format date correctly', () {
        final date = DateTime(2024, 3, 15);
        expect(BaseUtils.formatDate(date), '15 Mar, 2024');
      });

      test('should format compact date correctly', () {
        final date = DateTime(2024, 3, 15);
        expect(BaseUtils.formatCompactDate(date), '15 Mar');
      });
    });

    group('Time Formatting', () {
      test('should format time with padding', () {
        final time = DateTime(2024, 3, 15, 9, 5);
        expect(BaseUtils.formatTime(time), '09:05');
      });

      test('should format time correctly for PM', () {
        final time = DateTime(2024, 3, 15, 15, 30);
        expect(BaseUtils.formatTime(time), '15:30');
      });
    });

    group('Due Date Calculations', () {
      test('should show overdue status', () {
        final dueDate = DateTime.now().subtract(const Duration(days: 2));
        expect(BaseUtils.getDueStatus(dueDate), '2d overdue');
      });

      test('should show due today status', () {
        final dueDate = DateTime.now();
        expect(BaseUtils.getDueStatus(dueDate), 'Due today');
      });

      test('should show remaining days', () {
        final dueDate = DateTime.now().add(const Duration(days: 3));
        expect(BaseUtils.getDueStatus(dueDate), '3d remaining');
      });
    });

    group('Color Utilities', () {
      test('should get correct status color', () {
        expect(BaseUtils.getStatusColor('not started'), Colors.grey.shade400);
        expect(BaseUtils.getStatusColor('in progress'), Colors.blue.shade400);
        expect(BaseUtils.getStatusColor('completed'), Colors.green.shade400);
        expect(BaseUtils.getStatusColor('on hold'), Colors.orange.shade400);
      });

      test('should get correct priority color', () {
        expect(BaseUtils.getPriorityColor('critical'), Colors.red.shade600);
        expect(BaseUtils.getPriorityColor('high'), Colors.red.shade400);
        expect(BaseUtils.getPriorityColor('medium'), Colors.orange.shade400);
        expect(BaseUtils.getPriorityColor('low'), Colors.green.shade400);
      });

      test('should handle unknown status/priority', () {
        expect(BaseUtils.getStatusColor('unknown'), Colors.grey);
        expect(BaseUtils.getPriorityColor('unknown'), Colors.grey);
      });
    });

    group('String Utilities', () {
      test('should capitalize text correctly', () {
        expect(BaseUtils.capitalize('hello'), 'Hello');
        expect(BaseUtils.capitalize('WORLD'), 'WORLD');
        expect(BaseUtils.capitalize(''), '');
      });
    });

    group('Progress Calculations', () {
      test('should calculate progress correctly', () {
        expect(BaseUtils.calculateProgress(5, 10), 0.5);
        expect(BaseUtils.calculateProgress(0, 5), 0.0);
        expect(BaseUtils.calculateProgress(3, 3), 1.0);
      });

      test('should handle zero total', () {
        expect(BaseUtils.calculateProgress(0, 0), 0.0);
      });
    });
  });
}
