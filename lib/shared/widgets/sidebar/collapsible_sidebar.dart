import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';
import 'sidebar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/theme_provider.dart';

class CollapsibleSidebar extends StatefulWidget {
  final bool isCollapsed;
  final Function(bool) onToggle;
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CollapsibleSidebar({
    super.key,
    this.isCollapsed = false,
    required this.onToggle,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<CollapsibleSidebar> createState() => _CollapsibleSidebarState();
}

class _CollapsibleSidebarState extends State<CollapsibleSidebar> {
  final List<SidebarItem> items = [
    SidebarItem(
      icon: PhosphorIcons.houseLine(PhosphorIconsStyle.bold),
      label: 'Dashboard',
    ),
    SidebarItem(
      icon: PhosphorIcons.graduationCap(PhosphorIconsStyle.bold),
      label: 'School/Work',
    ),
    SidebarItem(
      icon: PhosphorIcons.briefcase(PhosphorIconsStyle.bold),
      label: 'Projects',
    ),
    SidebarItem(
      icon: PhosphorIcons.checkSquare(PhosphorIconsStyle.bold),
      label: 'Tasks',
    ),
    SidebarItem(
      icon: PhosphorIcons.calendar(PhosphorIconsStyle.bold),
      label: 'Calendar',
    ),
    SidebarItem(
      icon: PhosphorIcons.folder(PhosphorIconsStyle.bold),
      label: 'Resources',
    ),
    SidebarItem(
      icon: PhosphorIcons.gear(PhosphorIconsStyle.bold),
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isCollapsed ? 65 : 250,
      child: Row(
        children: [
          // Left section (icons)
          Container(
            width: 65,
            color: const Color(0xFF1B2559),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Profile icon
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  child:
                      Icon(PhosphorIcons.user(), color: Colors.blue, size: 20),
                ),
                const SizedBox(height: 24),
                // Menu icon
                Icon(PhosphorIcons.listDashes(), color: Colors.white, size: 24),
                const SizedBox(height: 24),
                // Menu items icons
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = widget.selectedIndex == index;
                      return Container(
                        color: isSelected
                            ? const Color(0xFF4318FF)
                            : Colors.transparent,
                        child: IconButton(
                          onPressed: () => widget.onItemSelected(index),
                          icon: Icon(
                            item.icon,
                            color: isSelected ? Colors.white : Colors.white70,
                            size: 22,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Bottom icons
                IconButton(
                  onPressed: () =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(),
                  icon: Icon(PhosphorIcons.moon(),
                      color: Colors.white70, size: 22),
                ),
                IconButton(
                  onPressed: () => _showLogoutDialog(context),
                  icon: Icon(PhosphorIcons.signOut(),
                      color: Colors.red[400], size: 22),
                ),
                IconButton(
                  onPressed: () => widget.onToggle(!widget.isCollapsed),
                  icon: Icon(
                    widget.isCollapsed
                        ? PhosphorIcons.arrowRight()
                        : PhosphorIcons.arrowLeft(),
                    color: Colors.white70,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Right section (labels)
          if (!widget.isCollapsed)
            Expanded(
              child: Container(
                color: const Color(0xFF2B3674),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Profile text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('John Doe',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          Text('Student',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Menu text
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Menu',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 24),
                    // Menu items text
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final isSelected = widget.selectedIndex == index;
                          return Container(
                            color: isSelected
                                ? const Color(0xFF4318FF)
                                : Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Text(
                              item.label,
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.white : Colors.white70,
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Bottom section
                    _buildExpandedBottomSection(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExpandedBottomSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dark Mode toggle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Text('Dark Mode',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              const Spacer(),
              CupertinoSwitch(
                value: Provider.of<ThemeProvider>(context).themeMode ==
                    ThemeMode.dark,
                onChanged: (_) =>
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme(),
                activeColor: Colors.blue,
              ),
            ],
          ),
        ),
        // Logout button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text('Logout',
              style: TextStyle(color: Colors.red[400], fontSize: 14)),
        ),
        // Collapse button
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text('Collapse',
              style: TextStyle(color: Colors.white70, fontSize: 14)),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    // Implement logout dialog functionality
  }
}
