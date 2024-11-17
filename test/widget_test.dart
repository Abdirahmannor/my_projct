import 'package:flutter_test/flutter_test.dart';
import 'package:school_task_manager/main.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  setUpAll(() async {
    await Hive.initFlutter();
  });

  testWidgets('App should build without errors', (WidgetTester tester) async {
    // Initialize Hive and register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(DateTimeAdapter());
    }

    // Build our app and trigger a frame
    await tester.pumpWidget(const SchoolTaskManager());

    // Verify that the app builds without errors
    expect(find.byType(SchoolTaskManager), findsOneWidget);
  });

  tearDownAll(() async {
    await Hive.close();
  });
}
