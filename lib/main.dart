import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/constants/app_theme.dart';
import 'features/shell/shell_screen.dart';
import 'features/school/providers/exam_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ExamProvider()),
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
      title: 'School Task Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: context.watch<ThemeProvider>().themeMode,
      home: const ShellScreen(),
    );
  }
}
