import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';
import 'sidebar_item.dart';
import 'package:flutter/cupertino.dart';

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
      curve: Curves.easeInOutCubic,
      width: widget.isCollapsed ? 65 : 250,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildProfileSection(),
          _buildHeader(),
          const Divider(color: Colors.white24),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: List.generate(
                  items.length,
                  (index) => _buildMenuItem(index),
                ),
              ),
            ),
          ),
          const Divider(color: Colors.white24),
          _buildThemeToggle(),
          _buildLogoutButton(),
          const Divider(color: Colors.white24),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: widget.isCollapsed ? 16 : 24,
            backgroundColor: Colors.blue.withOpacity(0.2),
            child: Icon(
              PhosphorIcons.user(PhosphorIconsStyle.bold),
              color: Colors.blue,
              size: widget.isCollapsed ? 20 : 28,
            ),
          ),
          if (!widget.isCollapsed) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Student',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
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

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic,
        margin: EdgeInsets.symmetric(
          horizontal: widget.isCollapsed ? 4 : 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isSelected && !widget.isCollapsed
              ? Border.all(color: Colors.white.withOpacity(0.3), width: 1)
              : null,
        ),
        child: Tooltip(
          message: widget.isCollapsed ? item.label : '',
          preferBelow: false,
          verticalOffset: 12,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => widget.onItemSelected(index),
              child: Container(
                height: 45,
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isCollapsed ? 12 : 16,
                ),
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.7),
                      size: isSelected ? 24 : 22,
                    ),
                    if (!widget.isCollapsed) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          item.label,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.7),
                            fontSize: 15,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                    if (widget.isCollapsed && isSelected)
                      Container(
                        width: 3,
                        height: 3,
                        margin: const EdgeInsets.only(left: 6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: widget.isCollapsed
            ? () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
                // TODO: Connect to theme provider
              }
            : null,
        child: Row(
          mainAxisAlignment: widget.isCollapsed
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Icon(
              isDarkMode
                  ? PhosphorIcons.moon(PhosphorIconsStyle.bold)
                  : PhosphorIcons.sun(PhosphorIconsStyle.bold),
              color: Colors.white,
              size: 24,
            ),
            if (!widget.isCollapsed) ...[
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  isDarkMode ? 'Dark Mode' : 'Light Mode',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              CupertinoSwitch(
                value: isDarkMode,
                activeColor: Colors.blue,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                  // TODO: Connect to theme provider
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => _showLogoutDialog(context),
        child: Row(
          children: [
            Icon(
              PhosphorIcons.signOut(PhosphorIconsStyle.bold),
              color: Colors.red.withOpacity(0.9),
              size: 24,
            ),
            if (!widget.isCollapsed) ...[
              const SizedBox(width: 16),
              const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF272935),
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
                // Navigate to login screen or clear session
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
