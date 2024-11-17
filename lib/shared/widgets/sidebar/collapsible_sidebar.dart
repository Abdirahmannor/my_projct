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
  bool isDarkMode = true;

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
      width: widget.isCollapsed ? 70 : 250,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          const Divider(color: Colors.white24),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => _buildMenuItem(index),
            ),
          ),
          const Divider(color: Colors.white24),
          _buildThemeToggle(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            PhosphorIcons.listDashes(PhosphorIconsStyle.bold),
            color: Colors.white,
            size: widget.isCollapsed ? 24 : 28,
          ),
          if (!widget.isCollapsed) ...[
            const SizedBox(width: 16),
            const Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItem(int index) {
    final item = items[index];
    final isSelected = widget.selectedIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.onItemSelected(index),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color:
                isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                color: Colors.white,
                size: 24,
              ),
              if (!widget.isCollapsed) ...[
                const SizedBox(width: 16),
                Text(
                  item.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () => widget.onToggle(!widget.isCollapsed),
        child: Row(
          children: [
            Icon(
              widget.isCollapsed
                  ? PhosphorIcons.arrowRight(PhosphorIconsStyle.bold)
                  : PhosphorIcons.arrowLeft(PhosphorIconsStyle.bold),
              color: Colors.white,
              size: 24,
            ),
            if (!widget.isCollapsed) ...[
              const SizedBox(width: 16),
              const Text(
                'Collapse',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(
                PhosphorIcons.moon(PhosphorIconsStyle.bold),
                color: Colors.white,
                size: 24,
              ),
              if (!widget.isCollapsed) ...[
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Dark Mode',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                CupertinoSwitch(
                  value: themeProvider.isDarkMode,
                  activeColor: Colors.blue,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
