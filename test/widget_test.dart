import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:school_task_manager/core/providers/theme_provider.dart';
import 'package:school_task_manager/features/school/providers/exam_provider.dart';
import 'package:school_task_manager/main.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    // Initialize providers before testing
    final themeProvider = ThemeProvider();
    final examProvider = ExamProvider();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(create: (_) => themeProvider),
            ChangeNotifierProvider<ExamProvider>(create: (_) => examProvider),
          ],
          child: const SchoolTaskManager(),
        ),
      ),
    );

    // Wait for any animations to complete
    await tester.pumpAndSettle();

    // Verify basic widgets are present
    expect(find.byType(MaterialApp), findsOneWidget);

    // Add more specific widget checks
    // expect(find.byType(YourHomeScreen), findsOneWidget);
  });
}
