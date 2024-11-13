import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/add_project_dialog.dart';
import '../widgets/project_list_item.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String? selectedPriority;
  String? selectedStatus;
  List<bool> checkedProjects = List.generate(5, (_) => false);
  bool showArchived = false;
  bool showAllProjects = true;
  bool isListView = true;
  int? hoveredIndex;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  // Sample projects data
  List<Map<String, dynamic>> projects = [
    {
      'name': 'School Management System',
      'description': 'A comprehensive system for managing school operations',
      'startDate': '15 Sep, 2024',
      'dueDate': '15 Oct, 2024',
      'tasks': 5,
      'priority': 'high',
      'status': 'in progress',
    },
    {
      'name': 'E-commerce Platform',
      'description': 'Online shopping platform with modern features',
      'startDate': '1 Oct, 2024',
      'dueDate': '30 Nov, 2024',
      'tasks': 8,
      'priority': 'medium',
      'status': 'not started',
    },
    {
      'name': 'Mobile Banking App',
      'description': 'Secure and user-friendly banking application',
      'startDate': '20 Sep, 2024',
      'dueDate': '20 Dec, 2024',
      'tasks': 12,
      'priority': 'high',
      'status': 'on hold',
    },
    {
      'name': 'Social Media Dashboard',
      'description': 'Analytics and management dashboard for social media',
      'startDate': '5 Oct, 2024',
      'dueDate': '5 Nov, 2024',
      'tasks': 6,
      'priority': 'low',
      'status': 'completed',
    },
  ];

  void _handleEdit(int index) {
    // TODO: Implement edit functionality
  }

  void _handleDelete(int index) {
    setState(() {
      projects.removeAt(index);
      checkedProjects = List.generate(projects.length, (_) => false);
    });
  }

  bool _filterProject(int index) {
    if (searchQuery.isNotEmpty) {
      String projectName = projects[index]['name'].toLowerCase();
      if (!projectName.contains(searchQuery.toLowerCase())) return false;
    }

    if (selectedPriority != null && selectedPriority != 'all') {
      if (projects[index]['priority'] != selectedPriority) return false;
    }

    if (selectedStatus != null && selectedStatus != 'all') {
      if (projects[index]['status'] != selectedStatus) return false;
    }

    if (!showAllProjects && !showArchived) return false;
    if (showArchived && !checkedProjects[index]) return false;

    return true;
  }

  void _toggleAllProjects(bool? value) {
    setState(() {
      checkedProjects = List.generate(projects.length, (_) => value ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          // Header section
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Projects',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      FilledButton.icon(
                        onPressed: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (context) => const AddProjectDialog(),
                          );

                          if (result != null) {
                            setState(() {
                              projects.add(result);
                              checkedProjects =
                                  List.generate(projects.length, (_) => false);
                            });
                          }
                        },
                        icon: Icon(PhosphorIcons.plus(PhosphorIconsStyle.bold),
                            size: 18),
                        label: const Text('Add Project'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Filter bar
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterButton(
                          'All Projects',
                          PhosphorIcons.folder(PhosphorIconsStyle.bold),
                          showAllProjects,
                          () => setState(() {
                            showAllProjects = true;
                            showArchived = false;
                          }),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterButton(
                          'Archived',
                          PhosphorIcons.archive(PhosphorIconsStyle.bold),
                          showArchived,
                          () => setState(() {
                            showArchived = true;
                            showAllProjects = false;
                          }),
                        ),
                        const SizedBox(width: 16),
                        _buildPriorityFilter(),
                        const SizedBox(width: 16),
                        _buildSearchBar(),
                        const SizedBox(width: 16),
                        _buildViewToggle(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Checkbox(
                            value: checkedProjects.every((checked) => checked),
                            onChanged: _toggleAllProjects,
                            tristate: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Project Name',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Start Date',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Due Date',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Tasks',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Priority',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Status',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        const SizedBox(
                          width: 100,
                          child: Text(
                            'Actions',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Project List
                  Expanded(
                    child: ListView.builder(
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        if (!_filterProject(index))
                          return const SizedBox.shrink();
                        return ProjectListItem(
                          project: projects[index],
                          isChecked: checkedProjects[index],
                          onCheckChanged: (value) {
                            setState(() {
                              checkedProjects[index] = value ?? false;
                            });
                          },
                          onEdit: () => _handleEdit(index),
                          onDelete: () => _handleDelete(index),
                          isHovered: hoveredIndex == index,
                        );
                      },
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

  Widget _buildFilterButton(
      String label, IconData icon, bool isActive, VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.accent.withOpacity(0.1)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? AppColors.accent : Colors.transparent,
          width: 1,
        ),
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 18,
          color: isActive ? AppColors.accent : null,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.accent : null,
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityFilter() {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedPriority != null
                ? AppColors.accent
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(PhosphorIcons.funnel(PhosphorIconsStyle.bold), size: 18),
            const SizedBox(width: 8),
            Text(selectedPriority?.capitalize() ?? 'All Priority'),
            const SizedBox(width: 8),
            Icon(PhosphorIcons.caretDown(PhosphorIconsStyle.bold), size: 18),
          ],
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'all',
          child: Text('All Priority'),
        ),
        const PopupMenuDivider(),
        ...['high', 'medium', 'low'].map(
          (priority) => PopupMenuItem(
            value: priority,
            child: Text(priority.capitalize()),
          ),
        ),
      ],
      onSelected: (value) {
        setState(() {
          selectedPriority = value == 'all' ? null : value;
        });
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: 240,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.transparent,
          width: 1,
        ),
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search projects...',
          prefixIcon: Icon(
              PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
              size: 18),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon:
                      Icon(PhosphorIcons.x(PhosphorIconsStyle.bold), size: 16),
                  onPressed: () {
                    setState(() {
                      searchQuery = '';
                      searchController.clear();
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildViewToggleButton(
            icon: PhosphorIcons.list(PhosphorIconsStyle.bold),
            isActive: isListView,
            onPressed: () => setState(() => isListView = true),
          ),
          _buildViewToggleButton(
            icon: PhosphorIcons.squaresFour(PhosphorIconsStyle.bold),
            isActive: !isListView,
            onPressed: () => setState(() => isListView = false),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggleButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color:
            isActive ? AppColors.accent.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 18,
          color: isActive ? AppColors.accent : null,
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
