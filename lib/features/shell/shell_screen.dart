import 'package:flutter/material.dart';
import '../dashboard/screens/dashboard_screen.dart';
import '../projects/screens/projects_screen.dart';
import '../../shared/widgets/sidebar/collapsible_sidebar.dart';
import '../../shared/widgets/window/window_title_bar.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _selectedIndex = 0;
  bool _isSidebarCollapsed = false;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const Center(child: Text('School/Work')),
    const ProjectsScreen(),
    const Center(child: Text('Tasks')),
    const Center(child: Text('Calendar')),
    const Center(child: Text('Resources')),
    const Center(child: Text('Settings')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const WindowTitleBar(),
          Expanded(
            child: Row(
              children: [
                CollapsibleSidebar(
                  isCollapsed: _isSidebarCollapsed,
                  onToggle: (isCollapsed) {
                    setState(() {
                      _isSidebarCollapsed = isCollapsed;
                    });
                  },
                  selectedIndex: _selectedIndex,
                  onItemSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
                Expanded(
                  child: _screens[_selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
