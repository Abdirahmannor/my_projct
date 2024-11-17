import 'package:flutter/material.dart';
import '../../../core/base/base_list_screen.dart';
import '../../../core/base/base_state.dart';
import '../../../core/base/base_constants.dart';
import '../models/task.dart';
import '../widgets/task_list_item.dart';
import '../widgets/task_grid_item.dart';
import '../widgets/task_dialog.dart';
import '../services/task_database.dart';
import '../state/task_state.dart';

class TaskScreen extends BaseListScreen<Task> {
  final String projectId;

  const TaskScreen({
    super.key,
    required this.projectId,
  });

  @override
  TaskScreenState createState() => TaskScreenState();
}

class TaskScreenState extends BaseListScreenState<Task> {
  final database = TaskDatabase();

  @override
  BaseState<Task> createState() => TaskState();

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
            'Tasks',
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
                hintText: 'Search tasks...',
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
            onPressed: () => _showTaskDialog(),
            icon: const Icon(Icons.add),
            label: const Text('New Task'),
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

          // Filter by Assignee
          if ((state as TaskState).assignees.isNotEmpty)
            DropdownButton<String>(
              value: (state as TaskState).selectedAssignee,
              hint: const Text('Assignee'),
              items: [
                const DropdownMenuItem(
                    value: null, child: Text('All Assignees')),
                ...(state as TaskState).assignees.map(
                      (a) => DropdownMenuItem(value: a, child: Text(a)),
                    ),
              ],
              onChanged: (value) =>
                  setState(() => (state as TaskState).selectedAssignee = value),
            ),
          const SizedBox(width: 16),

          // Filter by Label
          if ((state as TaskState).labels.isNotEmpty)
            DropdownButton<String>(
              value: (state as TaskState).selectedLabel,
              hint: const Text('Label'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Labels')),
                ...(state as TaskState).labels.map(
                      (l) => DropdownMenuItem(value: l, child: Text(l)),
                    ),
              ],
              onChanged: (value) =>
                  setState(() => (state as TaskState).selectedLabel = value),
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
  Widget buildListView(List<Task> items) {
    if (items.isEmpty) {
      return const Center(child: Text('No tasks found'));
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final task = items[index];
        return TaskListItem(
          key: ValueKey(task.id),
          item: task,
          isChecked: state.checkedItems[index],
          isHovered: false,
          onCheckChanged: (value) =>
              setState(() => state.checkedItems[index] = value ?? false),
          onEdit: () => _showTaskDialog(task),
          onDelete: () => _deleteTask(task),
          onRestore: state.showRecycleBin ? () => _restoreTask(task.id!) : null,
        );
      },
    );
  }

  @override
  Widget buildGridView(List<Task> items) {
    if (items.isEmpty) {
      return const Center(child: Text('No tasks found'));
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
        final task = items[index];
        return TaskGridItem(
          key: ValueKey(task.id),
          item: task,
          isChecked: state.checkedItems[index],
          isHovered: false,
          onCheckChanged: (value) =>
              setState(() => state.checkedItems[index] = value ?? false),
          onEdit: () => _showTaskDialog(task),
          onDelete: () => _deleteTask(task),
          onRestore: state.showRecycleBin ? () => _restoreTask(task.id!) : null,
        );
      },
    );
  }

  Future<void> _showTaskDialog([Task? task]) async {
    final result = await showDialog<Task>(
      context: context,
      builder: (context) => TaskDialog(
        task: task,
        projectId: (widget as TaskScreen).projectId,
      ),
    );

    if (result != null) {
      if (task != null) {
        await database.update(result);
      } else {
        await database.add(result);
      }
      loadItems();
    }
  }

  Future<void> _deleteTask(Task task) async {
    if (state.showRecycleBin) {
      await database.permanentlyDelete(task.id!);
    } else {
      await database.moveToRecycleBin(task);
    }
    loadItems();
  }

  Future<void> _restoreTask(String id) async {
    await database.restoreFromRecycleBin(id);
    loadItems();
  }

  @override
  Future<void> loadItems() async {
    state.items =
        await database.getTasksForProject((widget as TaskScreen).projectId);
    state.archivedItems =
        state.items.where((t) => t.status == 'archived').toList();
    state.items = state.items.where((t) => t.status != 'archived').toList();
    state.deletedItems = await database.getDeleted();

    state.checkedItems = List.generate(state.items.length, (_) => false);
    state.archivedCheckedItems =
        List.generate(state.archivedItems.length, (_) => false);
    state.recycleBinCheckedItems =
        List.generate(state.deletedItems.length, (_) => false);

    setState(() {});
  }
}
