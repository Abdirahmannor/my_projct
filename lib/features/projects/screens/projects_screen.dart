import 'dart:async'; // Add this import for Timer
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/add_project_dialog.dart';
import '../widgets/project_list_item.dart';
import '../../../core/utils/string_extensions.dart';
import '../widgets/project_grid_item.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/project.dart';
import '../services/project_database_service.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String? selectedPriority;
  String? selectedStatus;
  List<bool> checkedProjects = [];
  bool showArchived = false;
  bool showAllProjects = true;
  bool isListView = true;
  int? hoveredIndex;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool _isLoading = false;
  String _selectedTimeframe = 'This Month';
  List<String> _timeframes = [
    'Today',
    'This Week',
    'This Month',
    'This Quarter',
    'This Year',
    'All Time'
  ];
  bool _isStatisticsExpanded = false;
  DateTimeRange? _selectedDateRange;
  bool _showChart = true;
  List<Project> archivedProjects = [];
  List<bool> archivedCheckedProjects = [];
  bool archivedSelectAll = false;
  final _projectDatabaseService = ProjectDatabaseService();
  List<Project> projects = [];
  final Map<int, String> originalStatuses = {};
  String? selectedCategory;
  bool showRecycleBin = false;
  List<Project> deletedProjects = [];
  Timer? _cleanupTimer;
  List<bool> recycleBinCheckedProjects = [];
  bool recycleBinSelectAll = false;
  int _newlyDeletedCount = 0;
  bool _hasVisitedRecycleBin = false;

  @override
  void initState() {
    super.initState();
    _loadProjects();
    _loadDeletedProjects();
    _cleanupTimer = Timer.periodic(const Duration(days: 1), (_) {
      _projectDatabaseService.cleanupOldProjects();
    });
  }

  @override
  void dispose() {
    _cleanupTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadProjects() async {
    try {
      final loadedProjects = await _projectDatabaseService.getAllProjects();
      setState(() {
        projects =
            loadedProjects.where((p) => p.status != 'completed').toList();
        archivedProjects =
            loadedProjects.where((p) => p.status == 'completed').toList();

        // Initialize checkbox lists
        checkedProjects = List.generate(projects.length, (_) => false);
        archivedCheckedProjects =
            List.generate(archivedProjects.length, (_) => false);
        recycleBinCheckedProjects =
            List.generate(deletedProjects.length, (_) => false);

        // Reset select all states
        archivedSelectAll = false;
        recycleBinSelectAll = false;
      });
    } catch (e) {
      print('Error loading projects: $e');
    }
  }

  Future<void> _loadDeletedProjects() async {
    try {
      final loadedProjects = await _projectDatabaseService.getDeletedProjects();
      setState(() {
        deletedProjects = loadedProjects;
        recycleBinCheckedProjects =
            List.generate(loadedProjects.length, (_) => false);
        recycleBinSelectAll = false;
      });
    } catch (e) {
      print('Error loading deleted projects: $e');
    }
  }

  void _handleAddProject() async {
    final result = await showDialog(
      context: context,
      builder: (context) => const AddProjectDialog(),
    );

    if (result != null && result is Project) {
      try {
        // Only save to database, don't add to local state
        await _projectDatabaseService.addProject(result);
        // Reload all projects from database
        await _loadProjects();

        _showSuccessMessage(
          message: 'Project "${result.name}" has been created successfully',
          icon: PhosphorIcons.folderPlus(PhosphorIconsStyle.fill),
        );
      } catch (e) {
        _showError('Failed to save project: $e');
      }
    }
  }

  void _handleEdit(int index) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AddProjectDialog(
        isEditing: true,
        project: projects[index],
      ),
    );

    if (result != null && result is Project) {
      try {
        // Create updated project with the same ID
        final updatedProject = Project(
          id: projects[index].id, // Keep the same ID
          name: result.name,
          description: result.description,
          startDate: result.startDate,
          dueDate: result.dueDate,
          tasks: result.tasks,
          completedTasks: result.completedTasks,
          priority: result.priority,
          status: result.status,
          category: result.category,
        );

        // Save to database
        await _projectDatabaseService.updateProject(updatedProject);

        // Update local state
        setState(() {
          projects[index] = updatedProject;
        });

        _showSuccessMessage(
          message: 'Project "${result.name}" has been updated successfully',
          icon: PhosphorIcons.pencilSimple(PhosphorIconsStyle.fill),
        );
      } catch (e) {
        _showError('Failed to update project: $e');
      }
    }
  }

  void _handleDelete(int index) async {
    final projectName = projects[index].name;
    final projectId = projects[index].id;

    // Show confirmation dialog
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIcons.trash(PhosphorIconsStyle.fill),
              color: Colors.red.shade400,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Move to Recycle Bin',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        content: SizedBox(
          width: 300,
          child: Text(
            'Are you sure you want to move "$projectName" to recycle bin?',
            style: const TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 14,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Move to Recycle Bin',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && projectId != null) {
      try {
        await _projectDatabaseService.moveToRecycleBin(projects[index]);

        setState(() {
          deletedProjects.add(projects[index]);
          projects.removeAt(index);
          checkedProjects = List.generate(projects.length, (_) => false);
          recycleBinCheckedProjects =
              List.generate(deletedProjects.length, (_) => false);
          _newlyDeletedCount++;
          _hasVisitedRecycleBin = false;
        });

        _showSuccessMessage(
          message: 'Project "$projectName" has been moved to recycle bin',
          icon: PhosphorIcons.trash(PhosphorIconsStyle.fill),
        );
      } catch (e) {
        _showError('Failed to move project to recycle bin: $e');
      }
    }
  }

  bool _filterProject(int index) {
    // First check if the index is valid for the current list
    if (showArchived && index >= archivedProjects.length) return false;
    if (showRecycleBin && index >= deletedProjects.length) return false;
    if (!showArchived && !showRecycleBin && index >= projects.length)
      return false;

    // Get the correct project based on current view
    final project = showArchived
        ? archivedProjects[index]
        : showRecycleBin
            ? deletedProjects[index]
            : projects[index];

    // Search filter
    if (searchQuery.isNotEmpty) {
      final String projectName = project.name.toLowerCase();
      final String projectDescription =
          (project.description ?? '').toLowerCase();
      final String query = searchQuery.toLowerCase();
      if (!projectName.contains(query) && !projectDescription.contains(query)) {
        return false;
      }
    }

    // Priority filter
    if (selectedPriority != null && selectedPriority != 'all') {
      if (project.priority != selectedPriority) {
        return false;
      }
    }

    // Status filter
    if (selectedStatus != null && selectedStatus != 'all') {
      if (project.status != selectedStatus) {
        return false;
      }
    }

    // Category filter
    if (selectedCategory != null && selectedCategory != 'all') {
      if (project.category != selectedCategory) {
        return false;
      }
    }

    // Date range filter
    if (_selectedDateRange != null) {
      if (project.startDate.isBefore(_selectedDateRange!.start) ||
          project.dueDate.isAfter(_selectedDateRange!.end)) {
        return false;
      }
    }

    return true;
  }

  void _toggleAllProjects(bool? value) {
    setState(() {
      checkedProjects = List.generate(projects.length, (_) => value ?? false);
      for (int i = 0; i < projects.length; i++) {
        if (value == true) {
          // Store original status and create new project
          originalStatuses[i] = projects[i].status;
          projects[i] = Project(
            id: projects[i].id,
            name: projects[i].name,
            description: projects[i].description,
            startDate: projects[i].startDate,
            dueDate: projects[i].dueDate,
            tasks: projects[i].tasks,
            completedTasks: projects[i].tasks, // Set to total tasks
            priority: projects[i].priority,
            status: 'completed',
            category: projects[i].category,
          );
        } else {
          // Restore original status
          projects[i] = Project(
            id: projects[i].id,
            name: projects[i].name,
            description: projects[i].description,
            startDate: projects[i].startDate,
            dueDate: projects[i].dueDate,
            tasks: projects[i].tasks,
            completedTasks: (projects[i].tasks * 0.6).round(),
            priority: projects[i].priority,
            status: originalStatuses[i] ?? 'in progress',
            category: projects[i].category,
          );
        }
      }
    });
  }

  void _handleCheckboxChange(int index, bool? value) async {
    if (showArchived) return;

    if (value == true) {
      // Show confirmation dialog
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(
                PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                color: Colors.green.shade400,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text('Complete Project'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to mark "${projects[index].name}" as complete?',
              ),
              const SizedBox(height: 8),
              Text(
                'This will move the project to the archived section.',
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green.shade400,
              ),
              child: const Text('Complete'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      if (confirmed == true) {
        try {
          // Store original status before completing
          originalStatuses[index] = projects[index].status;

          // Create completed project
          final updatedProject = Project(
            id: projects[index].id,
            name: projects[index].name,
            description: projects[index].description,
            startDate: projects[index].startDate,
            dueDate: projects[index].dueDate,
            tasks: projects[index].tasks,
            completedTasks: projects[index].tasks,
            priority: projects[index].priority,
            status: 'completed',
            category: projects[index].category,
          );

          // Save to database
          await _projectDatabaseService.updateProject(updatedProject);

          setState(() {
            // Move to archived list
            archivedProjects.add(updatedProject);
            // Remove from active projects
            projects.removeAt(index);
            checkedProjects.removeAt(index);
          });

          _showSuccessMessage(
            message: 'Project marked as complete',
            icon: PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
          );
        } catch (e) {
          _showError('Failed to update project status: $e');
        }
      }
    }
  }

  void _handleRestore(int index) async {
    final project =
        showArchived ? archivedProjects[index] : deletedProjects[index];

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.fill),
              color: AppColors.accent,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text('Restore Project'),
          ],
        ),
        content: Text(
          'Are you sure you want to restore "${project.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
            ),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        if (showArchived) {
          // Handle archived project restoration
          final restoredProject = Project(
            id: project.id,
            name: project.name,
            description: project.description,
            startDate: project.startDate,
            dueDate: project.dueDate,
            tasks: project.tasks,
            completedTasks: project.completedTasks,
            priority: project.priority,
            status: originalStatuses[index] ?? 'in progress',
            category: project.category,
          );

          // Move back to projects list
          setState(() {
            projects.add(restoredProject);
            archivedProjects.removeAt(index);
            checkedProjects.add(false);
            originalStatuses.remove(index);
          });
        } else {
          // Handle recycle bin project restoration
          if (project.id != null) {
            await _projectDatabaseService.restoreFromRecycleBin(project.id!);
            setState(() {
              projects.add(project);
              deletedProjects.removeAt(index);
              checkedProjects.add(false);
            });
          }
        }

        _showSuccessMessage(
          message: 'Project has been restored',
          icon: PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.fill),
        );
      } catch (e) {
        _showError('Failed to restore project: $e');
      }
    }
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
        duration: const Duration(seconds: 2),
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Add this getter to check if any filters are active
  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      selectedPriority != null ||
      selectedStatus != null ||
      selectedCategory != null ||
      _selectedDateRange != null;

  // Add this method to clear all filters
  void _clearAllFilters() {
    setState(() {
      searchQuery = '';
      searchController.clear();
      selectedPriority = null;
      selectedStatus = null;
      selectedCategory = null;
      _selectedDateRange = null;
    });

    _showSuccessMessage(
      message: 'All filters have been cleared',
      icon: PhosphorIcons.funnel(PhosphorIconsStyle.fill),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
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
                        _buildAddProjectButton(),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Filter bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFilterButtons(),
                        _buildRightSideControls(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Content section
            Expanded(
              child: _buildProjectsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddProjectButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent,
            Color.lerp(AppColors.accent, Colors.purple, 0.6) ??
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
          onTap: _handleAddProject,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                    PhosphorIcons.plus(PhosphorIconsStyle.bold),
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Add Project',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      children: [
        _buildFilterButton(
          'All Projects',
          PhosphorIcons.folder(PhosphorIconsStyle.bold),
          showAllProjects,
          () => setState(() {
            showAllProjects = true;
            showArchived = false;
            showRecycleBin = false;
          }),
          tooltip: 'Show all active projects',
        ),
        const SizedBox(width: 8),
        _buildFilterButton(
          'Archived',
          PhosphorIcons.archive(PhosphorIconsStyle.bold),
          showArchived,
          () => setState(() {
            showArchived = true;
            showAllProjects = false;
            showRecycleBin = false;
          }),
          tooltip: 'Show completed projects',
        ),
        const SizedBox(width: 8),
        _buildFilterButton(
          'Recycle Bin',
          PhosphorIcons.trash(PhosphorIconsStyle.bold),
          showRecycleBin,
          () {
            setState(() {
              showRecycleBin = true;
              showAllProjects = false;
              showArchived = false;
              _newlyDeletedCount = 0;
              _hasVisitedRecycleBin = true;
            });
          },
          tooltip: 'Show deleted projects',
          badge: !_hasVisitedRecycleBin && _newlyDeletedCount > 0
              ? '$_newlyDeletedCount'
              : null,
        ),
      ],
    );
  }

  Widget _buildFilterButton(
    String label,
    IconData icon,
    bool isActive,
    VoidCallback onPressed, {
    String? tooltip,
    String? badge,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Tooltip(
        message: tooltip ?? label,
        child: Container(
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: isActive ? AppColors.accent : null),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(color: isActive ? AppColors.accent : null),
              ),
              if (badge != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightSideControls() {
    return Row(
      children: [
        // Search
        if (hasActiveFilters) ...[
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red.shade300,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton.icon(
              onPressed: _clearAllFilters,
              icon: Icon(
                PhosphorIcons.x(PhosphorIconsStyle.bold),
                size: 18,
                color: Colors.red.shade400,
              ),
              label: Text(
                'Clear Filters',
                style: TextStyle(
                  color: Colors.red.shade400,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Container(
          width: 240,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).cardColor,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Icon(
                  PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
                  size: 18,
                  color: Theme.of(context).hintColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search projects...',
                    hintStyle: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    isDense: true,
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
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Category Filter
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
                  PhosphorIcons.funnel(PhosphorIconsStyle.bold),
                  size: 18,
                  color: selectedCategory != null ? AppColors.accent : null,
                ),
                const SizedBox(width: 8),
                Text(
                  selectedCategory?.capitalize() ?? 'All Categories',
                  style: TextStyle(
                    color: selectedCategory != null ? AppColors.accent : null,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  PhosphorIcons.caretDown(PhosphorIconsStyle.bold),
                  size: 18,
                  color: selectedCategory != null ? AppColors.accent : null,
                ),
              ],
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'all',
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: const Text('All Categories'),
                ),
              ),
              const PopupMenuDivider(),
              ...{
                'school': (
                  PhosphorIcons.graduationCap(PhosphorIconsStyle.fill),
                  AppColors.accent
                ),
                'personal': (
                  PhosphorIcons.user(PhosphorIconsStyle.fill),
                  Colors.purple.shade400
                ),
                'work': (
                  PhosphorIcons.briefcase(PhosphorIconsStyle.fill),
                  Colors.blue.shade400
                ),
                'online work': (
                  PhosphorIcons.globe(PhosphorIconsStyle.fill),
                  Colors.green.shade400
                ),
                'other': (
                  PhosphorIcons.folder(PhosphorIconsStyle.fill),
                  Colors.grey.shade400
                ),
              }.entries.map(
                    (entry) => PopupMenuItem(
                      value: entry.key,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        child: Row(
                          children: [
                            Icon(entry.value.$1,
                                size: 16, color: entry.value.$2),
                            const SizedBox(width: 8),
                            Text(entry.key.capitalize()),
                          ],
                        ),
                      ),
                    ),
                  ),
            ],
            onSelected: (value) {
              setState(() {
                selectedCategory = value == 'all' ? null : value;
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
                icon: PhosphorIcons.list(PhosphorIconsStyle.bold),
                isActive: isListView,
                onPressed: () => setState(() => isListView = true),
              ),
              Container(
                width: 1,
                height: 20,
                color: Theme.of(context).dividerColor,
              ),
              _buildViewToggleButton(
                icon: PhosphorIcons.squaresFour(PhosphorIconsStyle.bold),
                isActive: !isListView,
                onPressed: () => setState(() => isListView = false),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildViewToggleButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: icon == PhosphorIcons.list(PhosphorIconsStyle.bold)
          ? 'List View'
          : 'Grid View',
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: 40,
          height: 40,
          color: isActive ? AppColors.accent.withOpacity(0.1) : null,
          child: Icon(
            icon,
            size: 16,
            color: isActive ? AppColors.accent : null,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeframeDropdown() {
    return PopupMenuButton<String>(
      initialValue: _selectedTimeframe,
      offset: const Offset(0, 40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIcons.calendar(PhosphorIconsStyle.bold),
              size: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            const SizedBox(width: 8),
            Text(
              _selectedTimeframe,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: 8),
            Icon(
              PhosphorIcons.caretDown(PhosphorIconsStyle.bold),
              size: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ],
        ),
      ),
      itemBuilder: (BuildContext context) => _timeframes.map((timeframe) {
        return PopupMenuItem<String>(
          value: timeframe,
          child: Row(
            children: [
              Icon(
                timeframe == _selectedTimeframe
                    ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill)
                    : PhosphorIcons.circle(PhosphorIconsStyle.regular),
                size: 16,
                color:
                    timeframe == _selectedTimeframe ? AppColors.accent : null,
              ),
              const SizedBox(width: 8),
              Text(timeframe),
            ],
          ),
        );
      }).toList(),
      onSelected: (String value) {
        setState(() {
          _selectedTimeframe = value;
          _updateStatistics(value);
        });
      },
    );
  }

  void _updateStatistics(String timeframe) {
    // In a real application, you would fetch and update statistics based on the timeframe
    // For now, we'll just print the selected timeframe
    print('Selected timeframe: $timeframe');
    // You would typically make an API call or filter your data here
  }

  Widget _buildEnhancedStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required String trend,
    required bool trendUp,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color:
                        (trendUp ? Colors.green : Colors.red).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendUp
                            ? PhosphorIcons.trendUp(PhosphorIconsStyle.fill)
                            : PhosphorIcons.trendDown(PhosphorIconsStyle.fill),
                        size: 12,
                        color: trendUp ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        trend,
                        style: TextStyle(
                          color: trendUp ? Colors.green : Colors.red,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.7),
                    fontSize: 11,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.7),
                    fontSize: 11,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDateRangeSelect() async {
    final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        initialDateRange: _selectedDateRange ??
            DateTimeRange(
              start: DateTime.now(),
              end: DateTime.now().add(const Duration(days: 7)),
            ));

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _filterProjects();
      });
    }
  }

  DateTime _parseDate(String date) {
    final parts = date.split(' ');
    final day = int.parse(parts[0]);
    final month = _getMonthFromAbbr(parts[1].replaceAll(',', ''));
    final year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  int _getMonthFromAbbr(String monthAbbr) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months.indexOf(monthAbbr) + 1;
  }

  void _filterProjects() {
    // Implement your filtering logic here
    // For example, you can filter projects based on the selected date range
    // and other filters
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  Widget _buildProjectsPieChart() {
    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: 20,
            sections: [
              PieChartSectionData(
                value: projects
                    .where((p) => p.status == 'completed')
                    .length
                    .toDouble(),
                color: Colors.green.shade400,
                radius: 8,
                showTitle: false,
              ),
              PieChartSectionData(
                value: projects
                    .where((p) => p.status == 'in progress')
                    .length
                    .toDouble(),
                color: Colors.blue.shade400,
                radius: 8,
                showTitle: false,
              ),
              PieChartSectionData(
                value: projects
                    .where((p) => p.status == 'on hold')
                    .length
                    .toDouble(),
                color: Colors.orange.shade400,
                radius: 8,
                showTitle: false,
              ),
              PieChartSectionData(
                value: projects
                    .where((p) => p.status == 'not started')
                    .length
                    .toDouble(),
                color: Colors.grey.shade400,
                radius: 8,
                showTitle: false,
              ),
            ],
          ),
        ),
        Text(
          '${((projects.where((p) => p.status == 'completed').length / projects.length) * 100).toStringAsFixed(0)}%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildProjectsBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: projects.length.toDouble(),
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                String text = '';
                switch (value.toInt()) {
                  case 0:
                    text = 'High';
                    break;
                  case 1:
                    text = 'Medium';
                    break;
                  case 2:
                    text = 'Low';
                    break;
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: projects
                    .where((p) => p.priority == 'high')
                    .length
                    .toDouble(),
                color: Colors.red.shade400,
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: projects
                    .where((p) => p.priority == 'medium')
                    .length
                    .toDouble(),
                color: Colors.orange.shade400,
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: projects
                    .where((p) => p.priority == 'low')
                    .length
                    .toDouble(),
                color: Colors.green.shade400,
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat({
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color.withOpacity(0.8),
                    fontSize: 10,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniPieChart() {
    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: 15,
            sections: [
              PieChartSectionData(
                value: projects
                    .where((p) => p.status == 'completed')
                    .length
                    .toDouble(),
                color: Colors.green.shade400,
                radius: 5,
                showTitle: false,
              ),
              PieChartSectionData(
                value: projects
                    .where((p) => p.status == 'in progress')
                    .length
                    .toDouble(),
                color: Colors.blue.shade400,
                radius: 5,
                showTitle: false,
              ),
              PieChartSectionData(
                value: projects
                    .where((p) => p.status == 'on hold')
                    .length
                    .toDouble(),
                color: Colors.orange.shade400,
                radius: 5,
                showTitle: false,
              ),
              PieChartSectionData(
                value: projects
                    .where((p) => p.status == 'not started')
                    .length
                    .toDouble(),
                color: Colors.grey.shade400,
                radius: 5,
                showTitle: false,
              ),
            ],
          ),
        ),
        Text(
          '${((projects.where((p) => p.status == 'completed').length / projects.length) * 100).toStringAsFixed(0)}%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
        ),
      ],
    );
  }

  Widget _buildViewOptions() {
    return Container(
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
            icon: PhosphorIcons.list(PhosphorIconsStyle.bold),
            isActive: isListView,
            onPressed: () => setState(() => isListView = true),
          ),
          Container(
            width: 1,
            height: 20,
            color: Theme.of(context).dividerColor,
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

  void _handleRestoreAll() async {
    // Check which list we're working with
    final isRecycleBin = showRecycleBin;
    final listToRestore = isRecycleBin ? deletedProjects : archivedProjects;

    if (listToRestore.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(
                PhosphorIcons.info(PhosphorIconsStyle.fill),
                color: AppColors.accent,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text('No ${isRecycleBin ? 'Deleted' : 'Archived'} Projects'),
            ],
          ),
          content: Text(
            'There are no ${isRecycleBin ? 'deleted' : 'archived'} projects to restore.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
              ),
              child: const Text('OK'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.fill),
              color: AppColors.accent,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text('Restore All Projects'),
          ],
        ),
        content: Text(
          'Are you sure you want to restore all ${listToRestore.length} ${isRecycleBin ? 'deleted' : 'archived'} projects?',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
            ),
            child: const Text('Restore All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        if (isRecycleBin) {
          // Restore all projects from recycle bin
          for (final project in listToRestore) {
            if (project.id != null) {
              await _projectDatabaseService.restoreFromRecycleBin(project.id!);
            }
          }
          setState(() {
            projects.addAll(listToRestore);
            deletedProjects.clear();
            checkedProjects = List.generate(projects.length, (_) => false);
          });
        } else {
          // Restore all archived projects
          for (final project in listToRestore) {
            final restoredProject = Project(
              id: project.id,
              name: project.name,
              description: project.description,
              startDate: project.startDate,
              dueDate: project.dueDate,
              tasks: project.tasks,
              completedTasks: project.completedTasks,
              priority: project.priority,
              status: 'in progress',
              category: project.category,
            );
            projects.add(restoredProject);
          }
          setState(() {
            archivedProjects.clear();
            checkedProjects = List.generate(projects.length, (_) => false);
            originalStatuses.clear();
          });
        }

        // Reload projects to ensure sync with database
        await _loadProjects();
        if (isRecycleBin) {
          await _loadDeletedProjects();
        }

        _showSuccessMessage(
          message: 'All projects have been restored',
          icon: PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.fill),
        );
      } catch (e) {
        _showError('Failed to restore projects: $e');
      }
    }
  }

  void _handleCompleteSelected() async {
    final selectedCount = checkedProjects.where((c) => c).length;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
              color: Colors.green.shade400,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text('Complete Projects'),
          ],
        ),
        content: Text(
          'Are you sure you want to mark $selectedCount projects as completed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green.shade400,
            ),
            child: const Text('Complete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Update each selected project
        for (int i = projects.length - 1; i >= 0; i--) {
          if (checkedProjects[i]) {
            final updatedProject = Project(
              id: projects[i].id,
              name: projects[i].name,
              description: projects[i].description,
              startDate: projects[i].startDate,
              dueDate: projects[i].dueDate,
              tasks: projects[i].tasks,
              completedTasks: projects[i].tasks,
              priority: projects[i].priority,
              status: 'completed',
              category: projects[i].category,
            );

            // Save to database
            await _projectDatabaseService.updateProject(updatedProject);

            // Move to archived list
            archivedProjects.add(updatedProject);
            projects.removeAt(i);
            checkedProjects.removeAt(i);
          }
        }

        _showSuccessMessage(
          message: 'Selected projects marked as complete',
          icon: PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
        );
      } catch (e) {
        _showError('Failed to complete projects: $e');
      }
    }
  }

  void _handleDeleteSelected() async {
    final selectedCount = checkedProjects.where((c) => c).length;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              PhosphorIcons.trash(PhosphorIconsStyle.fill),
              color: Colors.red.shade400,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text('Delete Projects'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete $selectedCount projects? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade400,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Delete selected projects from database and local state
        for (int i = projects.length - 1; i >= 0; i--) {
          if (checkedProjects[i]) {
            if (projects[i].id != null) {
              await _projectDatabaseService.deleteProject(projects[i].id!);
            }
            projects.removeAt(i);
            checkedProjects.removeAt(i);
          }
        }

        // Reload projects to ensure sync with database
        await _loadProjects();

        _showSuccessMessage(
          message: 'Selected projects have been deleted',
          icon: PhosphorIcons.trash(PhosphorIconsStyle.fill),
        );
      } catch (e) {
        _showError('Failed to delete projects: $e');
      }
    }
  }

  void _handleRecycleBinSelectAll(bool? value) {
    setState(() {
      recycleBinSelectAll = value ?? false;
      recycleBinCheckedProjects = List.generate(
        deletedProjects.length,
        (_) => recycleBinSelectAll,
      );
    });
  }

  void _handleRestoreSelected() async {
    // Fix the where clause to use indexed iteration
    final selectedProjects = deletedProjects
        .asMap()
        .entries
        .where((entry) => recycleBinCheckedProjects[entry.key])
        .map((entry) => entry.value)
        .toList();

    if (selectedProjects.isEmpty) return;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.fill),
              color: AppColors.accent,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text('Restore Selected Projects'),
          ],
        ),
        content: Text(
          'Are you sure you want to restore ${selectedProjects.length} selected projects?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
            ),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        for (final project in selectedProjects) {
          if (project.id != null) {
            await _projectDatabaseService.restoreFromRecycleBin(project.id!);
          }
        }
        await _loadProjects();
        await _loadDeletedProjects();
        _showSuccessMessage(
          message: 'Selected projects have been restored',
          icon: PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.fill),
        );
      } catch (e) {
        _showError('Failed to restore projects: $e');
      }
    }
  }

  void _handlePermanentlyDeleteSelected() async {
    // Fix the where clause to use indexed iteration
    final selectedProjects = deletedProjects
        .asMap()
        .entries
        .where((entry) => recycleBinCheckedProjects[entry.key])
        .map((entry) => entry.value)
        .toList();

    if (selectedProjects.isEmpty) return;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              PhosphorIcons.warning(PhosphorIconsStyle.fill),
              color: Colors.red.shade400,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text('Permanently Delete Projects'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to permanently delete ${selectedProjects.length} selected projects?',
            ),
            const SizedBox(height: 8),
            Text(
              'This action cannot be undone.',
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade400,
            ),
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        for (final project in selectedProjects) {
          if (project.id != null) {
            await _projectDatabaseService.permanentlyDelete(project.id!);
          }
        }
        await _loadDeletedProjects();
        _showSuccessMessage(
          message: 'Selected projects have been permanently deleted',
          icon: PhosphorIcons.trash(PhosphorIconsStyle.fill),
        );
      } catch (e) {
        _showError('Failed to delete projects: $e');
      }
    }
  }

  void _handlePermanentDelete(int index) async {
    final projectName = deletedProjects[index].name;
    final projectId = deletedProjects[index].id;

    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIcons.warning(PhosphorIconsStyle.fill),
              color: Colors.red.shade400,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Permanently Delete Project',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to permanently delete "$projectName"?',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'This action cannot be undone.',
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 14,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Delete Permanently',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && projectId != null) {
      try {
        await _projectDatabaseService.permanentlyDelete(projectId);

        setState(() {
          deletedProjects.removeAt(index);
          recycleBinCheckedProjects =
              List.generate(deletedProjects.length, (_) => false);
        });

        _showSuccessMessage(
          message: 'Project "$projectName" has been permanently deleted',
          icon: PhosphorIcons.trash(PhosphorIconsStyle.fill),
        );
      } catch (e) {
        _showError('Failed to delete project: $e');
      }
    }
  }

  Widget _buildProjectsList() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
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
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Checkbox or restore all button
                if (showRecycleBin)
                  SizedBox(
                    width: 24,
                    child: Checkbox(
                      value: recycleBinSelectAll,
                      onChanged: (value) {
                        setState(() {
                          recycleBinSelectAll = value ?? false;
                          recycleBinCheckedProjects = List.generate(
                            deletedProjects.length,
                            (_) => value ?? false,
                          );
                        });
                      },
                    ),
                  ),
                const Spacer(),
                // Show action buttons only when items are selected in recycle bin
                if (showRecycleBin &&
                    recycleBinCheckedProjects.contains(true)) ...[
                  FilledButton.icon(
                    onPressed: _handleRestoreSelected,
                    icon: Icon(
                      PhosphorIcons.arrowCounterClockwise(
                          PhosphorIconsStyle.bold),
                      color: Colors.white,
                    ),
                    label: const Text('Restore Selected'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _handlePermanentlyDeleteSelected,
                    icon: Icon(
                      PhosphorIcons.trash(PhosphorIconsStyle.bold),
                      color: Colors.white,
                    ),
                    label: const Text('Delete Permanently'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          // Project List/Grid
          Expanded(
            child: isListView
                ? ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: showRecycleBin
                        ? deletedProjects.length
                        : projects.length,
                    itemBuilder: (context, index) {
                      final project = showRecycleBin
                          ? deletedProjects[index]
                          : projects[index];
                      return MouseRegion(
                        onEnter: (_) => setState(() => hoveredIndex = index),
                        onExit: (_) => setState(() => hoveredIndex = null),
                        child: ProjectListItem(
                          project: project,
                          isChecked: showRecycleBin
                              ? recycleBinCheckedProjects[index]
                              : checkedProjects[index],
                          onCheckChanged: showRecycleBin
                              ? (value) {
                                  setState(() {
                                    recycleBinCheckedProjects[index] =
                                        value ?? false;
                                    recycleBinSelectAll =
                                        recycleBinCheckedProjects
                                            .every((checked) => checked);
                                  });
                                }
                              : (value) => _handleCheckboxChange(index, value),
                          onEdit:
                              showRecycleBin ? () {} : () => _handleEdit(index),
                          onDelete: showRecycleBin
                              ? () => _handlePermanentDelete(index)
                              : () => _handleDelete(index),
                          onRestore: showRecycleBin
                              ? () => _handleRestore(index)
                              : null,
                          isHovered: hoveredIndex == index,
                        ),
                      );
                    },
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: showArchived
                        ? archivedProjects.length
                        : showRecycleBin
                            ? deletedProjects.length
                            : projects.length,
                    itemBuilder: (context, index) {
                      final project = showArchived
                          ? archivedProjects[index]
                          : showRecycleBin
                              ? deletedProjects[index]
                              : projects[index];
                      return MouseRegion(
                        onEnter: (_) => setState(() => hoveredIndex = index),
                        onExit: (_) => setState(() => hoveredIndex = null),
                        child: ProjectGridItem(
                          project: project,
                          isChecked: showArchived
                              ? archivedCheckedProjects[index]
                              : showRecycleBin
                                  ? recycleBinCheckedProjects[index]
                                  : checkedProjects[index],
                          onCheckChanged: showArchived
                              ? (value) {
                                  setState(() {
                                    archivedCheckedProjects[index] =
                                        value ?? false;
                                    archivedSelectAll = archivedCheckedProjects
                                        .every((checked) => checked);
                                  });
                                }
                              : showRecycleBin
                                  ? (value) {
                                      setState(() {
                                        recycleBinCheckedProjects[index] =
                                            value ?? false;
                                        recycleBinSelectAll =
                                            recycleBinCheckedProjects
                                                .every((checked) => checked);
                                      });
                                    }
                                  : (value) =>
                                      _handleCheckboxChange(index, value),
                          onEdit: showRecycleBin || showArchived
                              ? () {}
                              : () => _handleEdit(index),
                          onDelete: showRecycleBin
                              ? () => _handlePermanentDelete(index)
                              : () => _handleDelete(index),
                          onRestore: (showRecycleBin || showArchived)
                              ? () => _handleRestore(index)
                              : null,
                          isHovered: hoveredIndex == index,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
