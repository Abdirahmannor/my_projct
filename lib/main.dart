import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import 'core/providers/theme_provider.dart';
import 'features/shell/shell_screen.dart';
import 'core/constants/app_theme.dart';
import 'features/projects/models/project.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register the generated adapter
  Hive.registerAdapter(ProjectAdapter());

  // Open Hive boxes
  await Hive.openBox<Project>('projects');
  await Hive.openBox<Project>('deleted_projects');

  // Initialize window manager for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1200, 700),
      minimumSize: Size(1012, 604),
      center: true,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const SchoolTaskManager(),
    ),
  );
}

class SchoolTaskManager extends StatelessWidget {
  const SchoolTaskManager({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      themeMode: context.watch<ThemeProvider>().themeMode,
      home: const ErrorBoundary(
        child: ShellScreen(),
      ),
    );
  }
}

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
