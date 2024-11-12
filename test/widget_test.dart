import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:school_task_manager/core/providers/theme_provider.dart';
import 'package:school_task_manager/features/school/providers/exam_provider.dart';
import 'package:school_task_manager/main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize FFI
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  setUpAll(() {
    // Set up the database factory
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('App should build without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => ExamProvider()),
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
