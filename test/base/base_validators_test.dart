import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../lib/core/base/base_validators.dart';

void main() {
  group('BaseValidators Tests', () {
    group('Name Validation', () {
      test('should reject null name', () {
        expect(BaseValidators.validateName(null), 'Name is required');
      });

      test('should reject empty name', () {
        expect(BaseValidators.validateName(''), 'Name is required');
      });

      test('should reject name with only spaces', () {
        expect(BaseValidators.validateName('   '), 'Name is required');
      });

      test('should reject too short name', () {
        expect(BaseValidators.validateName('ab'),
            'Name must be at least 3 characters');
      });

      test('should accept valid name', () {
        expect(BaseValidators.validateName('Valid Name'), null);
      });
    });

    group('Description Validation', () {
      test('should reject null description', () {
        expect(BaseValidators.validateDescription(null),
            'Description is required');
      });

      test('should reject empty description', () {
        expect(
            BaseValidators.validateDescription(''), 'Description is required');
      });

      test('should reject too short description', () {
        expect(BaseValidators.validateDescription('Short'),
            'Description must be at least 10 characters');
      });

      test('should accept valid description', () {
        expect(
            BaseValidators.validateDescription('This is a valid description'),
            null);
      });
    });

    group('Date Validation', () {
      test('should reject null start date', () {
        expect(BaseValidators.validateDates(null, DateTime.now()),
            'Start date is required');
      });

      test('should reject null due date', () {
        expect(BaseValidators.validateDates(DateTime.now(), null),
            'Due date is required');
      });

      test('should reject due date before start date', () {
        final now = DateTime.now();
        final yesterday = now.subtract(const Duration(days: 1));

        expect(BaseValidators.validateDates(now, yesterday),
            'Due date cannot be before start date');
      });

      test('should accept valid date range', () {
        final now = DateTime.now();
        final tomorrow = now.add(const Duration(days: 1));

        expect(BaseValidators.validateDates(now, tomorrow), null);
      });
    });

    group('Tasks Validation', () {
      test('should reject zero tasks', () {
        expect(
            BaseValidators.validateTasks(0), 'At least one task is required');
      });

      test('should reject negative tasks', () {
        expect(
            BaseValidators.validateTasks(-1), 'At least one task is required');
      });

      test('should accept positive number of tasks', () {
        expect(BaseValidators.validateTasks(1), null);
      });
    });

    group('Error Dialog', () {
      testWidgets('should show error dialog with correct message',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => TextButton(
                onPressed: () => BaseValidators.showErrorDialog(
                  context: context,
                  message: 'Test error message',
                ),
                child: const Text('Show Error'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Error'));
        await tester.pumpAndSettle();

        expect(find.text('Error'), findsOneWidget);
        expect(find.text('Test error message'), findsOneWidget);
        expect(find.text('OK'), findsOneWidget);
      });

      testWidgets('should close error dialog on OK', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => TextButton(
                onPressed: () => BaseValidators.showErrorDialog(
                  context: context,
                  message: 'Test error message',
                ),
                child: const Text('Show Error'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Error'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        expect(find.text('Error'), findsNothing);
        expect(find.text('Test error message'), findsNothing);
      });
    });
  });
}
