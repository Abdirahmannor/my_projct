import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../../lib/core/base/base_dialog.dart';

// Create a mock implementation of BaseDialog
class MockDialog extends BaseDialog {
  const MockDialog({super.key, super.isEditing});

  @override
  MockDialogState createState() => MockDialogState();
}

class MockDialogState extends BaseDialogState<MockDialog> {
  final textController = TextEditingController();

  @override
  Widget buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: textController,
          decoration: const InputDecoration(labelText: 'Name'),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Name is required' : null,
        ),
      ],
    );
  }

  @override
  Future<void> handleSubmit() async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.pop(context, textController.text);
    }
  }

  @override
  String get dialogTitle => widget.isEditing ? 'Edit Item' : 'Add Item';

  @override
  String get submitButtonText => widget.isEditing ? 'Update' : 'Add';

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}

void main() {
  group('BaseDialog Tests', () {
    testWidgets('should render dialog with correct title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MockDialog(),
          ),
        ),
      );

      expect(find.text('Add Item'), findsOneWidget);
      expect(find.text('Edit Item'), findsNothing);
    });

    testWidgets('should show edit mode when isEditing is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MockDialog(isEditing: true),
          ),
        ),
      );

      expect(find.text('Edit Item'), findsOneWidget);
      expect(find.text('Update'), findsOneWidget);
    });

    testWidgets('should validate form before submission', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MockDialog(),
          ),
        ),
      );

      // Try to submit empty form
      await tester.tap(find.text('Add'));
      await tester.pump();

      expect(find.text('Name is required'), findsOneWidget);
    });

    testWidgets('should show loading indicator during submission',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MockDialog(),
          ),
        ),
      );

      // Fill form
      await tester.enterText(find.byType(TextFormField), 'Test Item');
      await tester.pump();

      // Submit form
      await tester.tap(find.text('Add'));
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for submission to complete
      await tester.pumpAndSettle();
    });

    testWidgets('should close dialog on successful submission', (tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: const Scaffold(
            body: MockDialog(),
          ),
        ),
      );

      // Fill form
      await tester.enterText(find.byType(TextFormField), 'Test Item');
      await tester.pump();

      // Submit form
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Dialog should be closed
      expect(find.byType(MockDialog), findsNothing);
    });

    testWidgets('should close dialog on cancel', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MockDialog(),
          ),
        ),
      );

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(MockDialog), findsNothing);
    });
  });
}
