import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:school_task_manager/core/providers/theme_provider.dart';
import 'package:school_task_manager/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App should build without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          // Add other providers as needed
        ],
        child: const SchoolTaskManager(),
      ),
    );

    // Wait for animations to complete
    await tester.pumpAndSettle();

    // Verify that the app builds without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
