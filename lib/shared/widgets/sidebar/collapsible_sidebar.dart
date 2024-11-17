import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';
import 'sidebar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/theme_provider.dart';

const Duration _animationDuration = Duration(milliseconds: 200);

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
  late final List<SidebarItem> items = [
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
    final isDarkMode = context.select((ThemeProvider p) => p.isDarkMode);

    return AnimatedContainer(
      duration: _animationDuration,
      width: widget.isCollapsed ? 65 : 240,
      color: isDarkMode ? const Color(0xFF1F2937) : const Color(0xFF1B2559),
      child: Row(
        children: [
          _buildLeftSection(isDarkMode),
          if (!widget.isCollapsed) _buildRightSection(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildLeftSection(bool isDarkMode) {
    return SizedBox(
      width: 65,
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildProfileIcon(),
          const SizedBox(height: 24),
          _buildCollapseArrow(),
          const SizedBox(height: 24),
          Expanded(
            child: _buildMenuItems(true, isDarkMode),
          ),
          _buildBottomIcons(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildRightSection(bool isDarkMode) {
    return Expanded(
      child: Container(
        color: isDarkMode ? const Color(0xFF272935) : const Color(0xFF2B3674),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildProfileInfo(),
            const SizedBox(height: 24),
            _buildCollapseButton(),
            const SizedBox(height: 24),
            Expanded(
              child: _buildMenuItems(false, isDarkMode),
            ),
            _buildBottomButtons(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems(bool isIconSection, bool isDarkMode) {
    return ListView.builder(
      itemCount: items.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final isSelected = widget.selectedIndex == index;
        return _MenuItem(
          item: items[index],
          isSelected: isSelected,
          isIconSection: isIconSection,
          isCollapsed: widget.isCollapsed,
          onTap: () => widget.onItemSelected(index),
        );
      },
    );
  }

  Widget _buildProfileIcon() {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.blue.withOpacity(0.2),
      child: Icon(PhosphorIcons.user(), color: Colors.blue, size: 20),
    );
  }

  Widget _buildCollapseArrow() {
    return InkWell(
      onTap: () => widget.onToggle(!widget.isCollapsed),
      child: Icon(
        widget.isCollapsed
            ? PhosphorIcons.arrowRight()
            : PhosphorIcons.arrowLeft(),
        color: Colors.white70,
        size: 22,
      ),
    );
  }

  Widget _buildBottomIcons(bool isDarkMode) {
    return Column(
      children: [
        IconButton(
          onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          icon: Icon(
            isDarkMode ? PhosphorIcons.moon() : PhosphorIcons.sun(),
            color: Colors.white70,
            size: 22,
          ),
        ),
        IconButton(
          onPressed: () => _showLogoutDialog(context),
          icon: Icon(
            PhosphorIcons.signOut(),
            color: Colors.red[400],
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
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
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapseButton() {
    return InkWell(
      onTap: () => widget.onToggle(!widget.isCollapsed),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Collapse',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(bool isDarkMode) {
    return Column(
      children: [
        // Dark mode toggle
        InkWell(
          onTap: () => context.read<ThemeProvider>().toggleTheme(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(
                  isDarkMode ? 'Dark Mode' : 'Light Mode',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const Spacer(),
                CupertinoSwitch(
                  value: isDarkMode,
                  onChanged: (_) => context.read<ThemeProvider>().toggleTheme(),
                  activeColor: Colors.blue,
                ),
              ],
            ),
          ),
        ),
        // Logout button
        InkWell(
          onTap: () => _showLogoutDialog(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(
                  'Logout',
                  style: TextStyle(color: Colors.red[400], fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
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
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement actual logout logic
                Navigator.of(context).pop();
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red[400]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.item,
    required this.isSelected,
    required this.isIconSection,
    required this.isCollapsed,
    required this.onTap,
  });

  final SidebarItem item;
  final bool isSelected;
  final bool isIconSection;
  final bool isCollapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 45,
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9)
                : Colors.transparent,
            borderRadius: BorderRadius.horizontal(
              right: isCollapsed || !isIconSection
                  ? const Radius.circular(10)
                  : Radius.zero,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isIconSection ? 0 : 16,
          ),
          alignment: isIconSection ? Alignment.center : Alignment.centerLeft,
          child: isIconSection
              ? Icon(
                  item.icon,
                  color: isSelected ? Colors.white : Colors.white70,
                  size: 22,
                )
              : Text(
                  item.label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
        ),
      ),
    );
  }
}
