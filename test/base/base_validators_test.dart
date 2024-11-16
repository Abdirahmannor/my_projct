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

      test('should reject whitespace only name', () {
        expect(BaseValidators.validateName('   '), 'Name is required');
      });

      test('should reject too short name', () {
        expect(BaseValidators.validateName('ab'),
            'Name must be at least 3 characters');
      });

      test('should accept valid name', () {
        expect(BaseValidators.validateName('Valid Name'), isNull);
        expect(BaseValidators.validateName('Bob'), isNull);
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
        expect(
          BaseValidators.validateDescription('Too short'),
          'Description must be at least 10 characters',
        );
      });

      test('should accept valid description', () {
        expect(
          BaseValidators.validateDescription('This is a valid description'),
          isNull,
        );
      });
    });

    group('Date Validation', () {
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(days: 1));
      final yesterday = now.subtract(const Duration(days: 1));

      test('should reject null dates', () {
        expect(BaseValidators.validateDates(null, tomorrow),
            'Start date is required');
        expect(BaseValidators.validateDates(now, null), 'Due date is required');
      });

      test('should reject due date before start date', () {
        expect(
          BaseValidators.validateDates(now, yesterday),
          'Due date cannot be before start date',
        );
      });

      test('should accept valid date range', () {
        expect(BaseValidators.validateDates(now, tomorrow), isNull);
        expect(BaseValidators.validateDates(now, now),
            isNull); // Same day should be valid
      });
    });

    group('Tasks Validation', () {
      test('should reject zero or negative tasks', () {
        expect(
            BaseValidators.validateTasks(0), 'At least one task is required');
        expect(
            BaseValidators.validateTasks(-1), 'At least one task is required');
      });

      test('should accept positive number of tasks', () {
        expect(BaseValidators.validateTasks(1), isNull);
        expect(BaseValidators.validateTasks(10), isNull);
      });
    });

    group('Error Dialog', () {
      testWidgets('should show error dialog with correct content',
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

      testWidgets('should close dialog on OK press', (tester) async {
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

      testWidgets('should handle multiple error dialogs', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Column(
                children: [
                  TextButton(
                    onPressed: () => BaseValidators.showErrorDialog(
                      context: context,
                      message: 'Error 1',
                    ),
                    child: const Text('Show Error 1'),
                  ),
                  TextButton(
                    onPressed: () => BaseValidators.showErrorDialog(
                      context: context,
                      message: 'Error 2',
                    ),
                    child: const Text('Show Error 2'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Show first error
        await tester.tap(find.text('Show Error 1'));
        await tester.pumpAndSettle();
        expect(find.text('Error 1'), findsOneWidget);

        // Close first error
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // Show second error
        await tester.tap(find.text('Show Error 2'));
        await tester.pumpAndSettle();
        expect(find.text('Error 2'), findsOneWidget);
      });
    });
  });
}
