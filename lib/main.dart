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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(ProjectAdapter());

  await Hive.openBox<Project>('projects');
  await Hive.openBox<Project>('deleted_projects');

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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: context.watch<ThemeProvider>().themeMode,
      home: const ShellScreen(),
    );
  }
}
