import 'package:flutter/material.dart';
import '../../shared/widgets/sidebar/collapsible_sidebar.dart';
import '../../shared/widgets/custom_window_bar.dart';
import '../dashboard/screens/dashboard_screen.dart';
import '../school/screens/school_screen.dart';
import '../projects/screens/project_screen.dart';
import '../tasks/screens/task_screen.dart';
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

  // For now, we'll use a dummy project ID for tasks
  // Later this should be handled properly based on selected project
  final String _dummyProjectId = 'all_tasks';

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const DashboardScreen(),
      const SchoolScreen(),
      const ProjectScreen(),
      TaskScreen(projectId: _dummyProjectId), // Pass the project ID
      const CalendarScreen(),
      const ResourcesScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomWindowBar(),
          Expanded(
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
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 8,
                      right: 8,
                      bottom: 8,
                      left: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _screens[_selectedIndex],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
