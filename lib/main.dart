import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'core/providers/theme_provider.dart';
import 'features/shell/shell_screen.dart';
import 'dart:io';
import 'core/constants/app_theme.dart';
import 'features/projects/providers/project_provider.dart';
import 'features/tasks/providers/task_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    doWhenWindowReady(() {
      const initialSize = Size(1200, 700);
      appWindow.minSize = const Size(1012, 604);
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final provider = ProjectProvider();
            provider.addSampleProjects();
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = TaskProvider();
            provider.addSampleTasks();
            return provider;
          },
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: context.watch<ThemeProvider>().themeMode,
      home: const ShellScreen(),
    );
  }
}
