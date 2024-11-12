import 'package:flutter/material.dart';
import '../../shared/widgets/sidebar/collapsible_sidebar.dart';
import '../dashboard/screens/dashboard_screen.dart';
import '../school/screens/school_screen.dart';
import '../projects/screens/projects_screen.dart';
import '../tasks/screens/tasks_screen.dart';
import '../calendar/screens/calendar_screen.dart';
import '../resources/screens/resources_screen.dart';
import '../settings/screens/settings_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  bool _isCollapsed = false;
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    SchoolScreen(),
    ProjectsScreen(),
    TasksScreen(),
    CalendarScreen(),
    ResourcesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints(
          minWidth: 1200,
          minHeight: 800,
        ),
        color: const Color(0xFF1A1B1E),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CollapsibleSidebar(
                isCollapsed: _isCollapsed,
                onToggle: (isCollapsed) {
                  setState(() {
                    _isCollapsed = isCollapsed;
                  });
                },
                selectedIndex: _selectedIndex,
                onItemSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1F23),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _screens[_selectedIndex],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
