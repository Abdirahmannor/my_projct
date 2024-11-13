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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: widget.isCollapsed ? 65 : 240,
      decoration: BoxDecoration(
        color: context.watch<ThemeProvider>().isDarkMode
            ? const Color(0xFF1F2937)
            : const Color(0xFF1B2559),
      ),
      child: Row(
        children: [
          // Left section (icons)
          Container(
            width: 65,
            color: context.watch<ThemeProvider>().isDarkMode
                ? const Color(0xFF1F2937)
                : const Color(0xFF1B2559),
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
                // Collapse arrow icon
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => widget.onToggle(!widget.isCollapsed),
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      child: Icon(
                        widget.isCollapsed
                            ? PhosphorIcons.arrowRight()
                            : PhosphorIcons.arrowLeft(),
                        color: Colors.white70,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Menu items icons
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = widget.selectedIndex == index;
                      return Tooltip(
                        message: widget.isCollapsed ? item.label : '',
                        preferBelow: false,
                        verticalOffset: 12,
                        child: Container(
                          height: 45,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.onItemSelected(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .withOpacity(0.9)
                                      : Colors.transparent,
                                  borderRadius: widget.isCollapsed
                                      ? const BorderRadius.horizontal(
                                          right: Radius.circular(10))
                                      : BorderRadius.zero,
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  item.icon,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white70,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Bottom icons with InkWell
                Tooltip(
                  message: widget.isCollapsed
                      ? (context.watch<ThemeProvider>().isDarkMode
                          ? 'Light Mode'
                          : 'Dark Mode')
                      : '',
                  preferBelow: false,
                  verticalOffset: 12,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => context.read<ThemeProvider>().toggleTheme(),
                      child: Container(
                        height: 45,
                        alignment: Alignment.center,
                        child: Icon(
                          context.watch<ThemeProvider>().isDarkMode
                              ? PhosphorIcons.moon()
                              : PhosphorIcons.sun(),
                          color: Colors.white70,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
                Tooltip(
                  message: widget.isCollapsed ? 'Logout' : '',
                  preferBelow: false,
                  verticalOffset: 12,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showLogoutDialog(context),
                      child: Container(
                        height: 45,
                        alignment: Alignment.center,
                        child: Icon(PhosphorIcons.signOut(),
                            color: Colors.red[400], size: 22),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right section (labels)
          if (!widget.isCollapsed)
            Expanded(
              child: Container(
                color: context.watch<ThemeProvider>().isDarkMode
                    ? const Color(0xFF272935)
                    : const Color(0xFF2B3674),
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
                    // Collapse arrow text and icon
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => widget.onToggle(!widget.isCollapsed),
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Collapse',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ),
                      ),
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
                            height: 45,
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => widget.onItemSelected(index),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Theme.of(context)
                                            .scaffoldBackgroundColor
                                            .withOpacity(0.9)
                                        : Colors.transparent,
                                    borderRadius: const BorderRadius.horizontal(
                                        right: Radius.circular(10)),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item.label,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.white70,
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Bottom section with InkWell
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () =>
                            context.read<ThemeProvider>().toggleTheme(),
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Text(
                                context.watch<ThemeProvider>().isDarkMode
                                    ? 'Dark Mode'
                                    : 'Light Mode',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              const Spacer(),
                              CupertinoSwitch(
                                value:
                                    context.watch<ThemeProvider>().isDarkMode,
                                onChanged: (_) =>
                                    context.read<ThemeProvider>().toggleTheme(),
                                activeColor: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showLogoutDialog(context),
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.centerLeft,
                          child: Text('Logout',
                              style: TextStyle(
                                  color: Colors.red[400], fontSize: 14)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Confirm Logout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement actual logout logic
                Navigator.of(context).pop();
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red[400],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
