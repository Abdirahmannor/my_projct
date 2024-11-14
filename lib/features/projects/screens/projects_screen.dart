import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/add_project_dialog.dart';
import '../widgets/project_list_item.dart';
import '../../../core/utils/string_extensions.dart';
import '../widgets/project_grid_item.dart';
import 'package:fl_chart/fl_chart.dart';

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
  bool _isStatisticsExpanded = true;
  DateTimeRange? _selectedDateRange;
  bool _showChart = false;

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

  void _handleDelete(int index) async {
    final projectName = projects[index]['name'];

    // Show confirmation dialog
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
              'Delete Project',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        content: SizedBox(
          width: 300,
          child: Text(
            'Are you sure you want to delete "$projectName"?',
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
              'Delete',
              style: TextStyle(fontSize: 14),
            ),
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

    // If user confirmed, delete the project
    if (confirm == true) {
      setState(() {
        projects.removeAt(index);
        checkedProjects = List.generate(projects.length, (_) => false);
      });

      _showSuccessMessage(
        message: 'Project "$projectName" has been deleted successfully',
        icon: PhosphorIcons.trash(PhosphorIconsStyle.fill),
      );
    }
  }

  bool _filterProject(int index) {
    final project = projects[index];

    // Date range filter
    if (_selectedDateRange != null) {
      final startDate = _parseDate(project['startDate']);
      final dueDate = _parseDate(project['dueDate']);

      if (!startDate.isAfter(_selectedDateRange!.start) &&
          !dueDate.isBefore(_selectedDateRange!.end)) {
        return false;
      }
    }

    if (searchQuery.isNotEmpty) {
      String projectName = project['name'].toLowerCase();
      if (!projectName.contains(searchQuery.toLowerCase())) return false;
    }

    if (selectedPriority != null && selectedPriority != 'all') {
      if (project['priority'] != selectedPriority) return false;
    }

    if (selectedStatus != null && selectedStatus != 'all') {
      if (project['status'] != selectedStatus) return false;
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
                                      hintText: 'Search projects...',
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

          // Add this after the header section and before the content section
          Container(
            margin: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).cardColor,
                  Color.lerp(Theme.of(context).cardColor, AppColors.accent,
                          0.05) ??
                      Theme.of(context).cardColor,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header with collapse button
                InkWell(
                  onTap: () => setState(() {
                    _isStatisticsExpanded = !_isStatisticsExpanded;
                    if (!_isStatisticsExpanded) {
                      // Show chart animation when collapsed
                      Future.delayed(const Duration(milliseconds: 100), () {
                        setState(() => _showChart = true);
                      });
                    } else {
                      _showChart = false;
                    }
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(
                          PhosphorIcons.chartBar(PhosphorIconsStyle.fill),
                          color: AppColors.accent,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Project Statistics',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const Spacer(),
                        if (_isStatisticsExpanded) ...[
                          TextButton.icon(
                            onPressed: _handleDateRangeSelect,
                            icon: Icon(
                              PhosphorIcons.calendar(PhosphorIconsStyle.bold),
                              size: 18,
                              color: _selectedDateRange != null
                                  ? AppColors.accent
                                  : null,
                            ),
                            label: Text(
                              _selectedDateRange != null
                                  ? '${_selectedDateRange!.start.day} ${_getMonthName(_selectedDateRange!.start.month)} - '
                                      '${_selectedDateRange!.end.day} ${_getMonthName(_selectedDateRange!.end.month)}'
                                  : 'Filter by Date',
                              style: TextStyle(
                                color: _selectedDateRange != null
                                    ? AppColors.accent
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          _buildTimeframeDropdown(),
                        ],
                        const SizedBox(width: 8),
                        Icon(
                          _isStatisticsExpanded
                              ? PhosphorIcons.caretUp(PhosphorIconsStyle.bold)
                              : PhosphorIcons.caretDown(
                                  PhosphorIconsStyle.bold),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                // Expandable content
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: _isStatisticsExpanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Row(
                      children: [
                        _buildEnhancedStatCard(
                          icon: PhosphorIcons.folder(PhosphorIconsStyle.fill),
                          title: 'Total Projects',
                          value: projects.length.toString(),
                          subtitle: 'Active projects',
                          trend: '+2.5%',
                          trendUp: true,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 12),
                        _buildEnhancedStatCard(
                          icon: PhosphorIcons.clockCountdown(
                              PhosphorIconsStyle.fill),
                          title: 'In Progress',
                          value: projects
                              .where((p) => p['status'] == 'in progress')
                              .length
                              .toString(),
                          subtitle: 'Ongoing tasks',
                          trend: '+5.0%',
                          trendUp: true,
                          color: Colors.blue.shade400,
                        ),
                        const SizedBox(width: 12),
                        _buildEnhancedStatCard(
                          icon: PhosphorIcons.checkCircle(
                              PhosphorIconsStyle.fill),
                          title: 'Completed',
                          value: projects
                              .where((p) => p['status'] == 'completed')
                              .length
                              .toString(),
                          subtitle: 'Finished projects',
                          trend: '+12.5%',
                          trendUp: true,
                          color: Colors.green.shade400,
                        ),
                        const SizedBox(width: 12),
                        _buildEnhancedStatCard(
                          icon: PhosphorIcons.warning(PhosphorIconsStyle.fill),
                          title: 'On Hold',
                          value: projects
                              .where((p) => p['status'] == 'on hold')
                              .length
                              .toString(),
                          subtitle: 'Paused projects',
                          trend: '-3.0%',
                          trendUp: false,
                          color: Colors.orange.shade400,
                        ),
                      ],
                    ),
                  ),
                  secondChild: _showChart
                      ? Container(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                          child: Row(
                            children: [
                              // Quick stats in more compact form
                              Expanded(
                                flex: 4,
                                child: Row(
                                  children: [
                                    _buildMiniStat(
                                      value: projects.length.toString(),
                                      label: 'Total',
                                      color: AppColors.accent,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildMiniStat(
                                      value: projects
                                          .where((p) =>
                                              p['status'] == 'in progress')
                                          .length
                                          .toString(),
                                      label: 'Active',
                                      color: Colors.blue.shade400,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildMiniStat(
                                      value: projects
                                          .where(
                                              (p) => p['status'] == 'completed')
                                          .length
                                          .toString(),
                                      label: 'Done',
                                      color: Colors.green.shade400,
                                    ),
                                  ],
                                ),
                              ),
                              // Mini pie chart
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: _buildMiniPieChart(),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(height: 0),
                ),
              ],
            ),
          ),

          // Content section
          Expanded(
            child: Container(
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
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
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
                                ...[
                                  'not started',
                                  'in progress',
                                  'on hold',
                                  'completed'
                                ].map(
                                  (status) => PopupMenuItem(
                                    value: status,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: status == 'not started'
                                                ? Colors.grey.shade400
                                                : status == 'in progress'
                                                    ? Colors.blue.shade400
                                                    : status == 'on hold'
                                                        ? Colors.orange.shade400
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
                  // Project List
                  Expanded(
                    child: !isListView
                        ? GridView.builder(
                            padding: const EdgeInsets.all(12),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 0.85,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
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
                            padding: const EdgeInsets.all(12),
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
                  if (checkedProjects.contains(true))
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        border: Border(
                          bottom:
                              BorderSide(color: Theme.of(context).dividerColor),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${checkedProjects.where((c) => c).length} projects selected',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {
                              // Bulk archive
                            },
                            icon: Icon(
                                PhosphorIcons.archive(PhosphorIconsStyle.bold)),
                            label: const Text('Archive Selected'),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () {
                              // Bulk delete
                            },
                            icon: Icon(
                                PhosphorIcons.trash(PhosphorIconsStyle.bold)),
                            label: const Text('Delete Selected'),
                          ),
                        ],
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

  Widget _buildTimeframeDropdown() {
    return PopupMenuButton<String>(
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
      itemBuilder: (context) => _timeframes.map((timeframe) {
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
          // Here you would typically update your statistics based on the selected timeframe
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
                    color: Theme.of(context).textTheme.bodySmall?.color,
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
          ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.accent,
              iconTheme: const IconThemeData(color: Colors.white),
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        // Update your project filtering logic here
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
                    .where((p) => p['status'] == 'completed')
                    .length
                    .toDouble(),
                color: Colors.green.shade400,
                radius: 8,
                showTitle: false,
              ),
              PieChartSectionData(
                value: projects
                    .where((p) => p['status'] == 'in progress')
                    .length
                    .toDouble(),
                color: Colors.blue.shade400,
                radius: 8,
                showTitle: false,
              ),
              PieChartSectionData(
                value: projects
                    .where((p) => p['status'] == 'on hold')
                    .length
                    .toDouble(),
                color: Colors.orange.shade400,
                radius: 8,
                showTitle: false,
              ),
              PieChartSectionData(
                value: projects
                    .where((p) => p['status'] == 'not started')
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
          '${((projects.where((p) => p['status'] == 'completed').length / projects.length) * 100).toStringAsFixed(0)}%',
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
                    .where((p) => p['priority'] == 'high')
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
                    .where((p) => p['priority'] == 'medium')
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
                    .where((p) => p['priority'] == 'low')
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
                    .where((p) => p['status'] == 'completed')
                    .length
                    .toDouble(),
                color: Colors.green.shade400,
                radius: 5,
                showTitle: false,
              ),
              PieChartSectionData(
                value: projects
                    .where((p) => p['status'] == 'in progress')
                    .length
                    .toDouble(),
                color: Colors.blue.shade400,
                radius: 5,
                showTitle: false,
              ),
              PieChartSectionData(
                value: projects
                    .where((p) => p['status'] == 'on hold')
                    .length
                    .toDouble(),
                color: Colors.orange.shade400,
                radius: 5,
                showTitle: false,
              ),
              PieChartSectionData(
                value: projects
                    .where((p) => p['status'] == 'not started')
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
          '${((projects.where((p) => p['status'] == 'completed').length / projects.length) * 100).toStringAsFixed(0)}%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
        ),
      ],
    );
  }
}
