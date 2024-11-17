import 'package:flutter/material.dart';
import '../../../core/base/base_list_screen.dart';
import '../../../core/base/base_state.dart';
import '../../../core/base/base_constants.dart';
import '../models/project.dart';
import '../widgets/project_list_item.dart';
import '../widgets/project_grid_item.dart';
import '../widgets/project_dialog.dart';
import '../services/project_database.dart';
import '../state/project_state.dart';

class ProjectScreen extends BaseListScreen<Project> {
  const ProjectScreen({super.key});

  @override
  ProjectScreenState createState() => ProjectScreenState();
}

class ProjectScreenState extends BaseListScreenState<Project> {
  final database = ProjectDatabase();

  @override
  BaseState<Project> createState() => ProjectState();

  @override
  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.all(BaseConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          // Title
          const Text(
            'Projects',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),

          // Search
          SizedBox(
            width: 300,
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => state.searchQuery = value),
            ),
          ),
          const SizedBox(width: 16),

          // View Toggle
          IconButton(
            icon: Icon(viewManager.isListView ? Icons.grid_view : Icons.list),
            onPressed: viewManager.toggleView,
            tooltip: viewManager.isListView ? 'Grid View' : 'List View',
          ),
          const SizedBox(width: 16),

          // Add Button
          FilledButton.icon(
            onPressed: () => _showProjectDialog(),
            icon: const Icon(Icons.add),
            label: const Text('New Project'),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(BaseConstants.defaultPadding),
      child: Row(
        children: [
          // Filter by Priority
          DropdownButton<String>(
            value: state.selectedPriority,
            hint: const Text('Priority'),
            items: [
              const DropdownMenuItem(
                  value: null, child: Text('All Priorities')),
              ...['low', 'medium', 'high', 'critical'].map(
                (p) => DropdownMenuItem(
                  value: p,
                  child: Text(p[0].toUpperCase() + p.substring(1)),
                ),
              ),
            ],
            onChanged: (value) =>
                setState(() => state.selectedPriority = value),
          ),
          const SizedBox(width: 16),

          // Filter by Status
          DropdownButton<String>(
            value: state.selectedStatus,
            hint: const Text('Status'),
            items: [
              const DropdownMenuItem(value: null, child: Text('All Statuses')),
              ...['not started', 'in progress', 'on hold', 'completed'].map(
                (s) => DropdownMenuItem(
                  value: s,
                  child: Text(s[0].toUpperCase() + s.substring(1)),
                ),
              ),
            ],
            onChanged: (value) => setState(() => state.selectedStatus = value),
          ),
          const SizedBox(width: 16),

          // Date Range Picker
          TextButton.icon(
            onPressed: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2025),
              );
              if (picked != null) {
                setState(() => state.selectedDateRange = picked);
              }
            },
            icon: const Icon(Icons.calendar_today),
            label: Text(
              state.selectedDateRange != null
                  ? '${state.selectedDateRange!.start.day}/${state.selectedDateRange!.start.month} - '
                      '${state.selectedDateRange!.end.day}/${state.selectedDateRange!.end.month}'
                  : 'Select Dates',
            ),
          ),
          const SizedBox(width: 16),

          // Clear Filters
          if (state.hasActiveFilters)
            TextButton.icon(
              onPressed: () => clearFilters(context),
              icon: const Icon(Icons.clear_all),
              label: const Text('Clear Filters'),
            ),
          const Spacer(),

          // View Toggles
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'active', label: Text('Active')),
              ButtonSegment(value: 'archived', label: Text('Archived')),
              ButtonSegment(value: 'deleted', label: Text('Recycle Bin')),
            ],
            selected: {
              state.showRecycleBin
                  ? 'deleted'
                  : state.showArchived
                      ? 'archived'
                      : 'active'
            },
            onSelectionChanged: (values) {
              setState(() {
                state.showRecycleBin = values.first == 'deleted';
                state.showArchived = values.first == 'archived';
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget buildListView(List<Project> items) {
    if (items.isEmpty) {
      return const Center(child: Text('No projects found'));
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final project = items[index];
        return ProjectListItem(
          key: ValueKey(project.id),
          item: project,
          isChecked: state.checkedItems[index],
          isHovered: false,
          onCheckChanged: (value) =>
              setState(() => state.checkedItems[index] = value ?? false),
          onEdit: () => _showProjectDialog(project),
          onDelete: () => _deleteProject(project),
          onRestore:
              state.showRecycleBin ? () => _restoreProject(project.id!) : null,
        );
      },
    );
  }

  @override
  Widget buildGridView(List<Project> items) {
    if (items.isEmpty) {
      return const Center(child: Text('No projects found'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(BaseConstants.defaultPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: BaseConstants.defaultSpacing,
        mainAxisSpacing: BaseConstants.defaultSpacing,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final project = items[index];
        return ProjectGridItem(
          key: ValueKey(project.id),
          item: project,
          isChecked: state.checkedItems[index],
          isHovered: false,
          onCheckChanged: (value) =>
              setState(() => state.checkedItems[index] = value ?? false),
          onEdit: () => _showProjectDialog(project),
          onDelete: () => _deleteProject(project),
          onRestore:
              state.showRecycleBin ? () => _restoreProject(project.id!) : null,
        );
      },
    );
  }

  Future<void> _showProjectDialog([Project? project]) async {
    final result = await showDialog<Project>(
      context: context,
      builder: (context) => ProjectDialog(project: project),
    );

    if (result != null) {
      try {
        // Don't show loading overlay for database operation
        if (project != null) {
          await database.update(result);
        } else {
          await database.add(result);
        }

        // Reload items without loading overlay
        if (!mounted) return;
        await loadItems();

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text(project != null
                      ? 'Project updated successfully'
                      : 'Project created successfully'),
                ],
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Error: ${e.toString()}'),
                ],
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _deleteProject(Project project) async {
    if (state.showRecycleBin) {
      await database.permanentlyDelete(project.id!);
    } else {
      await database.moveToRecycleBin(project);
    }
    loadItems();
  }

  Future<void> _restoreProject(String id) async {
    await database.restoreFromRecycleBin(id);
    loadItems();
  }

  @override
  Future<void> loadItems() async {
    if (!mounted) return;

    try {
      final allItems = await database.getAll();
      final deletedItems = await database.getDeleted();

      if (!mounted) return;

      setState(() {
        state.items = allItems.where((p) => p.status != 'archived').toList();
        state.archivedItems =
            allItems.where((p) => p.status == 'archived').toList();
        state.deletedItems = deletedItems;
        state.checkedItems = List.generate(state.items.length, (_) => false);
        state.archivedCheckedItems =
            List.generate(state.archivedItems.length, (_) => false);
        state.recycleBinCheckedItems =
            List.generate(state.deletedItems.length, (_) => false);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading items: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        super.build(context),
        if (state.isLoading)
          Container(
            color: Colors.black.withOpacity(0.1), // Very light overlay
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
