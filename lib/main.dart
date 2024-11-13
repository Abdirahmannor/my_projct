import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'core/providers/theme_provider.dart';
import 'features/shell/shell_screen.dart';
import 'features/school/providers/exam_provider.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1200, 700),
      minimumSize: Size(1012, 604),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      title: '',
      titleBarStyle: TitleBarStyle.normal,
      windowButtonVisibility: true,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setTitle('');
      await windowManager.setResizable(true);
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
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFF1B2559),
        cardColor: const Color(0xFF2B3674),
        primaryColor: const Color(0xFF3B4CB8),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1E2D),
        cardColor: const Color(0xFF2B2B40),
        primaryColor: const Color(0xFF282839),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Color(0xFFF3F4F6),
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(
            color: Color(0xFFD1D5DB),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      themeMode: context.watch<ThemeProvider>().themeMode,
      home: const ShellScreen(),
    );
  }
}
