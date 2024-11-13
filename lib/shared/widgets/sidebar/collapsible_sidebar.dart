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
            color:
                Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
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
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => widget.onItemSelected(index),
                            child: Container(
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xFF4318FF),
                                          Color(0xFF4928FF),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      )
                                    : null,
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF4318FF)
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Icon(
                                item.icon,
                                color:
                                    isSelected ? Colors.white : Colors.white70,
                                size: 22,
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
                      ? (Provider.of<ThemeProvider>(context).themeMode ==
                              ThemeMode.dark
                          ? 'Light Mode'
                          : 'Dark Mode')
                      : '',
                  preferBelow: false,
                  verticalOffset: 12,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () =>
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleTheme(),
                      child: Container(
                        height: 45,
                        alignment: Alignment.center,
                        child: Icon(
                          Provider.of<ThemeProvider>(context).themeMode ==
                                  ThemeMode.dark
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

          // Subtle divider between sections
          if (!widget.isCollapsed)
            Container(
              width: 1,
              color: Colors.white.withOpacity(0.1),
            ),

          // Right section (labels)
          if (!widget.isCollapsed)
            Expanded(
              child: Container(
                color: Provider.of<ThemeProvider>(context).themeMode ==
                        ThemeMode.dark
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
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.onItemSelected(index),
                              child: Container(
                                height: 45,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFF4318FF),
                                            Color(0xFF4928FF),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        )
                                      : null,
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF4318FF)
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
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
                          );
                        },
                      ),
                    ),
                    // Bottom section with InkWell
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () =>
                            Provider.of<ThemeProvider>(context, listen: false)
                                .toggleTheme(),
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Text(
                                Provider.of<ThemeProvider>(context).themeMode ==
                                        ThemeMode.dark
                                    ? 'Dark Mode'
                                    : 'Light Mode',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              const Spacer(),
                              CupertinoSwitch(
                                value: Provider.of<ThemeProvider>(context)
                                        .themeMode ==
                                    ThemeMode.dark,
                                onChanged: (_) => Provider.of<ThemeProvider>(
                                        context,
                                        listen: false)
                                    .toggleTheme(),
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
    // Implement logout dialog functionality
  }
}
