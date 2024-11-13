import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/add_project_dialog.dart';
import '../widgets/project_list_item.dart';
import '../../../core/utils/string_extensions.dart';
import '../widgets/project_grid_item.dart';

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
      'completedTasks': 3,
      'priority': 'high',
      'status': 'in progress',
    },
    {
      'name': 'E-commerce Platform',
      'description': 'Online shopping platform with modern features',
      'startDate': '1 Oct, 2024',
      'dueDate': '30 Nov, 2024',
      'tasks': 8,
      'completedTasks': 5,
      'priority': 'medium',
      'status': 'not started',
    },
    {
      'name': 'Mobile Banking App',
      'description': 'Secure and user-friendly banking application',
      'startDate': '20 Sep, 2024',
      'dueDate': '20 Dec, 2024',
      'tasks': 12,
      'completedTasks': 7,
      'priority': 'high',
      'status': 'on hold',
    },
    {
      'name': 'Social Media Dashboard',
      'description': 'Analytics and management dashboard for social media',
      'startDate': '5 Oct, 2024',
      'dueDate': '5 Nov, 2024',
      'tasks': 6,
      'completedTasks': 4,
      'priority': 'low',
      'status': 'completed',
    },
  ];

  // Add this map to store original status
  final Map<int, String> originalStatuses = {};

  void _handleEdit(int index) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AddProjectDialog(
        isEditing: true,
        project: projects[index],
      ),
    );

    if (result != null) {
      setState(() {
        projects[index] = result;
      });

      _showSuccessMessage(
        message: 'Project "${result['name']}" has been updated successfully',
        icon: PhosphorIcons.pencilSimple(PhosphorIconsStyle.fill),
      );
    }
  }

  void _handleDelete(int index) {
    final projectName = projects[index]['name'];
    setState(() {
      projects.removeAt(index);
      checkedProjects = List.generate(projects.length, (_) => false);
    });

    _showSuccessMessage(
      message: 'Project "$projectName" has been deleted successfully',
      icon: PhosphorIcons.trash(PhosphorIconsStyle.fill),
    );
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
      for (int i = 0; i < projects.length; i++) {
        if (value == true) {
          // Store original status and set to completed
          originalStatuses[i] = projects[i]['status'];
          projects[i]['status'] = 'completed';
          projects[i]['completedTasks'] = projects[i]['tasks'];
        } else {
          // Restore original status
          projects[i]['status'] = originalStatuses[i] ?? 'in progress';
          // Restore original completedTasks count
          projects[i]['completedTasks'] =
              (projects[i]['tasks'] * 0.6).round(); // Example: restore to 60%
        }
      }
    });
  }

  void _handleCheckboxChange(int index, bool? value) {
    setState(() {
      checkedProjects[index] = value ?? false;
      if (value == true) {
        // Store original status and set to completed
        originalStatuses[index] = projects[index]['status'];
        projects[index]['status'] = 'completed';
        projects[index]['completedTasks'] = projects[index]['tasks'];
      } else {
        // Restore original status
        projects[index]['status'] = originalStatuses[index] ?? 'in progress';
        // You might want to restore the original completedTasks count as well
        // This is optional, depending on your requirements
        projects[index]['completedTasks'] =
            (projects[index]['tasks'] * 0.6).round(); // Example: restore to 60%
      }
    });
  }

  void _showSuccessMessage({
    required String message,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green.shade600,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 4),
        content: Row(
          children: [
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
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
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.accent,
                              Color.lerp(
                                      AppColors.accent, Colors.purple, 0.6) ??
                                  AppColors.accent,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              final result = await showDialog(
                                context: context,
                                builder: (context) => const AddProjectDialog(),
                              );

                              if (result != null) {
                                setState(() {
                                  projects.add(result);
                                  checkedProjects = List.generate(
                                      projects.length, (_) => false);
                                });

                                _showSuccessMessage(
                                  message:
                                      'Project "${result['name']}" has been created successfully',
                                  icon: PhosphorIcons.folderPlus(
                                      PhosphorIconsStyle.fill),
                                );
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      PhosphorIcons.plus(
                                          PhosphorIconsStyle.bold),
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Add Project',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Filter bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left side - All Projects and Archived
                      Row(
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
                        ],
                      ),

                      // Right side controls
                      Row(
                        children: [
                          // Search
                          Container(
                            width: 240,
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  PhosphorIcons.magnifyingGlass(
                                      PhosphorIconsStyle.bold),
                                  size: 18,
                                  color: Theme.of(context).hintColor,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: searchController,
                                    onChanged: (value) {
                                      setState(() {
                                        searchQuery = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Search projects...',
                                      border: InputBorder.none,
                                      isDense: true,
                                      hintStyle: TextStyle(
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ),
                                ),
                                if (searchQuery.isNotEmpty)
                                  IconButton(
                                    icon: Icon(
                                      PhosphorIcons.x(PhosphorIconsStyle.bold),
                                      size: 18,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        searchQuery = '';
                                        searchController.clear();
                                      });
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Priority Filter
                          Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: PopupMenuButton<String>(
                              offset: const Offset(0, 40),
                              child: Row(
                                children: [
                                  Icon(
                                    PhosphorIcons.funnel(
                                        PhosphorIconsStyle.bold),
                                    size: 18,
                                    color: selectedPriority != null
                                        ? AppColors.accent
                                        : null,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    selectedPriority?.capitalize() ??
                                        'All Priority',
                                    style: TextStyle(
                                      color: selectedPriority != null
                                          ? AppColors.accent
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    PhosphorIcons.caretDown(
                                        PhosphorIconsStyle.bold),
                                    size: 18,
                                    color: selectedPriority != null
                                        ? AppColors.accent
                                        : null,
                                  ),
                                ],
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
                                  selectedPriority =
                                      value == 'all' ? null : value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          // View Toggle
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                _buildViewToggleButton(
                                  icon: PhosphorIcons.list(
                                      PhosphorIconsStyle.bold),
                                  isActive: isListView,
                                  onPressed: () =>
                                      setState(() => isListView = true),
                                ),
                                Container(
                                  width: 1,
                                  height: 20,
                                  color: Theme.of(context).dividerColor,
                                ),
                                _buildViewToggleButton(
                                  icon: PhosphorIcons.squaresFour(
                                      PhosphorIconsStyle.bold),
                                  isActive: !isListView,
                                  onPressed: () =>
                                      setState(() => isListView = false),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Content section
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Table Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
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
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
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
                  const Divider(height: 1),
                  // Project List
                  Expanded(
                    child: !isListView
                        ? GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: projects.length,
                            itemBuilder: (context, index) {
                              if (!_filterProject(index))
                                return const SizedBox.shrink();
                              return MouseRegion(
                                onEnter: (_) =>
                                    setState(() => hoveredIndex = index),
                                onExit: (_) =>
                                    setState(() => hoveredIndex = null),
                                child: ProjectGridItem(
                                  project: projects[index],
                                  isChecked: checkedProjects[index],
                                  onCheckChanged: (value) =>
                                      _handleCheckboxChange(index, value),
                                  onEdit: () => _handleEdit(index),
                                  onDelete: () => _handleDelete(index),
                                  isHovered: hoveredIndex == index,
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: projects.length,
                            itemBuilder: (context, index) {
                              if (!_filterProject(index))
                                return const SizedBox.shrink();
                              return MouseRegion(
                                onEnter: (_) =>
                                    setState(() => hoveredIndex = index),
                                onExit: (_) =>
                                    setState(() => hoveredIndex = null),
                                child: ProjectListItem(
                                  project: projects[index],
                                  isChecked: checkedProjects[index],
                                  onCheckChanged: (value) =>
                                      _handleCheckboxChange(index, value),
                                  onEdit: () => _handleEdit(index),
                                  onDelete: () => _handleDelete(index),
                                  isHovered: hoveredIndex == index,
                                ),
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
