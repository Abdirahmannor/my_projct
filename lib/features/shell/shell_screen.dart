import 'package:flutter/material.dart';
import '../../shared/widgets/sidebar/collapsible_sidebar.dart';
import '../dashboard/screens/dashboard_screen.dart';
import '../school/screens/school_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  bool _isCollapsed = false;
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const SchoolScreen(),
    const Center(child: Text('Projects Coming Soon')),
    const Center(child: Text('Tasks Coming Soon')),
    const Center(child: Text('Calendar Coming Soon')),
    const Center(child: Text('Resources Coming Soon')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          CollapsibleSidebar(
            isCollapsed: _isCollapsed,
            onToggle: (value) => setState(() => _isCollapsed = value),
            selectedIndex: _selectedIndex,
            onItemSelected: (index) => setState(() => _selectedIndex = index),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: _screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
