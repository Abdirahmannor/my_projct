import '../widgets/task_list_item.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/string_extensions.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String? selectedPriority;
  String? selectedStatus;
  String? selectedProject;
  List<bool> checkedTasks = [];
  bool isListView = true;
  int? hoveredIndex;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  // Sample tasks data (empty for now)
  List<Map<String, dynamic>> tasks = [
    {
      'name': 'Complete Math Assignment',
      'description': 'Chapter 5 exercises on calculus',
      'project': 'Mathematics',
      'dueDate': '2024-03-20',
      'priority': 'high',
      'status': 'in progress',
      'completedSubtasks': 3,
      'totalSubtasks': 5,
    },
    {
      'name': 'Study for Physics Test',
      'description': 'Review chapters 3 and 4',
      'project': 'Physics',
      'dueDate': '2024-03-25',
      'priority': 'high',
      'status': 'to do',
      'completedSubtasks': 0,
      'totalSubtasks': 4,
    },
    {
      'name': 'Write Essay',
      'description': 'Research paper on renewable energy',
      'project': 'English',
      'dueDate': '2024-03-15',
      'priority': 'medium',
      'status': 'in progress',
      'completedSubtasks': 2,
      'totalSubtasks': 3,
    },
    {
      'name': 'Practice Programming',
      'description': 'Complete coding exercises',
      'project': 'Computer Science',
      'dueDate': '2024-03-30',
      'priority': 'low',
      'status': 'done',
      'completedSubtasks': 5,
      'totalSubtasks': 5,
    },
  ];

  @override
  void initState() {
    super.initState();
    checkedTasks = List.generate(tasks.length, (_) => false);
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
                      // Add Task Button
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.accent,
                              Color.lerp(
                                      AppColors.accent, Colors.purple, 0.6) ??
                                  AppColors.accent,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              // Add Task Dialog will be implemented next
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Icon(
                                    PhosphorIcons.plus(PhosphorIconsStyle.bold),
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Add Task',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
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
                  const SizedBox(height: 16),
                  // Search and Filters
                  Row(
                    children: [
                      // Search
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).dividerColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Search tasks...',
                              prefixIcon: Icon(
                                PhosphorIcons.magnifyingGlass(
                                    PhosphorIconsStyle.bold),
                                size: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            onChanged: (value) =>
                                setState(() => searchQuery = value),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // View Toggle
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).dividerColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            _buildViewToggleButton(
                              icon: PhosphorIcons.list(PhosphorIconsStyle.bold),
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
            ),
          ),

          // Content section
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor),
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
                          child: Checkbox(
                            value: checkedTasks.every((checked) => checked),
                            onChanged: (value) {
                              setState(() {
                                checkedTasks = List.generate(
                                    tasks.length, (_) => value ?? false);
                              });
                            },
                            tristate: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
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
                          flex: 2,
                          child: Text(
                            'Project',
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
                            'Priority',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).dividerColor),
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
                  // Task list will be implemented next
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return MouseRegion(
                          onEnter: (_) => setState(() => hoveredIndex = index),
                          onExit: (_) => setState(() => hoveredIndex = null),
                          child: TaskListItem(
                            task: tasks[index],
                            isChecked: checkedTasks[index],
                            onCheckChanged: (value) {
                              setState(() {
                                checkedTasks[index] = value ?? false;
                              });
                            },
                            onEdit: () {
                              // Add Task Edit functionality
                            },
                            onDelete: () {
                              // Add Task Delete functionality
                            },
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
}
