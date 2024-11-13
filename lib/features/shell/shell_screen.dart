import 'package:flutter/material.dart';
import '../../shared/widgets/sidebar/collapsible_sidebar.dart';
import '../dashboard/screens/dashboard_screen.dart';
import '../school/screens/school_screen.dart';
import '../projects/screens/projects_screen.dart';
import '../tasks/screens/tasks_screen.dart';
import '../calendar/screens/calendar_screen.dart';
import '../resources/screens/resources_screen.dart';
import '../settings/screens/settings_screen.dart';
import '../../shared/widgets/custom_window_bar.dart';

class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key});

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
                  isCollapsed: false,
                  onToggle: (isCollapsed) {
                    // Handle sidebar toggle
                  },
                  selectedIndex: 0,
                  onItemSelected: (index) {
                    // Handle item selection
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
                      child: const DashboardScreen(),
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
