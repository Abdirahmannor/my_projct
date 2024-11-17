import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'core/providers/theme_provider.dart';
import 'features/shell/shell_screen.dart';
import 'features/school/providers/exam_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'core/constants/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/projects/models/project.dart';
import 'features/tasks/models/task.dart';
import 'core/base/base_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter
  try {
    await Hive.initFlutter('hive_data');
    print('Hive initialized successfully');
  } catch (e) {
    print('Error initializing Hive: $e');
  }

  // Register adapters first
  try {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(DateTimeAdapter());
      print('DateTime adapter registered');
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskAdapter());
      print('Task adapter registered');
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ProjectAdapter());
      print('Project adapter registered');
    }
  } catch (e) {
    print('Error registering adapters: $e');
  }

  try {
    // Try to open boxes normally first
    await Hive.openBox<Task>('tasks');
    await Hive.openBox<Task>('deleted_tasks');
    await Hive.openBox<Project>('projects');
    await Hive.openBox<Project>('deleted_projects');
    print('All boxes opened successfully');
  } catch (e) {
    print('Error opening boxes: $e');
    try {
      await Hive.deleteBoxFromDisk('tasks');
      await Hive.deleteBoxFromDisk('deleted_tasks');
      await Hive.deleteBoxFromDisk('projects');
      await Hive.deleteBoxFromDisk('deleted_projects');
      print('Boxes deleted successfully');

      // Reopen boxes after deletion
      await Hive.openBox<Task>('tasks');
      await Hive.openBox<Task>('deleted_tasks');
      await Hive.openBox<Project>('projects');
      await Hive.openBox<Project>('deleted_projects');
      print('Boxes reopened successfully');
    } catch (e) {
      print('Error recreating boxes: $e');
    }
  }

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    doWhenWindowReady(() {
      const initialSize = Size(1200, 700);
      appWindow.minSize = const Size(1012, 604);
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
  }

  // Wrap the app in a try-catch to catch any widget errors
  try {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: Builder(
          builder: (context) {
            // Add error boundary
            return const SchoolTaskManager();
          },
        ),
      ),
    );
  } catch (e) {
    print('Error running app: $e');
  }
}

// Add DateTimeAdapter for Hive
class DateTimeAdapter extends TypeAdapter<DateTime> {
  @override
  final typeId = 0;

  @override
  DateTime read(BinaryReader reader) {
    final timeStr = reader.readString();
    return DateTime.parse(timeStr);
  }

  @override
  void write(BinaryWriter writer, DateTime obj) {
    writer.writeString(obj.toIso8601String());
  }
}

class SchoolTaskManager extends StatelessWidget {
  const SchoolTaskManager({super.key});

  @override
  Widget build(BuildContext context) {
    // Add error boundary
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: context.watch<ThemeProvider>().themeMode,
      home: ErrorBoundary(
        child: const ShellScreen(),
      ),
    );
  }
}

// Fix the ErrorBoundary widget
class ErrorBoundary extends StatelessWidget {
  final Widget child;

  const ErrorBoundary({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Something went wrong!',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 16),
              Text(details.exception.toString()),
            ],
          ),
        ),
      );
    };
    return child;
  }
}
