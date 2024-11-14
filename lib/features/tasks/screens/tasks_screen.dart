import 'package:school_task_manager/features/tasks/widgets/add_task_dialog.dart';
import 'package:school_task_manager/features/tasks/widgets/task_list_item.dart';

import '../widgets/task_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/string_extensions.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String? selectedPriority;
  String? selectedStatus;
  String? selectedProject;
  late List<bool> checkedTasks;
  bool isListView = true;
  int? hoveredIndex;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool showCompleted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final taskProvider = context.read<TaskProvider>();
    checkedTasks = List.generate(taskProvider.tasks.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks = taskProvider.tasks;
        final completedTasks = taskProvider.completedTasks;

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
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tasks',
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
                                  Color.lerp(AppColors.accent, Colors.purple,
                                          0.6) ??
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
                                    builder: (context) => const AddTaskDialog(),
                                  );

                                  if (result != null) {
                                    context
                                        .read<TaskProvider>()
                                        .addTask(result);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(
                                              PhosphorIcons.checkCircle(
                                                  PhosphorIconsStyle.fill),
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                                'Task "${result['name']}" has been created'),
                                          ],
                                        ),
                                        backgroundColor: Colors.green.shade400,
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.all(16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
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
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                        'Add Task',
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
                          // Left side filters
                          Row(
                            children: [
                              _buildFilterButton(
                                'All Tasks',
                                PhosphorIcons.listChecks(
                                    PhosphorIconsStyle.bold),
                                !showCompleted,
                                () => setState(() {
                                  showCompleted = false;
                                }),
                              ),
                              const SizedBox(width: 8),
                              _buildFilterButton(
                                'Completed',
                                PhosphorIcons.checkCircle(
                                    PhosphorIconsStyle.bold),
                                showCompleted,
                                () => setState(() {
                                  showCompleted = true;
                                }),
                              ),
                            ],
                          ),

                          // Right side controls
                          Row(
                            children: [
                              if (hasActiveFilters) ...[
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
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
                              // Search
                              Container(
                                width: 240,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white.withOpacity(0.1)
                                        : Theme.of(context).dividerColor,
                                    width: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? 1.5
                                        : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context).cardColor,
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Icon(
                                        PhosphorIcons.magnifyingGlass(
                                            PhosphorIconsStyle.bold),
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
                                          hintText: 'Search tasks...',
                                          hintStyle: TextStyle(
                                            color: Theme.of(context).hintColor,
                                          ),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 8),
                                          isDense: true,
                                        ),
                                      ),
                                    ),
                                    if (searchQuery.isNotEmpty)
                                      IconButton(
                                        icon: Icon(
                                          PhosphorIcons.x(
                                              PhosphorIconsStyle.bold),
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

                              // Priority Filter
                              Container(
                                height: 40,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white.withOpacity(0.1)
                                        : Theme.of(context).dividerColor,
                                    width: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? 1.5
                                        : 1,
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
                                    ...['critical', 'high', 'medium', 'low']
                                        .map(
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
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white.withOpacity(0.1)
                                        : Theme.of(context).dividerColor,
                                    width: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? 1.5
                                        : 1,
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
                  margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                              .withOpacity(0.1) // More visible in dark mode
                          : Theme.of(context).dividerColor,
                      width: Theme.of(context).brightness == Brightness.dark
                          ? 1.5
                          : 1, // Slightly thicker in dark mode
                    ),
                  ),
                  child: Column(
                    children: [
                      // Table Header
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              child: Tooltip(
                                message: showCompleted
                                    ? 'Restore all completed tasks'
                                    : 'Complete all tasks',
                                child: showCompleted
                                    ? IconButton(
                                        onPressed: _handleRestoreAll,
                                        icon: Icon(
                                          PhosphorIcons.arrowCounterClockwise(
                                              PhosphorIconsStyle.bold),
                                          size: 18,
                                          color: AppColors.accent,
                                        ),
                                        padding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      )
                                    : Checkbox(
                                        value: tasks.isNotEmpty &&
                                            checkedTasks
                                                .every((checked) => checked),
                                        onChanged: (value) =>
                                            _handleCompleteAll(),
                                        tristate: true,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Task Name',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 40,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: PopupMenuButton<String>(
                                  offset: const Offset(0, 40),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Project',
                                        style: TextStyle(
                                          color: selectedProject != null
                                              ? AppColors.accent
                                              : null,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Icon(
                                        PhosphorIcons.caretDown(
                                            PhosphorIconsStyle.bold),
                                        size: 14,
                                        color: selectedProject != null
                                            ? AppColors.accent
                                            : null,
                                      ),
                                    ],
                                  ),
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'all',
                                      child: Text('All Projects'),
                                    ),
                                    const PopupMenuDivider(),
                                    ...{
                                      // Get unique project names
                                      ...tasks.map((t) => t['project']),
                                      ...completedTasks
                                          .map((t) => t['project']),
                                    }.map(
                                      (project) => PopupMenuItem(
                                        value: project,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: const BoxDecoration(
                                                color: AppColors.accent,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(project),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                  onSelected: (value) {
                                    setState(() {
                                      selectedProject =
                                          value == 'all' ? null : value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Due Date',
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
                              child: Container(
                                height: 40,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white.withOpacity(0.1)
                                        : Theme.of(context).dividerColor,
                                    width: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? 1.5
                                        : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: PopupMenuButton<String>(
                                  offset: const Offset(0, 40),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Status',
                                        style: TextStyle(
                                          color: selectedStatus != null
                                              ? AppColors.accent
                                              : null,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Icon(
                                        PhosphorIcons.caretDown(
                                            PhosphorIconsStyle.bold),
                                        size: 14,
                                        color: selectedStatus != null
                                            ? AppColors.accent
                                            : null,
                                      ),
                                    ],
                                  ),
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'all',
                                      child: Text('All Status'),
                                    ),
                                    const PopupMenuDivider(),
                                    ...['to do', 'in progress', 'done'].map(
                                      (status) => PopupMenuItem(
                                        value: status,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: status == 'to do'
                                                    ? Colors.grey.shade400
                                                    : status == 'in progress'
                                                        ? Colors.blue.shade400
                                                        : Colors.green.shade400,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(status.toUpperCase()),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                  onSelected: (value) {
                                    setState(() {
                                      selectedStatus =
                                          value == 'all' ? null : value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 80,
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
                      // Task list/grid
                      Expanded(
                        child: !isListView
                            ? GridView.builder(
                                padding: const EdgeInsets.all(12),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount: showCompleted
                                    ? completedTasks.where(_filterTask).length
                                    : tasks.where(_filterTask).length,
                                itemBuilder: (context, index) {
                                  final filteredTasks = showCompleted
                                      ? completedTasks
                                          .where(_filterTask)
                                          .toList()
                                      : tasks.where(_filterTask).toList();
                                  final task = filteredTasks[index];
                                  return MouseRegion(
                                    onEnter: (_) =>
                                        setState(() => hoveredIndex = index),
                                    onExit: (_) =>
                                        setState(() => hoveredIndex = null),
                                    child: TaskGridItem(
                                      task: task,
                                      isChecked: task['status'] == 'done',
                                      onCheckChanged: showCompleted
                                          ? (_) {}
                                          : (value) => _handleCheckboxChange(
                                              index, value),
                                      onEdit: showCompleted
                                          ? () {}
                                          : () => _handleEdit(index),
                                      onDelete: () =>
                                          _handleDelete(index, showCompleted),
                                      onRestore: showCompleted
                                          ? () => _restoreTask(index)
                                          : null,
                                      isHovered: hoveredIndex == index,
                                    ),
                                  );
                                },
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: showCompleted
                                    ? completedTasks.where(_filterTask).length
                                    : tasks.where(_filterTask).length,
                                itemBuilder: (context, index) {
                                  final filteredTasks = showCompleted
                                      ? completedTasks
                                          .where(_filterTask)
                                          .toList()
                                      : tasks.where(_filterTask).toList();
                                  final task = filteredTasks[index];
                                  return MouseRegion(
                                    onEnter: (_) =>
                                        setState(() => hoveredIndex = index),
                                    onExit: (_) =>
                                        setState(() => hoveredIndex = null),
                                    child: TaskListItem(
                                      name: task['name'],
                                      description: task['description'],
                                      project: task['project'],
                                      dueDate: task['dueDate'],
                                      priority: task['priority'],
                                      status: task['status'],
                                      isChecked: task['status'] == 'done',
                                      isHovered: hoveredIndex == index,
                                      onCheckChanged: showCompleted
                                          ? (_) {}
                                          : (value) => _handleCheckboxChange(
                                              index, value),
                                      onEdit: showCompleted
                                          ? () {}
                                          : () => _handleEdit(index),
                                      onDelete: () =>
                                          _handleDelete(index, showCompleted),
                                      onRestore: showCompleted
                                          ? () => _restoreTask(index)
                                          : null,
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
      },
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

  void _filterTasks() {
    // Implement task filtering logic here
    setState(() {
      // Filter tasks based on search, status, priority, etc.
    });
  }

  Widget _buildFilterButton(
    String label,
    IconData icon,
    bool isActive,
    VoidCallback onPressed,
  ) {
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

  void _handleCheckboxChange(int index, bool? value) async {
    if (value == true) {
      final taskProvider = context.read<TaskProvider>();
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
              const Text('Complete Task'),
            ],
          ),
          content: Text(
            'Are you sure you want to mark "${taskProvider.tasks[index]['name']}" as complete?',
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
        ),
      );

      if (confirmed == true) {
        taskProvider.completeTask(index);
        setState(() {
          checkedTasks.removeAt(index);
        });

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  const Text('Task marked as complete'),
                ],
              ),
              backgroundColor: Colors.green.shade400,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _handleCompleteAll() async {
    final taskProvider = context.read<TaskProvider>();
    if (taskProvider.tasks.isEmpty) return;

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
            const Text('Complete All Tasks'),
          ],
        ),
        content: Text(
          'Are you sure you want to mark all ${taskProvider.tasks.length} tasks as complete?',
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
            child: const Text('Complete All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      taskProvider.completeAllTasks();
      setState(() {
        checkedTasks.clear();
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                const Text('All tasks marked as complete'),
              ],
            ),
            backgroundColor: Colors.green.shade400,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  Future<void> _handleRestoreAll() async {
    final taskProvider = context.read<TaskProvider>();
    if (taskProvider.completedTasks.isEmpty) return;

    // Show confirmation dialog
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
            const Text('Restore All Tasks'),
          ],
        ),
        content: Text(
          'Are you sure you want to restore all ${taskProvider.completedTasks.length} tasks?',
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
      taskProvider.restoreAllTasks();
      setState(() {
        checkedTasks = List.generate(taskProvider.tasks.length, (_) => false);
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.fill),
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                const Text('All tasks have been restored'),
              ],
            ),
            backgroundColor: AppColors.accent,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  Future<void> _restoreTask(int index) async {
    final taskProvider = context.read<TaskProvider>();
    final task = taskProvider.completedTasks[index];

    // Show confirmation dialog
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
            const Text('Restore Task'),
          ],
        ),
        content: Text(
          'Are you sure you want to restore "${task['name']}"?',
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
      taskProvider.restoreTask(index);
      setState(() {
        checkedTasks.add(false);
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.fill),
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text('Task "${task['name']}" has been restored'),
              ],
            ),
            backgroundColor: AppColors.accent,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  Future<void> _handleDelete(int index, bool isCompleted) async {
    final tasks = isCompleted
        ? context.read<TaskProvider>().completedTasks
        : context.read<TaskProvider>().tasks;
    final task = tasks[index];

    // Show confirmation dialog
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIcons.trash(PhosphorIconsStyle.fill),
              color: Colors.red.shade400,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text('Delete Task'),
          ],
        ),
        content: SizedBox(
          width: 300,
          child: Text(
            'Are you sure you want to delete "${task['name']}"? This action cannot be undone.',
          ),
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
              backgroundColor: Colors.red.shade400,
            ),
            child: const Text('Delete'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        actionsPadding: const EdgeInsets.all(12),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );

    if (confirmed == true) {
      setState(() {
        if (isCompleted) {
          context.read<TaskProvider>().deleteCompletedTask(index);
        } else {
          context.read<TaskProvider>().deleteTask(index);
          checkedTasks.removeAt(index);
        }

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  PhosphorIcons.trash(PhosphorIconsStyle.fill),
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text('Task "${task['name']}" has been deleted'),
              ],
            ),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      });
    }
  }

  Future<void> _handleEdit(int index) async {
    final taskProvider = context.read<TaskProvider>();
    final result = await showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        isEditing: true,
        task: taskProvider.tasks[index],
      ),
    );

    if (result != null) {
      taskProvider.updateTask(index, result);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  PhosphorIcons.pencilSimple(PhosphorIconsStyle.fill),
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text('Task "${result['name']}" has been updated'),
              ],
            ),
            backgroundColor: Colors.blue.shade400,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  bool _filterTask(Map<String, dynamic> task) {
    if (searchQuery.isNotEmpty) {
      final String taskName = task['name'].toLowerCase();
      if (!taskName.contains(searchQuery.toLowerCase())) return false;
    }

    if (selectedPriority != null && selectedPriority != 'all') {
      if (task['priority'] != selectedPriority) return false;
    }

    if (selectedStatus != null && selectedStatus != 'all') {
      if (task['status'] != selectedStatus) return false;
    }

    if (selectedProject != null && selectedProject != 'all') {
      if (task['project'] != selectedProject) return false;
    }

    return true;
  }

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      selectedPriority != null ||
      selectedStatus != null ||
      selectedProject != null;

  void _clearAllFilters() {
    setState(() {
      searchQuery = '';
      searchController.clear();
      selectedPriority = null;
      selectedStatus = null;
      selectedProject = null;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              PhosphorIcons.check(PhosphorIconsStyle.fill),
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            const Text('All filters have been cleared'),
          ],
        ),
        backgroundColor: Colors.green.shade400,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleRestore(int index) async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final task = taskProvider.getDeletedTask(index);

    if (task == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Task not found'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final bool? confirm = await showDialog<bool>(
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
            const Text('Restore Task'),
          ],
        ),
        content: Text(
          'Are you sure you want to restore "${task['name']}"?',
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

    if (confirm == true) {
      try {
        taskProvider.restoreTask(index);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Task "${task['name']}" has been restored'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error restoring task'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
