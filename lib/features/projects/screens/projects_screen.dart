import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../widgets/project_list_item.dart';
import '../widgets/project_grid_item.dart';
import '../widgets/add_project_dialog.dart';
import '../widgets/project_filter_dialog.dart';
import '../models/project.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/project_screen_header.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final _projectsBox = Hive.box<Project>('projects');
  final _deletedProjectsBox = Hive.box<Project>('deleted_projects');
  Map<String, bool> selectedProjects = {};
  Map<String, bool> hoveredProjects = {};
  bool _isGridView = false;

  // Filter state
  Map<String, bool> selectedCategories = {
    'school': false,
    'work': false,
    'personal': false,
    'other': false,
  };
  Map<String, bool> selectedPriorities = {
    'low': false,
    'medium': false,
    'high': false,
  };
  Map<String, bool> selectedStatuses = {
    'not started': false,
    'in progress': false,
    'completed': false,
    'on hold': false,
  };
  DateTimeRange? selectedDateRange;

  List<Project> _filterProjects(List<Project> projects) {
    return projects.where((project) {
      // Check if any filters are active
      bool hasActiveFilters = selectedCategories.values.any((v) => v) ||
          selectedPriorities.values.any((v) => v) ||
          selectedStatuses.values.any((v) => v) ||
          selectedDateRange != null;

      if (!hasActiveFilters) return true;

      bool matchesCategory = !selectedCategories.values.any((v) => v) ||
          selectedCategories[project.category?.toLowerCase()] == true;

      bool matchesPriority = !selectedPriorities.values.any((v) => v) ||
          selectedPriorities[project.priority.toLowerCase()] == true;

      bool matchesStatus = !selectedStatuses.values.any((v) => v) ||
          selectedStatuses[project.status.toLowerCase()] == true;

      bool matchesDateRange = selectedDateRange == null ||
          (project.startDate.isAfter(selectedDateRange!.start) &&
              project.dueDate.isBefore(selectedDateRange!.end));

      return matchesCategory &&
          matchesPriority &&
          matchesStatus &&
          matchesDateRange;
    }).toList();
  }

  Future<void> _showFilterDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ProjectFilterDialog(
        selectedCategories: selectedCategories,
        selectedPriorities: selectedPriorities,
        selectedStatuses: selectedStatuses,
        dateRange: selectedDateRange,
      ),
    );

    if (result != null) {
      setState(() {
        selectedCategories = Map<String, bool>.from(result['categories']);
        selectedPriorities = Map<String, bool>.from(result['priorities']);
        selectedStatuses = Map<String, bool>.from(result['statuses']);
        selectedDateRange = result['dateRange'] as DateTimeRange?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProjectScreenHeader(
              isGridView: _isGridView,
              onViewToggle: () {
                setState(() {
                  _isGridView = !_isGridView;
                });
              },
              onFilter: _showFilterDialog,
              onSort: () {
                // TODO: Implement sort
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _projectsBox.listenable(),
                builder: (context, Box<Project> box, _) {
                  final projects = _filterProjects(box.values.toList());
                  if (projects.isEmpty) {
                    return _buildEmptyState();
                  }
                  return _isGridView
                      ? _buildGridView(projects)
                      : _buildListView(projects);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewProject,
        child: Icon(PhosphorIcons.plus(PhosphorIconsStyle.bold)),
      ),
    );
  }

  Widget _buildGridView(List<Project> projects) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return MouseRegion(
          onEnter: (_) => _onHover(project.id!, true),
          onExit: (_) => _onHover(project.id!, false),
          child: ProjectGridItem(
            project: project,
            isHovered: hoveredProjects[project.id] ?? false,
            onEdit: () => _editProject(project),
            onDelete: () => _deleteProject(project),
          ),
        );
      },
    );
  }

  Widget _buildListView(List<Project> projects) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return MouseRegion(
          onEnter: (_) => _onHover(project.id!, true),
          onExit: (_) => _onHover(project.id!, false),
          child: ProjectListItem(
            project: project,
            isChecked: selectedProjects[project.id] ?? false,
            isHovered: hoveredProjects[project.id] ?? false,
            onCheckChanged: (value) => _onSelect(project.id!, value ?? false),
            onEdit: () => _editProject(project),
            onDelete: () => _deleteProject(project),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.folder(PhosphorIconsStyle.thin),
            size: 64,
            color: Theme.of(context).hintColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No projects yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a new project to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _addNewProject,
            icon: Icon(PhosphorIcons.plus(PhosphorIconsStyle.bold)),
            label: const Text('New Project'),
          ),
        ],
      ),
    );
  }

  void _onSelect(String id, bool selected) {
    setState(() {
      selectedProjects[id] = selected;
    });
  }

  void _onHover(String id, bool hovered) {
    setState(() {
      hoveredProjects[id] = hovered;
    });
  }

  Future<void> _addNewProject() async {
    final project = await showDialog<Project>(
      context: context,
      builder: (context) => const AddProjectDialog(),
    );

    if (project != null) {
      await _projectsBox.put(project.id, project);
    }
  }

  Future<void> _editProject(Project project) async {
    final updatedProject = await showDialog<Project>(
      context: context,
      builder: (context) => AddProjectDialog(project: project),
    );

    if (updatedProject != null) {
      await _projectsBox.put(updatedProject.id, updatedProject);
    }
  }

  Future<void> _deleteProject(Project project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text('Are you sure you want to delete this project?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Move to deleted projects box before removing
      await _deletedProjectsBox.put(
          project.id,
          project.copyWith(
            deletedAt: DateTime.now(),
            originalStatus: project.status,
          ));
      await _projectsBox.delete(project.id);
    }
  }
}
