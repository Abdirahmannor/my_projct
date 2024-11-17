// import 'dart:async'; // Add this import for Timer
// import 'package:flutter/material.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import '../../../core/constants/app_colors.dart';
// import '../widgets/add_project_dialog.dart';
// import '../widgets/project_list_item.dart';
// import '../widgets/project_grid_item.dart';
// import '../../../core/utils/string_extensions.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../models/project.dart';
// import '../services/project_database_service.dart';

// class ProjectListLayout {
//   static const double checkboxWidth = 24.0;
//   static const double iconSpacing = 16.0;
//   static const int nameColumnFlex = 3;
//   static const int dateColumnFlex = 2;
//   static const double tasksWidth = 100.0;
//   static const double priorityWidth = 100.0;
//   static const double statusWidth = 100.0;
//   static const double actionsWidth = 100.0;
//   static const double columnPadding = 12.0;
//   static const double rowHorizontalPadding = 16.0;
//   static const double rowVerticalPadding = 12.0;
// }

// class ProjectsScreen extends StatefulWidget {
//   const ProjectsScreen({super.key});

//   @override
//   State<ProjectsScreen> createState() => _ProjectsScreenState();
// }

// class _ProjectsScreenState extends State<ProjectsScreen> {
//   String? selectedPriority;
//   String? selectedCategory;
//   String? selectedStatus;
//   List<bool> checkedProjects = [];
//   bool showArchived = false;
//   bool showAllProjects = true;
//   bool isListView = true;
//   int? hoveredIndex;
//   TextEditingController searchController = TextEditingController();
//   String searchQuery = '';
//   bool _isLoading = false;
//   String _selectedTimeframe = 'This Month';
//   List<String> _timeframes = [
//     'Today',
//     'This Week',
//     'This Month',
//     'This Quarter',
//     'This Year',
//     'All Time'
//   ];
//   bool _isStatisticsExpanded = false;
//   DateTimeRange? _selectedDateRange;
//   bool _showChart = true;
//   List<Project> archivedProjects = [];
//   List<bool> archivedCheckedProjects = [];
//   bool archivedSelectAll = false;
//   final _projectDatabaseService = ProjectDatabaseService();
//   List<Project> projects = [];
//   final Map<int, String> originalStatuses = {};
//   bool showRecycleBin = false;
//   List<Project> deletedProjects = [];
//   Timer? _cleanupTimer;
//   List<bool> recycleBinCheckedProjects = [];
//   bool recycleBinSelectAll = false;
//   int _newlyDeletedCount = 0;
//   bool _hasVisitedRecycleBin = false;
//   bool _isPriorityHeaderHovered = false;
//   bool _isStatusHeaderHovered = false;
//   int _newlyArchivedCount = 0;
//   int _newlyActiveCount = 0;
//   bool _hasVisitedArchived = false;
//   bool _hasVisitedActive = false;
//   bool _isProjectNameHeaderHovered = false;
//   String? _selectedNameSort; // null: no sort, 'asc': A-Z, 'desc': Z-A
//   bool _isStartDateHeaderHovered = false;
//   bool _isDueDateHeaderHovered = false;
//   String?
//       _selectedStartDateSort; // null: no sort, 'asc': oldest first, 'desc': newest first
//   String? _selectedDueDateSort;
//   bool _isTasksHeaderHovered = false;
//   String?
//       _selectedTasksSort; // null: no sort, 'most': most tasks first, 'least': least tasks first, 'completed': most completed %, 'incomplete': least completed %

//   @override
//   void initState() {
//     super.initState();
//     _loadProjects();
//     _loadDeletedProjects();
//     _cleanupTimer = Timer.periodic(const Duration(days: 1), (_) {
//       _projectDatabaseService.cleanupOldProjects();
//     });
//   }

//   @override
//   void dispose() {
//     _cleanupTimer?.cancel();
//     super.dispose();
//   }

//   Future<void> _loadProjects() async {
//     try {
//       final loadedProjects = await _projectDatabaseService.getAllProjects();
//       setState(() {
//         // Preserve isPinned state when filtering projects
//         projects = loadedProjects
//             .where((p) => p.status != 'completed')
//             .map((p) => Project(
//                   id: p.id,
//                   name: p.name,
//                   description: p.description,
//                   startDate: p.startDate,
//                   dueDate: p.dueDate,
//                   tasks: p.tasks,
//                   completedTasks: p.completedTasks,
//                   priority: p.priority,
//                   status: p.status,
//                   category: p.category,
//                   isPinned: p.isPinned, // Explicitly preserve pin state
//                   archivedDate: p.archivedDate,
//                   originalStatus: p.originalStatus,
//                   deletedAt: p.deletedAt,
//                   lastRestoredDate: p.lastRestoredDate,
//                 ))
//             .toList();

//         archivedProjects = loadedProjects
//             .where((p) => p.status == 'completed')
//             .map((p) => Project(
//                   // Same mapping for archived projects
//                   id: p.id,
//                   name: p.name,
//                   description: p.description,
//                   startDate: p.startDate,
//                   dueDate: p.dueDate,
//                   tasks: p.tasks,
//                   completedTasks: p.completedTasks,
//                   priority: p.priority,
//                   status: p.status,
//                   category: p.category,
//                   isPinned: p.isPinned, // Explicitly preserve pin state
//                   archivedDate: p.archivedDate,
//                   originalStatus: p.originalStatus,
//                   deletedAt: p.deletedAt,
//                   lastRestoredDate: p.lastRestoredDate,
//                 ))
//             .toList();

//         // Initialize checkbox lists
//         checkedProjects = List.generate(projects.length, (_) => false);
//         archivedCheckedProjects =
//             List.generate(archivedProjects.length, (_) => false);
//         recycleBinCheckedProjects =
//             List.generate(deletedProjects.length, (_) => false);
//       });
//     } catch (e) {
//       print('Error loading projects: $e');
//     }
//   }

//   Future<void> _loadDeletedProjects() async {
//     try {
//       final loadedProjects = await _projectDatabaseService.getDeletedProjects();
//       setState(() {
//         deletedProjects = loadedProjects;
//         recycleBinCheckedProjects =
//             List.generate(loadedProjects.length, (_) => false);
//         recycleBinSelectAll = false;
//       });
//     } catch (e) {
//       print('Error loading deleted projects: $e');
//     }
//   }

//   void _handleAddProject() async {
//     final result = await showDialog(
//       context: context,
//       builder: (context) => const AddProjectDialog(),
//     );

//     if (result != null && result is Project) {
//       try {
//         // Only save to database, don't add to local state
//         await _projectDatabaseService.addProject(result);
//         // Reload all projects from database
//         await _loadProjects();

//         _showSuccessMessage(
//           message: 'Project "${result.name}" has been created successfully',
//           icon: PhosphorIcons.folderPlus(PhosphorIconsStyle.fill),
//         );
//       } catch (e) {
//         _showError('Failed to save project: $e');
//       }
//     }
//   }

//   void _handleEdit(int index) async {
//     final result = await showDialog(
//       context: context,
//       builder: (context) => AddProjectDialog(
//         isEditing: true,
//         project: projects[index],
//       ),
//     );

//     if (result != null && result is Project) {
//       try {
//         // Create updated project with the same ID
//         final updatedProject = Project(
//           id: projects[index].id, // Keep the same ID
//           name: result.name,
//           description: result.description,
//           startDate: result.startDate,
//           dueDate: result.dueDate,
//           tasks: result.tasks,
//           completedTasks: result.completedTasks,
//           priority: result.priority,
//           status: result.status,
//           category: result.category,
//         );

//         // Save to database
//         await _projectDatabaseService.updateProject(updatedProject);

//         // Update local state
//         setState(() {
//           projects[index] = updatedProject;
//         });

//         _showSuccessMessage(
//           message: 'Project "${result.name}" has been updated successfully',
//           icon: PhosphorIcons.pencilSimple(PhosphorIconsStyle.fill),
//         );
//       } catch (e) {
//         _showError('Failed to update project: $e');
//       }
//     }
//   }

//   void _handleDelete(int index) async {
//     // Get the correct project based on current view
//     final project = showArchived ? archivedProjects[index] : projects[index];

//     final projectName = project.name;
//     final projectId = project.id;

//     // Show confirmation dialog
//     final bool? confirm = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               PhosphorIcons.trash(PhosphorIconsStyle.fill),
//               color: Colors.red.shade400,
//               size: 20,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               showArchived ? 'Move to Recycle Bin' : 'Delete Project',
//               style: const TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//         content: Text(
//           'Are you sure you want to move "$projectName" to recycle bin?',
//           style: const TextStyle(fontSize: 14),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                 color: Theme.of(context).textTheme.bodyLarge?.color,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           FilledButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: FilledButton.styleFrom(
//               backgroundColor: Colors.red.shade400,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             ),
//             child: const Text(
//               'Move to Recycle Bin',
//               style: TextStyle(fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true && projectId != null) {
//       try {
//         if (showArchived) {
//           // Move archived project to recycle bin
//           await _projectDatabaseService.moveArchivedToRecycleBin(project);
//           setState(() {
//             archivedProjects.removeAt(index);
//             archivedCheckedProjects =
//                 List.generate(archivedProjects.length, (_) => false);
//             _newlyDeletedCount++;
//             _hasVisitedRecycleBin = false;
//           });
//         } else {
//           // Move normal project to recycle bin
//           await _projectDatabaseService.moveToRecycleBin(project);
//           setState(() {
//             projects.removeAt(index);
//             checkedProjects = List.generate(projects.length, (_) => false);
//             _newlyDeletedCount++;
//             _hasVisitedRecycleBin = false;
//           });
//         }

//         _showSuccessMessage(
//           message: 'Project "$projectName" has been moved to recycle bin',
//           icon: PhosphorIcons.trash(PhosphorIconsStyle.fill),
//         );

//         // Reload deleted projects
//         await _loadDeletedProjects();
//       } catch (e) {
//         _showError('Failed to move project to recycle bin: $e');
//       }
//     }
//   }

//   bool _filterProject(int index) {
//     // First check if the index is valid for the current list
//     if (showArchived && index >= archivedProjects.length) return false;
//     if (showRecycleBin && index >= deletedProjects.length) return false;
//     if (!showArchived && !showRecycleBin && index >= projects.length)
//       return false;

//     // Get the correct project based on current view
//     final project = showArchived
//         ? archivedProjects[index]
//         : showRecycleBin
//             ? deletedProjects[index]
//             : projects[index];

//     // Search filter
//     if (searchQuery.isNotEmpty) {
//       final String projectName = project.name.toLowerCase();
//       final String projectDescription =
//           (project.description ?? '').toLowerCase();
//       final String query = searchQuery.toLowerCase();
//       if (!projectName.contains(query) && !projectDescription.contains(query)) {
//         return false;
//       }
//     }

//     // Priority filter
//     if (selectedPriority != null && selectedPriority != 'all') {
//       if (project.priority != selectedPriority) {
//         return false;
//       }
//     }

//     // Date range filter
//     if (_selectedDateRange != null) {
//       if (project.startDate.isBefore(_selectedDateRange!.start) ||
//           project.dueDate.isAfter(_selectedDateRange!.end)) {
//         return false;
//       }
//     }

//     // Status filter
//     if (selectedStatus != null && selectedStatus != 'all') {
//       if (project.status != selectedStatus) {
//         return false;
//       }
//     }

//     return true;
//   }

//   void _toggleAllProjects(bool? value) {
//     setState(() {
//       checkedProjects = List.generate(projects.length, (_) => value ?? false);
//       for (int i = 0; i < projects.length; i++) {
//         if (value == true) {
//           // Store original status and create new project
//           originalStatuses[i] = projects[i].status;
//           projects[i] = Project(
//             id: projects[i].id,
//             name: projects[i].name,
//             description: projects[i].description,
//             startDate: projects[i].startDate,
//             dueDate: projects[i].dueDate,
//             tasks: projects[i].tasks,
//             completedTasks: projects[i].tasks, // Set to total tasks
//             priority: projects[i].priority,
//             status: 'completed',
//             category: projects[i].category,
//           );
//         } else {
//           // Restore original status
//           projects[i] = Project(
//             id: projects[i].id,
//             name: projects[i].name,
//             description: projects[i].description,
//             startDate: projects[i].startDate,
//             dueDate: projects[i].dueDate,
//             tasks: projects[i].tasks,
//             completedTasks: (projects[i].tasks * 0.6).round(),
//             priority: projects[i].priority,
//             status: originalStatuses[i] ?? 'in progress',
//             category: projects[i].category,
//           );
//         }
//       }
//     });
//   }

//   void _handleCheckboxChange(int index, bool? value) {
//     setState(() {
//       checkedProjects[index] = value ?? false;
//     });
//   }

//   void _handleRestore(int index) async {
//     final project =
//         showArchived ? archivedProjects[index] : deletedProjects[index];

//     final bool? confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(
//               PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.fill),
//               color: AppColors.accent,
//               size: 24,
//             ),
//             const SizedBox(width: 8),
//             const Text('Restore Project'),
//           ],
//         ),
//         content: Text(
//           'Are you sure you want to restore "${project.name}"?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                 color: Theme.of(context).textTheme.bodyLarge?.color,
//               ),
//             ),
//           ),
//           FilledButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: FilledButton.styleFrom(
//               backgroundColor: AppColors.accent,
//             ),
//             child: const Text('Restore'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       try {
//         if (showArchived) {
//           // Handle archived project restoration to active projects
//           final restoredProject = Project(
//             id: project.id,
//             name: project.name,
//             description: project.description,
//             startDate: project.startDate,
//             dueDate: project.dueDate,
//             tasks: project.tasks,
//             completedTasks: project.completedTasks,
//             priority: project.priority,
//             status: project.originalStatus ??
//                 'in progress', // Use original status or fallback
//             category: project.category,
//           );

//           await _projectDatabaseService.updateProject(restoredProject);

//           // Update the counter before updating the lists
//           setState(() {
//             _newlyActiveCount++;
//             _hasVisitedActive = false;
//           });

//           // Then update the lists
//           setState(() {
//             projects.add(restoredProject);
//             archivedProjects.removeAt(index);
//             checkedProjects = List.generate(projects.length, (_) => false);
//             archivedCheckedProjects =
//                 List.generate(archivedProjects.length, (_) => false);
//             archivedSelectAll = false;
//           });
//         } else {
//           // Restore from recycle bin to active projects
//           if (project.id != null) {
//             await _projectDatabaseService.restoreFromRecycleBin(project.id!);
//             setState(() {
//               _newlyActiveCount++;
//               _hasVisitedActive = false;
//             });
//             await _loadProjects();
//             await _loadDeletedProjects();
//           }
//         }

//         _showSuccessMessage(
//           message: 'Project has been restored',
//           icon: PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.fill),
//         );
//       } catch (e) {
//         _showError('Failed to restore project: $e');
//       }
//     }
//   }

//   void _showSuccessMessage({
//     required String message,
//     required IconData icon,
//   }) {
//     // Determine color based on the icon/action
//     Color backgroundColor;
//     if (icon == PhosphorIcons.checkCircle(PhosphorIconsStyle.fill)) {
//       backgroundColor = Colors.green.shade400; // Complete actions
//     } else if (icon == PhosphorIcons.trash(PhosphorIconsStyle.fill)) {
//       backgroundColor = Colors.red.shade400; // Delete actions
//     } else if (icon ==
//         PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.fill)) {
//       backgroundColor = AppColors.accent; // Restore actions
//     } else if (icon == PhosphorIcons.funnel(PhosphorIconsStyle.fill)) {
//       backgroundColor = Colors.purple.shade400; // Filter actions
//     } else {
//       backgroundColor = AppColors.accent; // Default color
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 icon,
//                 color: Colors.white,
//                 size: 18,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Text(
//               message,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: backgroundColor,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 4),
//         action: SnackBarAction(
//           label: 'Dismiss',
//           textColor: Colors.white,
//           onPressed: () {
//             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//           },
//         ),
//       ),
//     );
//   }

//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 PhosphorIcons.warning(PhosphorIconsStyle.fill),
//                 color: Colors.white,
//                 size: 18,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Text(
//               message,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.red.shade400,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 4),
//         action: SnackBarAction(
//           label: 'Dismiss',
//           textColor: Colors.white,
//           onPressed: () {
//             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//           },
//         ),
//       ),
//     );
//   }

//   // Add this getter to check if any filters are active
//   bool get hasActiveFilters =>
//       searchQuery.isNotEmpty ||
//       selectedPriority != null ||
//       selectedStatus != null ||
//       selectedCategory != null ||
//       _selectedDateRange != null ||
//       _selectedNameSort != null ||
//       _selectedStartDateSort != null ||
//       _selectedDueDateSort != null ||
//       _selectedTasksSort != null; // Add this line

//   // Add this method to clear all filters
//   void _clearAllFilters() {
//     setState(() {
//       searchQuery = '';
//       searchController.clear();
//       selectedPriority = null;
//       selectedStatus = null;
//       selectedCategory = null;
//       _selectedDateRange = null;
//       _selectedNameSort = null;
//       _selectedStartDateSort = null;
//       _selectedDueDateSort = null;
//       _selectedTasksSort = null; // Add this line
//     });

//     _showSuccessMessage(
//       message: 'All filters have been cleared',
//       icon: PhosphorIcons.funnel(PhosphorIconsStyle.fill),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         child: Column(
//           children: [
//             // Header section
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//                 border: Border(
//                   bottom: BorderSide(
//                     color: Theme.of(context).dividerColor,
//                     width: 1,
//                   ),
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           // Added this Row to group title and refresh button
//                           children: [
//                             Text(
//                               'Projects',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headlineMedium
//                                   ?.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                             ),
//                             const SizedBox(width: 12),
//                             IconButton(
//                               onPressed: () async {
//                                 setState(() {
//                                   _isLoading = true;
//                                 });

//                                 // Store current filter states
//                                 final currentFilters = {
//                                   'nameSort': _selectedNameSort,
//                                   'startDateSort': _selectedStartDateSort,
//                                   'dueDateSort': _selectedDueDateSort,
//                                   'tasksSort': _selectedTasksSort,
//                                   'priority': selectedPriority,
//                                   'status': selectedStatus,
//                                   'category': selectedCategory,
//                                   'dateRange': _selectedDateRange,
//                                   'search': searchQuery,
//                                 };

//                                 // Refresh data
//                                 await _loadProjects();
//                                 await _loadDeletedProjects();

//                                 // Restore filter states
//                                 setState(() {
//                                   _isLoading = false;
//                                   _selectedNameSort =
//                                       currentFilters['nameSort'] as String?;
//                                   _selectedStartDateSort =
//                                       currentFilters['startDateSort']
//                                           as String?;
//                                   _selectedDueDateSort =
//                                       currentFilters['dueDateSort'] as String?;
//                                   _selectedTasksSort =
//                                       currentFilters['tasksSort'] as String?;
//                                   selectedPriority =
//                                       currentFilters['priority'] as String?;
//                                   selectedStatus =
//                                       currentFilters['status'] as String?;
//                                   selectedCategory =
//                                       currentFilters['category'] as String?;
//                                   _selectedDateRange =
//                                       currentFilters['dateRange']
//                                           as DateTimeRange?;
//                                   searchQuery =
//                                       currentFilters['search'] as String;
//                                 });

//                                 _showSuccessMessage(
//                                   message: 'Projects refreshed',
//                                   icon: PhosphorIcons.arrowClockwise(
//                                       PhosphorIconsStyle.fill),
//                                 );
//                               },
//                               icon: _isLoading
//                                   ? SizedBox(
//                                       width: 20,
//                                       height: 20,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                         color: AppColors.accent,
//                                       ),
//                                     )
//                                   : Icon(
//                                       PhosphorIcons.arrowClockwise(
//                                           PhosphorIconsStyle.bold),
//                                       size: 20,
//                                       color: AppColors.accent,
//                                     ),
//                               tooltip: 'Refresh projects',
//                               style: IconButton.styleFrom(
//                                 padding: const EdgeInsets.all(8),
//                                 backgroundColor:
//                                     AppColors.accent.withOpacity(0.1),
//                               ),
//                             ),
//                           ],
//                         ),
//                         _buildAddProjectButton(),
//                       ],
//                     ),
//                     const SizedBox(height: 24),
//                     // Filter bar
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         _buildFilterButtons(),
//                         _buildRightSideControls(),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Content section
//             Expanded(
//               child: _buildProjectsList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddProjectButton() {
//     return Container(
//       height: 48,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             AppColors.accent,
//             Color.lerp(AppColors.accent, Colors.purple, 0.6) ??
//                 AppColors.accent,
//           ],
//         ),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.accent.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: _handleAddProject,
//           borderRadius: BorderRadius.circular(12),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(
//                     PhosphorIcons.plus(PhosphorIconsStyle.bold),
//                     size: 18,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Text(
//                   'Add Project',
//                   style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                       ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterButtons() {
//     return Row(
//       children: [
//         _buildFilterButton(
//           'Active', // Shortened from 'Active Projects'
//           PhosphorIcons.playCircle(PhosphorIconsStyle.bold),
//           showAllProjects,
//           () => setState(() {
//             showAllProjects = true;
//             showArchived = false;
//             showRecycleBin = false;
//             _hasVisitedActive = true;
//             _newlyActiveCount = 0;
//           }),
//           tooltip: 'Show active projects', // Keep full description in tooltip
//           badge: !_hasVisitedActive && _newlyActiveCount > 0
//               ? '$_newlyActiveCount'
//               : null,
//         ),
//         const SizedBox(width: 8),
//         _buildFilterButton(
//           'Archived', // Already short enough
//           PhosphorIcons.archive(PhosphorIconsStyle.bold),
//           showArchived,
//           () => setState(() {
//             showArchived = true;
//             showAllProjects = false;
//             showRecycleBin = false;
//             _hasVisitedArchived = true;
//             _newlyArchivedCount = 0;
//           }),
//           tooltip: 'Show completed projects',
//           badge: !_hasVisitedArchived && _newlyArchivedCount > 0
//               ? '$_newlyArchivedCount'
//               : null,
//         ),
//         const SizedBox(width: 8),
//         _buildFilterButton(
//           'Recycle Bin', // Keep this as is since it's a distinct term
//           PhosphorIcons.trash(PhosphorIconsStyle.bold),
//           showRecycleBin,
//           () {
//             setState(() {
//               showRecycleBin = true;
//               showAllProjects = false;
//               showArchived = false;
//               _hasVisitedRecycleBin = true;
//               _newlyDeletedCount = 0;
//             });
//           },
//           tooltip: 'Show deleted projects',
//           badge: !_hasVisitedRecycleBin && _newlyDeletedCount > 0
//               ? '$_newlyDeletedCount'
//               : null,
//         ),
//       ],
//     );
//   }

//   Widget _buildFilterButton(
//     String label,
//     IconData icon,
//     bool isActive,
//     VoidCallback onPressed, {
//     String? tooltip,
//     String? badge,
//   }) {
//     return InkWell(
//       onTap: onPressed,
//       child: Tooltip(
//         message: tooltip ?? label,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           decoration: BoxDecoration(
//             color: isActive
//                 ? AppColors.accent.withOpacity(0.1)
//                 : Theme.of(context).cardColor,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: isActive ? AppColors.accent : Colors.transparent,
//               width: 1,
//             ),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 18, color: isActive ? AppColors.accent : null),
//               const SizedBox(width: 8),
//               Text(
//                 label,
//                 style: TextStyle(color: isActive ? AppColors.accent : null),
//               ),
//               if (badge != null) ...[
//                 const SizedBox(width: 8),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: AppColors.accent,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     badge,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 10,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRightSideControls() {
//     return Row(
//       children: [
//         // Action buttons for selected projects
//         if (showAllProjects && checkedProjects.contains(true)) ...[
//           FilledButton.icon(
//             onPressed: _handleCompleteSelected,
//             style: FilledButton.styleFrom(
//               backgroundColor: AppColors
//                   .accent, // Changed from Colors.green.shade400 to AppColors.accent
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//               minimumSize: const Size(0, 36),
//               textStyle: const TextStyle(fontSize: 13),
//             ),
//             icon: Icon(
//               PhosphorIcons.checkCircle(PhosphorIconsStyle.bold),
//               size: 16,
//               color: Colors.white,
//             ),
//             label: const Text('Complete'),
//           ),
//           const SizedBox(width: 6),
//           FilledButton.icon(
//             onPressed: _handleDeleteSelected,
//             style: FilledButton.styleFrom(
//               backgroundColor: Colors.red.shade400,
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 10, vertical: 0), // Even smaller padding
//               minimumSize: const Size(0, 36),
//               textStyle: const TextStyle(fontSize: 13),
//             ),
//             icon: Icon(
//               PhosphorIcons.trash(PhosphorIconsStyle.bold),
//               size: 16,
//               color: Colors.white,
//             ),
//             label: const Text('Delete'), // Shortened text
//           ),
//           const SizedBox(width: 12),
//         ],
//         // Add Archived view buttons
//         if (showArchived && archivedCheckedProjects.contains(true)) ...[
//           FilledButton.icon(
//             onPressed: _handleRestoreSelectedArchived,
//             style: FilledButton.styleFrom(
//               backgroundColor: AppColors.accent,
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//               minimumSize: const Size(0, 36),
//               textStyle: const TextStyle(fontSize: 13),
//             ),
//             icon: Icon(
//               PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.bold),
//               size: 16,
//               color: Colors.white,
//             ),
//             label: const Text('Restore'), // Shortened text
//           ),
//           const SizedBox(width: 6),
//           FilledButton.icon(
//             onPressed: _handleDeleteSelectedArchived,
//             style: FilledButton.styleFrom(
//               backgroundColor: Colors.red.shade400,
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//               minimumSize: const Size(0, 36),
//               textStyle: const TextStyle(fontSize: 13),
//             ),
//             icon: Icon(
//               PhosphorIcons.trash(PhosphorIconsStyle.bold),
//               size: 16,
//               color: Colors.white,
//             ),
//             label: const Text('Delete'), // Shortened text
//           ),
//           const SizedBox(width: 12),
//         ],
//         // Add Recycle Bin view buttons
//         if (showRecycleBin && recycleBinCheckedProjects.contains(true)) ...[
//           FilledButton.icon(
//             onPressed: _handleRestoreSelected,
//             style: FilledButton.styleFrom(
//               backgroundColor: AppColors.accent,
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//               minimumSize: const Size(0, 36),
//               textStyle: const TextStyle(fontSize: 13),
//             ),
//             icon: Icon(
//               PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.bold),
//               size: 16,
//               color: Colors.white,
//             ),
//             label: const Text('Restore'), // Shortened text
//           ),
//           const SizedBox(width: 6),
//           FilledButton.icon(
//             onPressed: _handlePermanentlyDeleteSelected,
//             style: FilledButton.styleFrom(
//               backgroundColor: Colors.red.shade400,
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//               minimumSize: const Size(0, 36),
//               textStyle: const TextStyle(fontSize: 13),
//             ),
//             icon: Icon(
//               PhosphorIcons.trash(PhosphorIconsStyle.bold),
//               size: 16,
//               color: Colors.white,
//             ),
//             label: const Text('Delete'), // Shortened text
//           ),
//           const SizedBox(width: 12),
//         ],
//         // Rest of your existing controls (Search, Filters, etc.)
//         if (hasActiveFilters) ...[
//           Container(
//             height: 40,
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Colors.red.shade300,
//               ),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: TextButton.icon(
//               onPressed: _clearAllFilters,
//               icon: Icon(
//                 PhosphorIcons.funnel(PhosphorIconsStyle.bold),
//                 size: 18,
//                 color: Colors.red.shade400,
//               ),
//               label: Text(
//                 'Clear Filters',
//                 style: TextStyle(
//                   color: Colors.red.shade400,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//         ],
//         // Search Bar
//         Container(
//           width: 200, // Reduced from 240 to 200
//           height: 40,
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: Theme.of(context).dividerColor,
//               width: 1.5,
//             ),
//             borderRadius: BorderRadius.circular(8),
//             color: Theme.of(context).cardColor,
//           ),
//           child: Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 8), // Reduced from 12 to 8
//                 child: Icon(
//                   PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
//                   size: 16, // Reduced from 18 to 16
//                   color: Theme.of(context).hintColor,
//                 ),
//               ),
//               const SizedBox(width: 4), // Reduced from 8 to 4
//               Expanded(
//                 child: TextFormField(
//                   controller: searchController,
//                   onChanged: (value) {
//                     setState(() {
//                       searchQuery = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     hintText: 'Search projects...',
//                     hintStyle: TextStyle(
//                       color: Theme.of(context).hintColor,
//                     ),
//                     border: InputBorder.none,
//                     enabledBorder: InputBorder.none,
//                     focusedBorder: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(vertical: 8),
//                     isDense: true,
//                   ),
//                 ),
//               ),
//               if (searchQuery.isNotEmpty)
//                 IconButton(
//                   icon: Icon(
//                     PhosphorIcons.x(PhosphorIconsStyle.bold),
//                     size: 18,
//                     color: Theme.of(context).hintColor,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       searchQuery = '';
//                       searchController.clear();
//                     });
//                   },
//                   padding: EdgeInsets.zero,
//                   constraints: const BoxConstraints(
//                     minWidth: 32,
//                     minHeight: 32,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 8),
//         // Category Filter
//         Container(
//           height: 40,
//           padding:
//               const EdgeInsets.symmetric(horizontal: 8), // Reduced from 12 to 8
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: Theme.of(context).dividerColor,
//             ),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: PopupMenuButton<String>(
//             offset: const Offset(0, 40),
//             tooltip: 'Filter by Category', // Add tooltip for better UX
//             child: Row(
//               mainAxisSize: MainAxisSize.min, // Make row as small as possible
//               children: [
//                 Icon(
//                   PhosphorIcons.folder(PhosphorIconsStyle.bold),
//                   size: 16, // Reduced from 18 to 16
//                   color: selectedCategory != null ? AppColors.accent : null,
//                 ),
//                 const SizedBox(width: 4), // Reduced from 8 to 4
//                 Icon(
//                   PhosphorIcons.caretDown(PhosphorIconsStyle.bold),
//                   size: 14,
//                   color: selectedCategory != null ? AppColors.accent : null,
//                 ),
//               ],
//             ),
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 value: 'all',
//                 child: Row(
//                   children: [
//                     Icon(
//                       PhosphorIcons.folder(PhosphorIconsStyle.bold),
//                       size: 16,
//                       color: selectedCategory == null ? AppColors.accent : null,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       'All Categories',
//                       style: TextStyle(
//                         color:
//                             selectedCategory == null ? AppColors.accent : null,
//                         fontWeight:
//                             selectedCategory == null ? FontWeight.w600 : null,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const PopupMenuDivider(),
//               ...{
//                 'school': (
//                   PhosphorIcons.graduationCap(PhosphorIconsStyle.fill),
//                   AppColors.accent
//                 ),
//                 'personal': (
//                   PhosphorIcons.user(PhosphorIconsStyle.fill),
//                   Colors.purple.shade400
//                 ),
//                 'work': (
//                   PhosphorIcons.briefcase(PhosphorIconsStyle.fill),
//                   Colors.blue.shade400
//                 ),
//                 'online work': (
//                   PhosphorIcons.globe(PhosphorIconsStyle.fill),
//                   Colors.green.shade400
//                 ),
//                 'other': (
//                   PhosphorIcons.folder(PhosphorIconsStyle.fill),
//                   Colors.grey.shade400
//                 ),
//               }.entries.map(
//                     (entry) => PopupMenuItem(
//                       value: entry.key,
//                       child: Row(
//                         children: [
//                           Icon(entry.value.$1, size: 16, color: entry.value.$2),
//                           const SizedBox(width: 8),
//                           Text(entry.key.capitalize()),
//                         ],
//                       ),
//                     ),
//                   ),
//             ],
//             onSelected: (value) {
//               setState(() {
//                 selectedCategory = value == 'all' ? null : value;
//               });
//             },
//           ),
//         ),
//         const SizedBox(width: 8),
//         // View Toggle (moved to the end)
//         Container(
//           height: 40,
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: Theme.of(context).dividerColor,
//             ),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Row(
//             children: [
//               _buildViewToggleButton(
//                 icon: PhosphorIcons.list(PhosphorIconsStyle.bold),
//                 isActive: isListView,
//                 onPressed: () => setState(() => isListView = true),
//               ),
//               Container(
//                 width: 1,
//                 height: 20,
//                 color: Theme.of(context).dividerColor,
//               ),
//               _buildViewToggleButton(
//                 icon: PhosphorIcons.squaresFour(PhosphorIconsStyle.bold),
//                 isActive: !isListView,
//                 onPressed: () => setState(() => isListView = false),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildViewToggleButton({
//     required IconData icon,
//     required bool isActive,
//     required VoidCallback onPressed,
//   }) {
//     return Tooltip(
//       message: icon == PhosphorIcons.list(PhosphorIconsStyle.bold)
//           ? 'List View'
//           : 'Grid View',
//       child: InkWell(
//         onTap: onPressed,
//         child: Container(
//           width: 40,
//           height: 40,
//           color: isActive ? AppColors.accent.withOpacity(0.1) : null,
//           child: Icon(
//             icon,
//             size: 16,
//             color: isActive ? AppColors.accent : null,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTimeframeDropdown() {
//     return PopupMenuButton<String>(
//       initialValue: _selectedTimeframe,
//       offset: const Offset(0, 40),
//       itemBuilder: (BuildContext context) => _timeframes.map((timeframe) {
//         return PopupMenuItem<String>(
//           value: timeframe,
//           child: Row(
//             children: [
//               Icon(
//                 timeframe == _selectedTimeframe
//                     ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill)
//                     : PhosphorIcons.circle(PhosphorIconsStyle.regular),
//                 size: 16,
//                 color:
//                     timeframe == _selectedTimeframe ? AppColors.accent : null,
//               ),
//               const SizedBox(width: 8),
//               Text(timeframe),
//             ],
//           ),
//         );
//       }).toList(),
//       onSelected: (String value) {
//         setState(() {
//           _selectedTimeframe = value;
//           _updateStatistics(value);
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: Theme.of(context).dividerColor),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               PhosphorIcons.calendar(PhosphorIconsStyle.bold),
//               size: 16,
//               color: Theme.of(context).textTheme.bodyMedium?.color,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               _selectedTimeframe,
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//             const SizedBox(width: 8),
//             Icon(
//               PhosphorIcons.caretDown(PhosphorIconsStyle.bold),
//               size: 16,
//               color: Theme.of(context).textTheme.bodyMedium?.color,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _updateStatistics(String timeframe) {
//     // In a real application, you would fetch and update statistics based on the timeframe
//     // For now, we'll just print the selected timeframe
//     print('Selected timeframe: $timeframe');
//     // You would typically make an API call or filter your data here
//   }

//   Widget _buildEnhancedStatCard({
//     required IconData icon,
//     required String title,
//     required String value,
//     required String subtitle,
//     required String trend,
//     required bool trendUp,
//     required Color color,
//   }) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Theme.of(context).dividerColor),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(icon, color: color, size: 18),
//                 ),
//                 const Spacer(),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                   decoration: BoxDecoration(
//                     color:
//                         (trendUp ? Colors.green : Colors.red).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         trendUp
//                             ? PhosphorIcons.trendUp(PhosphorIconsStyle.fill)
//                             : PhosphorIcons.trendDown(PhosphorIconsStyle.fill),
//                         size: 12,
//                         color: trendUp ? Colors.green : Colors.red,
//                       ),
//                       const SizedBox(width: 3),
//                       Text(
//                         trend,
//                         style: TextStyle(
//                           color: trendUp ? Colors.green : Colors.red,
//                           fontSize: 11,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Text(
//               value,
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               title,
//               style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     color: Theme.of(context)
//                         .textTheme
//                         .bodySmall
//                         ?.color
//                         ?.withOpacity(0.7),
//                     fontSize: 11,
//                   ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               subtitle,
//               style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     color: Theme.of(context)
//                         .textTheme
//                         .bodySmall
//                         ?.color
//                         ?.withOpacity(0.7),
//                     fontSize: 11,
//                   ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleDateRangeSelect() async {
//     final DateTimeRange? picked = await showDateRangePicker(
//         context: context,
//         firstDate: DateTime(2000),
//         lastDate: DateTime(2100),
//         initialDateRange: _selectedDateRange ??
//             DateTimeRange(
//               start: DateTime.now(),
//               end: DateTime.now().add(const Duration(days: 7)),
//             ));

//     if (picked != null) {
//       setState(() {
//         _selectedDateRange = picked;
//         _filterProjects();
//       });
//     }
//   }

//   DateTime _parseDate(String date) {
//     final parts = date.split(' ');
//     final day = int.parse(parts[0]);
//     final month = _getMonthFromAbbr(parts[1].replaceAll(',', ''));
//     final year = int.parse(parts[2]);
//     return DateTime(year, month, day);
//   }

//   int _getMonthFromAbbr(String monthAbbr) {
//     const months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec'
//     ];
//     return months.indexOf(monthAbbr) + 1;
//   }

//   void _filterProjects() {
//     // Implement your filtering logic here
//     // For example, you can filter projects based on the selected date range
//     // and other filters
//   }

//   String _getMonthName(int month) {
//     const months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec'
//     ];
//     return months[month - 1];
//   }

//   Widget _buildProjectsPieChart() {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         PieChart(
//           PieChartData(
//             sectionsSpace: 0,
//             centerSpaceRadius: 20,
//             sections: [
//               PieChartSectionData(
//                 value: projects
//                     .where((p) => p.status == 'completed')
//                     .length
//                     .toDouble(),
//                 color: Colors.green.shade400,
//                 radius: 8,
//                 showTitle: false,
//               ),
//               PieChartSectionData(
//                 value: projects
//                     .where((p) => p.status == 'in progress')
//                     .length
//                     .toDouble(),
//                 color: Colors.blue.shade400,
//                 radius: 8,
//                 showTitle: false,
//               ),
//               PieChartSectionData(
//                 value: projects
//                     .where((p) => p.status == 'on hold')
//                     .length
//                     .toDouble(),
//                 color: Colors.orange.shade400,
//                 radius: 8,
//                 showTitle: false,
//               ),
//               PieChartSectionData(
//                 value: projects
//                     .where((p) => p.status == 'not started')
//                     .length
//                     .toDouble(),
//                 color: Colors.grey.shade400,
//                 radius: 8,
//                 showTitle: false,
//               ),
//             ],
//           ),
//         ),
//         Text(
//           '${((projects.where((p) => p.status == 'completed').length / projects.length) * 100).toStringAsFixed(0)}%',
//           style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//         ),
//       ],
//     );
//   }

//   Widget _buildProjectsBarChart() {
//     return BarChart(
//       BarChartData(
//         alignment: BarChartAlignment.spaceAround,
//         maxY: projects.length.toDouble(),
//         barTouchData: BarTouchData(enabled: false),
//         titlesData: FlTitlesData(
//           show: true,
//           rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 String text = '';
//                 switch (value.toInt()) {
//                   case 0:
//                     text = 'High';
//                     break;
//                   case 1:
//                     text = 'Medium';
//                     break;
//                   case 2:
//                     text = 'Low';
//                     break;
//                 }
//                 return Padding(
//                   padding: const EdgeInsets.only(top: 8),
//                   child: Text(text, style: const TextStyle(fontSize: 10)),
//                 );
//               },
//             ),
//           ),
//           leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         ),
//         backgroundColor: Colors.transparent,
//         borderData: FlBorderData(show: false),
//         groupsSpace: 20,
//         barGroups: [
//           BarChartGroupData(
//             x: 0,
//             barRods: [
//               BarChartRodData(
//                 toY: projects
//                     .where((p) => p.priority == 'high')
//                     .length
//                     .toDouble(),
//                 color: Colors.red.shade400,
//                 width: 20,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//             ],
//           ),
//           BarChartGroupData(
//             x: 1,
//             barRods: [
//               BarChartRodData(
//                 toY: projects
//                     .where((p) => p.priority == 'medium')
//                     .length
//                     .toDouble(),
//                 color: Colors.orange.shade400,
//                 width: 20,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//             ],
//           ),
//           BarChartGroupData(
//             x: 2,
//             barRods: [
//               BarChartRodData(
//                 toY: projects
//                     .where((p) => p.priority == 'low')
//                     .length
//                     .toDouble(),
//                 color: Colors.green.shade400,
//                 width: 20,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMiniStat({
//     required String value,
//     required String label,
//     required Color color,
//   }) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               value,
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: color,
//                   ),
//             ),
//             const SizedBox(width: 4),
//             Text(
//               label,
//               style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     color: color.withOpacity(0.8),
//                     fontSize: 10,
//                   ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMiniPieChart() {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         PieChart(
//           PieChartData(
//             sectionsSpace: 0,
//             centerSpaceRadius: 15,
//             sections: [
//               PieChartSectionData(
//                 value: projects
//                     .where((p) => p.status == 'completed')
//                     .length
//                     .toDouble(),
//                 color: Colors.green.shade400,
//                 radius: 5,
//                 showTitle: false,
//               ),
//               PieChartSectionData(
//                 value: projects
//                     .where((p) => p.status == 'in progress')
//                     .length
//                     .toDouble(),
//                 color: Colors.blue.shade400,
//                 radius: 5,
//                 showTitle: false,
//               ),
//               PieChartSectionData(
//                 value: projects
//                     .where((p) => p.status == 'on hold')
//                     .length
//                     .toDouble(),
//                 color: Colors.orange.shade400,
//                 radius: 5,
//                 showTitle: false,
//               ),
//               PieChartSectionData(
//                 value: projects
//                     .where((p) => p.status == 'not started')
//                     .length
//                     .toDouble(),
//                 color: Colors.grey.shade400,
//                 radius: 5,
//                 showTitle: false,
//               ),
//             ],
//           ),
//         ),
//         Text(
//           '${((projects.where((p) => p.status == 'completed').length / projects.length) * 100).toStringAsFixed(0)}%',
//           style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 10,
//               ),
//         ),
//       ],
//     );
//   }

//   Widget _buildViewOptions() {
//     return Container(
//       height: 40,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Theme.of(context).dividerColor,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           _buildViewToggleButton(
//             icon: PhosphorIcons.list(PhosphorIconsStyle.bold),
//             isActive: isListView,
//             onPressed: () => setState(() => isListView = true),
//           ),
//           Container(
//             width: 1,
//             height: 20,
//             color: Theme.of(context).dividerColor,
//           ),
//           _buildViewToggleButton(
//             icon: PhosphorIcons.squaresFour(PhosphorIconsStyle.bold),
//             isActive: !isListView,
//             onPressed: () => setState(() => isListView = false),
//           ),
//         ],
//       ),
//     );
//   }

//   void _handleRestoreAll() async {
//     // Check which list we're working with
//     final isRecycleBin = showRecycleBin;
//     final listToRestore = isRecycleBin ? deletedProjects : archivedProjects;

//     if (listToRestore.isEmpty) {
//       await showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Row(
//             children: [
//               Icon(
//                 PhosphorIcons.info(PhosphorIconsStyle.fill),
//                 color: AppColors.accent,
//                 size: 24,
//               ),
//               const SizedBox(width: 8),
//               Text('No ${isRecycleBin ? 'Deleted' : 'Archived'} Projects'),
//             ],
//           ),
//           content: Text(
//             'There are no ${isRecycleBin ? 'deleted' : 'archived'} projects to restore.',
//           ),
//           actions: [
//             FilledButton(
//               onPressed: () => Navigator.pop(context),
//               style: FilledButton.styleFrom(
//                 backgroundColor: AppColors.accent,
//               ),
//               child: const Text('OK'),
//             ),
//           ],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       );
//       return;
//     }

//     final bool? confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(
//               PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.fill),
//               color: AppColors.accent,
//               size: 24,
//             ),
//             const SizedBox(width: 8),
//             const Text('Restore All Projects'),
//           ],
//         ),
//         content: Text(
//           'Are you sure you want to restore all ${listToRestore.length} ${isRecycleBin ? 'deleted' : 'archived'} projects?',
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                 color: Theme.of(context).textTheme.bodyLarge?.color,
//               ),
//             ),
//           ),
//           FilledButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: FilledButton.styleFrom(
//               backgroundColor: AppColors.accent,
//             ),
//             child: const Text('Restore All'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       try {
//         if (isRecycleBin) {
//           // Restore all projects from recycle bin
//           for (final project in listToRestore) {
//             if (project.id != null) {
//               await _projectDatabaseService.restoreFromRecycleBin(project.id!);
//             }
//           }
//           setState(() {
//             projects.addAll(listToRestore);
//             deletedProjects.clear();
//             checkedProjects = List.generate(projects.length, (_) => false);
//           });
//         } else {
//           // Restore all archived projects
//           for (final project in listToRestore) {
//             final restoredProject = Project(
//               id: project.id,
//               name: project.name,
//               description: project.description,
//               startDate: project.startDate,
//               dueDate: project.dueDate,
//               tasks: project.tasks,
//               completedTasks: project.completedTasks,
//               priority: project.priority,
//               status: 'in progress',
//               category: project.category,
//             );
//             projects.add(restoredProject);
//           }
//           setState(() {
//             archivedProjects.clear();
//             checkedProjects = List.generate(projects.length, (_) => false);
//             originalStatuses.clear();
//           });
//         }

//         // Reload projects to ensure sync with database
//         await _loadProjects();
//         if (isRecycleBin) {
//           await _loadDeletedProjects();
//         }

//         _showSuccessMessage(
//           message: 'All projects have been restored',
//           icon: PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.fill),
//         );
//       } catch (e) {
//         _showError('Failed to restore projects: $e');
//       }
//     }
//   }

//   void _handleCompleteSelected() async {
//     final selectedProjects = projects
//         .asMap()
//         .entries
//         .where((entry) => checkedProjects[entry.key])
//         .map((entry) => entry.value)
//         .toList();

//     if (selectedProjects.isEmpty) return;

//     final bool? confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(
//               PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
//               color: Colors.green.shade400,
//               size: 24,
//             ),
//             const SizedBox(width: 8),
//             const Text('Complete Projects'),
//           ],
//         ),
//         content: Text(
//           'Are you sure you want to mark ${selectedProjects.length} projects as complete?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           FilledButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: FilledButton.styleFrom(
//               backgroundColor: Colors.green.shade400,
//             ),
//             child: const Text('Complete'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       try {
//         for (final project in selectedProjects) {
//           final completedProject = Project(
//             id: project.id,
//             name: project.name,
//             description: project.description,
//             startDate: project.startDate,
//             dueDate: project.dueDate,
//             tasks: project.tasks,
//             completedTasks: project.tasks,
//             priority: project.priority,
//             status: 'completed',
//             originalStatus: project.status, // Store original status
//             category: project.category,
//             archivedDate: DateTime.now(),
//           );

//           await _projectDatabaseService.archiveProject(completedProject);
//         }

//         setState(() {
//           // Move to archived list
//           archivedProjects.addAll(selectedProjects.map((p) => Project(
//                 id: p.id,
//                 name: p.name,
//                 description: p.description,
//                 startDate: p.startDate,
//                 dueDate: p.dueDate,
//                 tasks: p.tasks,
//                 completedTasks: p.completedTasks,
//                 priority: p.priority,
//                 status: 'completed',
//                 originalStatus: p.status, // Store original status here too
//                 category: p.category,
//                 archivedDate: DateTime.now(),
//               )));

//           // Remove from active projects
//           projects.removeWhere((project) =>
//               selectedProjects.any((selected) => selected.id == project.id));

//           // Update checkbox arrays
//           checkedProjects = List.generate(projects.length, (_) => false);
//           archivedCheckedProjects =
//               List.generate(archivedProjects.length, (_) => false);
//           _newlyArchivedCount += selectedProjects.length;
//           _hasVisitedArchived = false;
//         });

//         _showSuccessMessage(
//           message: 'Selected projects have been completed',
//           icon: PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
//         );
//       } catch (e) {
//         _showError('Failed to complete projects: $e');
//       }
//     }
//   }

//   void _handleDeleteSelected() async {
//     final selectedProjects = projects
//         .asMap()
//         .entries
//         .where((entry) => checkedProjects[entry.key])
//         .map((entry) => entry.value)
//         .toList();

//     if (selectedProjects.isEmpty) return;

//     final bool? confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(
//               PhosphorIcons.trash(PhosphorIconsStyle.fill),
//               color: Colors.red.shade400,
//               size: 24,
//             ),
//             const SizedBox(width: 8),
//             const Text('Move to Recycle Bin'),
//           ],
//         ),
//         content: Text(
//           'Are you sure you want to move ${selectedProjects.length} projects to recycle bin?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                 color: Theme.of(context).textTheme.bodyLarge?.color,
//               ),
//             ),
//           ),
//           FilledButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: FilledButton.styleFrom(
//               backgroundColor: Colors.red.shade400,
//             ),
//             child: const Text('Move to Recycle Bin'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       try {
//         for (final project in selectedProjects) {
//           await _projectDatabaseService.moveToRecycleBin(project);
//         }

//         setState(() {
//           // Remove from active projects
//           projects.removeWhere((project) =>
//               selectedProjects.any((selected) => selected.id == project.id));

//           // Update checkbox arrays
//           checkedProjects = List.generate(projects.length, (_) => false);
//           _newlyDeletedCount += selectedProjects.length;
//           _hasVisitedRecycleBin = false;
//         });

//         await _loadDeletedProjects();

//         _showSuccessMessage(
//           message: 'Selected projects have been moved to recycle bin',
//           icon: PhosphorIcons.trash(PhosphorIconsStyle.fill),
//         );
//       } catch (e) {
//         _showError('Failed to move projects to recycle bin: $e');
//       }
//     }
//   }

//   void _handleRecycleBinSelectAll(bool? value) {
//     setState(() {
//       recycleBinSelectAll = value ?? false;
//       recycleBinCheckedProjects = List.generate(
//         deletedProjects.length,
//         (_) => recycleBinSelectAll,
//       );
//     });
//   }

//   void _handleRestoreSelected() async {
//     // Fix the where clause to use indexed iteration
//     final selectedProjects = deletedProjects
//         .asMap()
//         .entries
//         .where((entry) => recycleBinCheckedProjects[entry.key])
//         .map((entry) => entry.value)
//         .toList();

//     if (selectedProjects.isEmpty) return;

//     final bool? confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(
//               PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.fill),
//               color: AppColors.accent,
//               size: 24,
//             ),
//             const SizedBox(width: 8),
//             const Text('Restore Selected Projects'),
//           ],
//         ),
//         content: Text(
//           'Are you sure you want to restore ${selectedProjects.length} selected projects?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                 color: Theme.of(context).textTheme.bodyLarge?.color,
//               ),
//             ),
//           ),
//           FilledButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: FilledButton.styleFrom(
//               backgroundColor: AppColors.accent,
//             ),
//             child: const Text('Restore'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       try {
//         for (final project in selectedProjects) {
//           if (project.id != null) {
//             await _projectDatabaseService.restoreFromRecycleBin(project.id!);
//           }
//         }
//         await _loadProjects();
//         await _loadDeletedProjects();
//         _showSuccessMessage(
//           message: 'Selected projects have been restored',
//           icon: PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.fill),
//         );
//       } catch (e) {
//         _showError('Failed to restore projects: $e');
//       }
//     }
//   }

//   void _handlePermanentlyDeleteSelected() async {
//     // Fix the where clause to use indexed iteration
//     final selectedProjects = deletedProjects
//         .asMap()
//         .entries
//         .where((entry) => recycleBinCheckedProjects[entry.key])
//         .map((entry) => entry.value)
//         .toList();

//     if (selectedProjects.isEmpty) return;

//     final bool? confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(
//               PhosphorIcons.warning(PhosphorIconsStyle.fill),
//               color: Colors.red.shade400,
//               size: 24,
//             ),
//             const SizedBox(width: 8),
//             const Text('Permanently Delete Projects'),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Are you sure you want to permanently delete ${selectedProjects.length} selected projects?',
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'This action cannot be undone.',
//               style: TextStyle(
//                 color: Colors.red.shade400,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           FilledButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: FilledButton.styleFrom(
//               backgroundColor: Colors.red.shade400,
//             ),
//             child: const Text('Delete Permanently'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       try {
//         for (final project in selectedProjects) {
//           if (project.id != null) {
//             await _projectDatabaseService.permanentlyDelete(project.id!);
//           }
//         }
//         await _loadDeletedProjects();
//         _showSuccessMessage(
//           message: 'Selected projects have been permanently deleted',
//           icon: PhosphorIcons.trash(PhosphorIconsStyle.fill),
//         );
//       } catch (e) {
//         _showError('Failed to delete projects: $e');
//       }
//     }
//   }

//   void _handlePermanentDelete(int index) async {
//     final projectName = deletedProjects[index].name;
//     final projectId = deletedProjects[index].id;

//     final bool? confirm = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               PhosphorIcons.warning(PhosphorIconsStyle.fill),
//               color: Colors.red.shade400,
//               size: 20,
//             ),
//             const SizedBox(width: 8),
//             const Text(
//               'Permanently Delete Project',
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Are you sure you want to permanently delete "$projectName"?',
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'This action cannot be undone.',
//               style: TextStyle(
//                 color: Colors.red.shade400,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                 color: Theme.of(context).textTheme.bodyLarge?.color,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           FilledButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: FilledButton.styleFrom(
//               backgroundColor: Colors.red.shade400,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             ),
//             child: const Text(
//               'Delete Permanently',
//               style: TextStyle(fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true && projectId != null) {
//       try {
//         await _projectDatabaseService.permanentlyDelete(projectId);

//         setState(() {
//           deletedProjects.removeAt(index);
//           recycleBinCheckedProjects =
//               List.generate(deletedProjects.length, (_) => false);
//         });

//         _showSuccessMessage(
//           message: 'Project "$projectName" has been permanently deleted',
//           icon: PhosphorIcons.trash(PhosphorIconsStyle.fill),
//         );
//       } catch (e) {
//         _showError('Failed to delete project: $e');
//       }
//     }
//   }

//   Widget _buildProjectsList() {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Theme.of(context).dividerColor,
//           width: 1,
//         ),
//       ),
//       child: Column(
//         children: [
//           // Table Header
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               children: [
//                 // Checkbox
//                 SizedBox(
//                   width: ProjectListLayout.checkboxWidth,
//                   child: Checkbox(
//                     value: showArchived
//                         ? archivedCheckedProjects.every((checked) => checked)
//                         : showRecycleBin
//                             ? recycleBinCheckedProjects
//                                 .every((checked) => checked)
//                             : checkedProjects.every((checked) => checked),
//                     onChanged: (value) {
//                       if (showArchived) {
//                         setState(() {
//                           archivedCheckedProjects = List.generate(
//                             archivedProjects.length,
//                             (_) => value ?? false,
//                           );
//                           archivedSelectAll = value ?? false;
//                         });
//                       } else if (showRecycleBin) {
//                         setState(() {
//                           recycleBinCheckedProjects = List.generate(
//                             deletedProjects.length,
//                             (_) => value ?? false,
//                           );
//                           recycleBinSelectAll = value ?? false;
//                         });
//                       } else {
//                         _toggleAllProjects(value);
//                       }
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: ProjectListLayout.iconSpacing),

//                 // Project Name with filter
//                 Expanded(
//                   flex: ProjectListLayout.nameColumnFlex,
//                   child: PopupMenuButton<String>(
//                     offset: const Offset(0, 40),
//                     child: MouseRegion(
//                       onEnter: (_) =>
//                           setState(() => _isProjectNameHeaderHovered = true),
//                       onExit: (_) =>
//                           setState(() => _isProjectNameHeaderHovered = false),
//                       cursor: SystemMouseCursors.click,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: _isProjectNameHeaderHovered
//                               ? Theme.of(context).hoverColor
//                               : Colors.transparent,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Row(
//                           children: [
//                             Text(
//                               'Project Name',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .titleSmall
//                                   ?.copyWith(
//                                     fontWeight: FontWeight.w600,
//                                     color: _selectedNameSort != null
//                                         ? AppColors.accent
//                                         : null,
//                                   ),
//                             ),
//                             const SizedBox(width: 4),
//                             Icon(
//                               _selectedNameSort == 'asc'
//                                   ? PhosphorIcons.sortAscending(
//                                       PhosphorIconsStyle.fill)
//                                   : _selectedNameSort == 'desc'
//                                       ? PhosphorIcons.sortDescending(
//                                           PhosphorIconsStyle.fill)
//                                       : PhosphorIcons.caretDown(
//                                           PhosphorIconsStyle.bold),
//                               size: 14,
//                               color: _selectedNameSort != null
//                                   ? AppColors.accent
//                                   : null,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     itemBuilder: (context) => [
//                       PopupMenuItem(
//                         value: 'none',
//                         child: Row(
//                           children: [
//                             Icon(
//                               PhosphorIcons.textT(PhosphorIconsStyle.bold),
//                               size: 16,
//                               color: _selectedNameSort == null
//                                   ? AppColors.accent
//                                   : null,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               'No Sort',
//                               style: TextStyle(
//                                 color: _selectedNameSort == null
//                                     ? AppColors.accent
//                                     : null,
//                                 fontWeight: _selectedNameSort == null
//                                     ? FontWeight.w600
//                                     : null,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const PopupMenuDivider(),
//                       PopupMenuItem(
//                         value: 'asc',
//                         child: Row(
//                           children: [
//                             Icon(
//                               PhosphorIcons.sortAscending(
//                                   PhosphorIconsStyle.bold),
//                               size: 16,
//                               color: _selectedNameSort == 'asc'
//                                   ? AppColors.accent
//                                   : null,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               'Sort A to Z',
//                               style: TextStyle(
//                                 color: _selectedNameSort == 'asc'
//                                     ? AppColors.accent
//                                     : null,
//                                 fontWeight: _selectedNameSort == 'asc'
//                                     ? FontWeight.w600
//                                     : null,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       PopupMenuItem(
//                         value: 'desc',
//                         child: Row(
//                           children: [
//                             Icon(
//                               PhosphorIcons.sortDescending(
//                                   PhosphorIconsStyle.bold),
//                               size: 16,
//                               color: _selectedNameSort == 'desc'
//                                   ? AppColors.accent
//                                   : null,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               'Sort Z to A',
//                               style: TextStyle(
//                                 color: _selectedNameSort == 'desc'
//                                     ? AppColors.accent
//                                     : null,
//                                 fontWeight: _selectedNameSort == 'desc'
//                                     ? FontWeight.w600
//                                     : null,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                     onSelected: (value) {
//                       setState(() {
//                         _selectedNameSort = value == 'none' ? null : value;
//                       });
//                     },
//                   ),
//                 ),

//                 // Start Date
//                 Expanded(
//                   flex: ProjectListLayout.dateColumnFlex,
//                   child: PopupMenuButton<String>(
//                     offset: const Offset(0, 40),
//                     child: MouseRegion(
//                       onEnter: (_) =>
//                           setState(() => _isStartDateHeaderHovered = true),
//                       onExit: (_) =>
//                           setState(() => _isStartDateHeaderHovered = false),
//                       cursor: SystemMouseCursors.click,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: _isStartDateHeaderHovered
//                               ? Theme.of(context).hoverColor
//                               : Colors.transparent,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Row(
//                           children: [
//                             Text(
//                               'Start Date',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .titleSmall
//                                   ?.copyWith(
//                                     color: _selectedStartDateSort != null
//                                         ? AppColors.accent
//                                         : null,
//                                   ),
//                             ),
//                             const SizedBox(width: 4),
//                             Icon(
//                               _selectedStartDateSort == 'asc'
//                                   ? PhosphorIcons.sortAscending(
//                                       PhosphorIconsStyle.fill)
//                                   : _selectedStartDateSort == 'desc'
//                                       ? PhosphorIcons.sortDescending(
//                                           PhosphorIconsStyle.fill)
//                                       : PhosphorIcons.caretDown(
//                                           PhosphorIconsStyle.bold),
//                               size: 14,
//                               color: _selectedStartDateSort != null
//                                   ? AppColors.accent
//                                   : null,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     itemBuilder: (context) => [
//                       PopupMenuItem(
//                         value: 'none',
//                         child: Row(
//                           children: [
//                             Icon(
//                               PhosphorIcons.calendar(PhosphorIconsStyle.bold),
//                               size: 16,
//                               color: _selectedStartDateSort == null
//                                   ? AppColors.accent
//                                   : null,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               'No Sort',
//                               style: TextStyle(
//                                 color: _selectedStartDateSort == null
//                                     ? AppColors.accent
//                                     : null,
//                                 fontWeight: _selectedStartDateSort == null
//                                     ? FontWeight.w600
//                                     : null,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const PopupMenuDivider(),
//                       PopupMenuItem(
//                         value: 'asc',
//                         child: Row(
//                           children: [
//                             Icon(
//                               PhosphorIcons.sortAscending(
//                                   PhosphorIconsStyle.bold),
//                               size: 16,
//                               color: _selectedStartDateSort == 'asc'
//                                   ? AppColors.accent
//                                   : null,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               'Oldest First',
//                               style: TextStyle(
//                                 color: _selectedStartDateSort == 'asc'
//                                     ? AppColors.accent
//                                     : null,
//                                 fontWeight: _selectedStartDateSort == 'asc'
//                                     ? FontWeight.w600
//                                     : null,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       PopupMenuItem(
//                         value: 'desc',
//                         child: Row(
//                           children: [
//                             Icon(
//                               PhosphorIcons.sortDescending(
//                                   PhosphorIconsStyle.bold),
//                               size: 16,
//                               color: _selectedStartDateSort == 'desc'
//                                   ? AppColors.accent
//                                   : null,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               'Newest First',
//                               style: TextStyle(
//                                 color: _selectedStartDateSort == 'desc'
//                                     ? AppColors.accent
//                                     : null,
//                                 fontWeight: _selectedStartDateSort == 'desc'
//                                     ? FontWeight.w600
//                                     : null,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                     onSelected: (value) {
//                       setState(() {
//                         _selectedStartDateSort = value == 'none' ? null : value;
//                         // Clear due date sort if start date sort is selected
//                         if (_selectedStartDateSort != null) {
//                           _selectedDueDateSort = null;
//                         }
//                       });
//                     },
//                   ),
//                 ),

//                 // Due Date
//                 Expanded(
//                   flex: ProjectListLayout.dateColumnFlex,
//                   child: PopupMenuButton<String>(
//                     offset: const Offset(0, 40),
//                     child: MouseRegion(
//                       onEnter: (_) =>
//                           setState(() => _isDueDateHeaderHovered = true),
//                       onExit: (_) =>
//                           setState(() => _isDueDateHeaderHovered = false),
//                       cursor: SystemMouseCursors.click,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: _isDueDateHeaderHovered
//                               ? Theme.of(context).hoverColor
//                               : Colors.transparent,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Row(
//                           children: [
//                             Text(
//                               'Due Date',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .titleSmall
//                                   ?.copyWith(
//                                     color: _selectedDueDateSort != null
//                                         ? AppColors.accent
//                                         : null,
//                                   ),
//                             ),
//                             const SizedBox(width: 4),
//                             Icon(
//                               _selectedDueDateSort == 'asc'
//                                   ? PhosphorIcons.sortAscending(
//                                       PhosphorIconsStyle.fill)
//                                   : _selectedDueDateSort == 'desc'
//                                       ? PhosphorIcons.sortDescending(
//                                           PhosphorIconsStyle.fill)
//                                       : PhosphorIcons.caretDown(
//                                           PhosphorIconsStyle.bold),
//                               size: 14,
//                               color: _selectedDueDateSort != null
//                                   ? AppColors.accent
//                                   : null,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     itemBuilder: (context) => [
//                       PopupMenuItem(
//                         value: 'none',
//                         child: Row(
//                           children: [
//                             Icon(
//                               PhosphorIcons.calendar(PhosphorIconsStyle.bold),
//                               size: 16,
//                               color: _selectedDueDateSort == null
//                                   ? AppColors.accent
//                                   : null,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               'No Sort',
//                               style: TextStyle(
//                                 color: _selectedDueDateSort == null
//                                     ? AppColors.accent
//                                     : null,
//                                 fontWeight: _selectedDueDateSort == null
//                                     ? FontWeight.w600
//                                     : null,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const PopupMenuDivider(),
//                       PopupMenuItem(
//                         value: 'asc',
//                         child: Row(
//                           children: [
//                             Icon(
//                               PhosphorIcons.sortAscending(
//                                   PhosphorIconsStyle.bold),
//                               size: 16,
//                               color: _selectedDueDateSort == 'asc'
//                                   ? AppColors.accent
//                                   : null,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               'Due First',
//                               style: TextStyle(
//                                 color: _selectedDueDateSort == 'asc'
//                                     ? AppColors.accent
//                                     : null,
//                                 fontWeight: _selectedDueDateSort == 'asc'
//                                     ? FontWeight.w600
//                                     : null,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       PopupMenuItem(
//                         value: 'desc',
//                         child: Row(
//                           children: [
//                             Icon(
//                               PhosphorIcons.sortDescending(
//                                   PhosphorIconsStyle.bold),
//                               size: 16,
//                               color: _selectedDueDateSort == 'desc'
//                                   ? AppColors.accent
//                                   : null,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               'Due Last',
//                               style: TextStyle(
//                                 color: _selectedDueDateSort == 'desc'
//                                     ? AppColors.accent
//                                     : null,
//                                 fontWeight: _selectedDueDateSort == 'desc'
//                                     ? FontWeight.w600
//                                     : null,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                     onSelected: (value) {
//                       setState(() {
//                         _selectedDueDateSort = value == 'none' ? null : value;
//                         // Clear start date sort if due date sort is selected
//                         if (_selectedDueDateSort != null) {
//                           _selectedStartDateSort = null;
//                         }
//                       });
//                     },
//                   ),
//                 ),

//                 // Tasks with right padding and fixed width
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       right: ProjectListLayout.columnPadding),
//                   child: SizedBox(
//                     width: ProjectListLayout.tasksWidth,
//                     child: PopupMenuButton<String>(
//                       offset: const Offset(0, 40),
//                       child: MouseRegion(
//                         onEnter: (_) =>
//                             setState(() => _isTasksHeaderHovered = true),
//                         onExit: (_) =>
//                             setState(() => _isTasksHeaderHovered = false),
//                         cursor: SystemMouseCursors.click,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: _isTasksHeaderHovered
//                                 ? Theme.of(context).hoverColor
//                                 : Colors.transparent,
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Tasks',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleSmall
//                                     ?.copyWith(
//                                       color: _selectedTasksSort != null
//                                           ? AppColors.accent
//                                           : null,
//                                     ),
//                               ),
//                               const SizedBox(width: 4),
//                               Icon(
//                                 _selectedTasksSort != null
//                                     ? PhosphorIcons.sortAscending(
//                                         PhosphorIconsStyle.fill)
//                                     : PhosphorIcons.caretDown(
//                                         PhosphorIconsStyle.bold),
//                                 size: 14,
//                                 color: _selectedTasksSort != null
//                                     ? AppColors.accent
//                                     : null,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       itemBuilder: (context) => [
//                         PopupMenuItem(
//                           value: 'none',
//                           child: Row(
//                             children: [
//                               Icon(
//                                 PhosphorIcons.listChecks(
//                                     PhosphorIconsStyle.bold),
//                                 size: 16,
//                                 color: _selectedTasksSort == null
//                                     ? AppColors.accent
//                                     : null,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'No Sort',
//                                 style: TextStyle(
//                                   color: _selectedTasksSort == null
//                                       ? AppColors.accent
//                                       : null,
//                                   fontWeight: _selectedTasksSort == null
//                                       ? FontWeight.w600
//                                       : null,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const PopupMenuDivider(),
//                         PopupMenuItem(
//                           value: 'most',
//                           child: Row(
//                             children: [
//                               Icon(
//                                 PhosphorIcons.listPlus(PhosphorIconsStyle.bold),
//                                 size: 16,
//                                 color: _selectedTasksSort == 'most'
//                                     ? AppColors.accent
//                                     : null,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'Most Tasks First',
//                                 style: TextStyle(
//                                   color: _selectedTasksSort == 'most'
//                                       ? AppColors.accent
//                                       : null,
//                                   fontWeight: _selectedTasksSort == 'most'
//                                       ? FontWeight.w600
//                                       : null,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         PopupMenuItem(
//                           value: 'least',
//                           child: Row(
//                             children: [
//                               Icon(
//                                 PhosphorIcons.list(PhosphorIconsStyle.bold),
//                                 size: 16,
//                                 color: _selectedTasksSort == 'least'
//                                     ? AppColors.accent
//                                     : null,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'Least Tasks First',
//                                 style: TextStyle(
//                                   color: _selectedTasksSort == 'least'
//                                       ? AppColors.accent
//                                       : null,
//                                   fontWeight: _selectedTasksSort == 'least'
//                                       ? FontWeight.w600
//                                       : null,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         PopupMenuItem(
//                           value: 'completed',
//                           child: Row(
//                             children: [
//                               Icon(
//                                 PhosphorIcons.checkSquare(
//                                     PhosphorIconsStyle.bold),
//                                 size: 16,
//                                 color: _selectedTasksSort == 'completed'
//                                     ? AppColors.accent
//                                     : null,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'Most Completed First',
//                                 style: TextStyle(
//                                   color: _selectedTasksSort == 'completed'
//                                       ? AppColors.accent
//                                       : null,
//                                   fontWeight: _selectedTasksSort == 'completed'
//                                       ? FontWeight.w600
//                                       : null,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         PopupMenuItem(
//                           value: 'incomplete',
//                           child: Row(
//                             children: [
//                               Icon(
//                                 PhosphorIcons.square(PhosphorIconsStyle.bold),
//                                 size: 16,
//                                 color: _selectedTasksSort == 'incomplete'
//                                     ? AppColors.accent
//                                     : null,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'Least Completed First',
//                                 style: TextStyle(
//                                   color: _selectedTasksSort == 'incomplete'
//                                       ? AppColors.accent
//                                       : null,
//                                   fontWeight: _selectedTasksSort == 'incomplete'
//                                       ? FontWeight.w600
//                                       : null,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                       onSelected: (value) {
//                         setState(() {
//                           _selectedTasksSort = value == 'none' ? null : value;
//                         });
//                       },
//                     ),
//                   ),
//                 ),

//                 // Priority with right padding and fixed width
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       right: ProjectListLayout.columnPadding),
//                   child: SizedBox(
//                     width: ProjectListLayout.priorityWidth,
//                     child: PopupMenuButton<String>(
//                       offset: const Offset(0, 40),
//                       child: MouseRegion(
//                         onEnter: (_) =>
//                             setState(() => _isPriorityHeaderHovered = true),
//                         onExit: (_) =>
//                             setState(() => _isPriorityHeaderHovered = false),
//                         cursor: SystemMouseCursors.click,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: _isPriorityHeaderHovered
//                                 ? Theme.of(context).hoverColor
//                                 : Colors.transparent,
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Priority',
//                                 style: Theme.of(context).textTheme.titleSmall,
//                               ),
//                               const SizedBox(width: 4),
//                               Icon(
//                                 selectedPriority != null
//                                     ? PhosphorIcons.caretDown(
//                                         PhosphorIconsStyle.fill)
//                                     : PhosphorIcons.caretDown(
//                                         PhosphorIconsStyle.bold),
//                                 size: 14,
//                                 color: selectedPriority != null
//                                     ? AppColors.accent
//                                     : null,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       itemBuilder: (context) => [
//                         PopupMenuItem(
//                           value: 'all',
//                           child: Row(
//                             children: [
//                               Icon(
//                                 PhosphorIcons.warning(PhosphorIconsStyle.bold),
//                                 size: 16,
//                                 color: selectedPriority == null
//                                     ? AppColors.accent
//                                     : null,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'All Priorities',
//                                 style: TextStyle(
//                                   color: selectedPriority == null
//                                       ? AppColors.accent
//                                       : null,
//                                   fontWeight: selectedPriority == null
//                                       ? FontWeight.w600
//                                       : null,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const PopupMenuDivider(),
//                         ...{
//                           'high': Colors.red.shade400,
//                           'medium': Colors.orange.shade400,
//                           'low': Colors.green.shade400,
//                         }.entries.map(
//                               (entry) => PopupMenuItem(
//                                 value: entry.key,
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       width: 8,
//                                       height: 8,
//                                       decoration: BoxDecoration(
//                                         color: entry.value,
//                                         shape: BoxShape.circle,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Text(
//                                       entry.key.capitalize(),
//                                       style: TextStyle(
//                                         color: selectedPriority == entry.key
//                                             ? AppColors.accent
//                                             : null,
//                                         fontWeight:
//                                             selectedPriority == entry.key
//                                                 ? FontWeight.w600
//                                                 : null,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                       ],
//                       onSelected: (value) {
//                         setState(() {
//                           selectedPriority = value == 'all' ? null : value;
//                         });
//                       },
//                     ),
//                   ),
//                 ),

//                 // Status with right padding and fixed width
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       right: ProjectListLayout.columnPadding),
//                   child: SizedBox(
//                     width: ProjectListLayout.statusWidth,
//                     child: PopupMenuButton<String>(
//                       offset: const Offset(0, 40),
//                       child: MouseRegion(
//                         onEnter: (_) =>
//                             setState(() => _isStatusHeaderHovered = true),
//                         onExit: (_) =>
//                             setState(() => _isStatusHeaderHovered = false),
//                         cursor: SystemMouseCursors.click,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: _isStatusHeaderHovered
//                                 ? Theme.of(context).hoverColor
//                                 : Colors.transparent,
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Status',
//                                 style: Theme.of(context).textTheme.titleSmall,
//                               ),
//                               const SizedBox(width: 4),
//                               Icon(
//                                 selectedStatus != null
//                                     ? PhosphorIcons.caretDown(
//                                         PhosphorIconsStyle.fill)
//                                     : PhosphorIcons.caretDown(
//                                         PhosphorIconsStyle.bold),
//                                 size: 14,
//                                 color: selectedStatus != null
//                                     ? AppColors.accent
//                                     : null,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       itemBuilder: (context) => [
//                         PopupMenuItem(
//                           value: 'all',
//                           child: Row(
//                             children: [
//                               Icon(
//                                 PhosphorIcons.circle(PhosphorIconsStyle.bold),
//                                 size: 16,
//                                 color: selectedStatus == null
//                                     ? AppColors.accent
//                                     : null,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'All Statuses',
//                                 style: TextStyle(
//                                   color: selectedStatus == null
//                                       ? AppColors.accent
//                                       : null,
//                                   fontWeight: selectedStatus == null
//                                       ? FontWeight.w600
//                                       : null,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const PopupMenuDivider(),
//                         ...{
//                           'not started': (
//                             PhosphorIcons.pause(PhosphorIconsStyle.fill),
//                             Colors.grey.shade400
//                           ),
//                           'in progress': (
//                             PhosphorIcons.play(PhosphorIconsStyle.fill),
//                             Colors.blue.shade400
//                           ),
//                           'on hold': (
//                             PhosphorIcons.clock(PhosphorIconsStyle.fill),
//                             Colors.orange.shade400
//                           ),
//                           'completed': (
//                             PhosphorIcons.check(PhosphorIconsStyle.fill),
//                             Colors.green.shade400
//                           ),
//                         }.entries.map(
//                               (entry) => PopupMenuItem(
//                                 value: entry.key,
//                                 child: Row(
//                                   children: [
//                                     Icon(
//                                       entry.value.$1,
//                                       size: 16,
//                                       color: entry.value.$2,
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Text(
//                                       entry.key.capitalize(),
//                                       style: TextStyle(
//                                         color: selectedStatus == entry.key
//                                             ? AppColors.accent
//                                             : null,
//                                         fontWeight: selectedStatus == entry.key
//                                             ? FontWeight.w600
//                                             : null,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                       ],
//                       onSelected: (value) {
//                         setState(() {
//                           selectedStatus = value == 'all' ? null : value;
//                         });
//                       },
//                     ),
//                   ),
//                 ),

//                 // Actions column
//                 SizedBox(
//                   width: ProjectListLayout.actionsWidth,
//                   child: Text(
//                     'Actions',
//                     style: Theme.of(context).textTheme.titleSmall,
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(height: 1),
//           // Rest of the list content...
//           Expanded(
//             child: isListView
//                 ? ListView.builder(
//                     padding: const EdgeInsets.all(12),
//                     itemCount: _getFilteredProjects().length,
//                     itemBuilder: (context, index) {
//                       final project = _getFilteredProjects()[index];
//                       return GestureDetector(
//                         onSecondaryTapUp: (details) {
//                           if (showArchived || showRecycleBin) return;

//                           final RenderBox overlay = Overlay.of(context)
//                               .context
//                               .findRenderObject() as RenderBox;

//                           showMenu(
//                             context: context,
//                             position: RelativeRect.fromRect(
//                               details.globalPosition & const Size(48, 48),
//                               Offset.zero & overlay.size,
//                             ),
//                             items: [
//                               PopupMenuItem(
//                                 child: Row(
//                                   children: [
//                                     Icon(
//                                       (project.isPinned ?? false)
//                                           ? PhosphorIcons.pushPin(
//                                               PhosphorIconsStyle.fill)
//                                           : PhosphorIcons.pushPin(
//                                               PhosphorIconsStyle.bold),
//                                       size: 16,
//                                       color: (project.isPinned ?? false)
//                                           ? AppColors.accent
//                                           : null,
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Text((project.isPinned ?? false)
//                                         ? 'Unpin Project'
//                                         : 'Pin Project'),
//                                   ],
//                                 ),
//                                 onTap: () => _handlePinProject(project),
//                               ),
//                               // Add other context menu items here if needed
//                             ],
//                           );
//                         },
//                         child: MouseRegion(
//                           onEnter: (_) => setState(() => hoveredIndex = index),
//                           onExit: (_) => setState(() => hoveredIndex = null),
//                           child: ProjectListItem(
//                             project: project,
//                             isChecked: showArchived
//                                 ? archivedCheckedProjects[index]
//                                 : showRecycleBin
//                                     ? recycleBinCheckedProjects[index]
//                                     : checkedProjects[index],
//                             onCheckChanged: showArchived
//                                 ? (value) {
//                                     setState(() {
//                                       archivedCheckedProjects[index] =
//                                           value ?? false;
//                                       archivedSelectAll =
//                                           archivedCheckedProjects
//                                               .every((checked) => checked);
//                                     });
//                                   }
//                                 : showRecycleBin
//                                     ? (value) {
//                                         setState(() {
//                                           recycleBinCheckedProjects[index] =
//                                               value ?? false;
//                                           recycleBinSelectAll =
//                                               recycleBinCheckedProjects
//                                                   .every((checked) => checked);
//                                         });
//                                       }
//                                     : (value) =>
//                                         _handleCheckboxChange(index, value),
//                             onEdit: showRecycleBin || showArchived
//                                 ? () {}
//                                 : () => _handleEdit(index),
//                             onDelete: showRecycleBin
//                                 ? () => _handlePermanentDelete(index)
//                                 : () => _handleDelete(index),
//                             onRestore: (showRecycleBin || showArchived)
//                                 ? () => _handleRestore(index)
//                                 : null,
//                             isHovered: hoveredIndex == index,
//                           ),
//                         ),
//                       );
//                     },
//                   )
//                 : GridView.builder(
//                     padding: const EdgeInsets.all(12),
//                     gridDelegate:
//                         const SliverGridDelegateWithMaxCrossAxisExtent(
//                       maxCrossAxisExtent: 400,
//                       childAspectRatio: 0.85,
//                       crossAxisSpacing: 12,
//                       mainAxisSpacing: 12,
//                     ),
//                     itemCount: _getFilteredProjects()
//                         .length, // Use filtered projects length
//                     itemBuilder: (context, index) {
//                       final project =
//                           _getFilteredProjects()[index]; // Use filtered project
//                       return GestureDetector(
//                         onSecondaryTapUp: (details) {
//                           if (showArchived || showRecycleBin) return;

//                           final RenderBox overlay = Overlay.of(context)
//                               .context
//                               .findRenderObject() as RenderBox;

//                           showMenu(
//                             context: context,
//                             position: RelativeRect.fromRect(
//                               details.globalPosition & const Size(48, 48),
//                               Offset.zero & overlay.size,
//                             ),
//                             items: [
//                               PopupMenuItem(
//                                 child: Row(
//                                   children: [
//                                     Icon(
//                                       (project.isPinned ?? false)
//                                           ? PhosphorIcons.pushPin(
//                                               PhosphorIconsStyle.fill)
//                                           : PhosphorIcons.pushPin(
//                                               PhosphorIconsStyle.bold),
//                                       size: 16,
//                                       color: (project.isPinned ?? false)
//                                           ? AppColors.accent
//                                           : null,
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Text((project.isPinned ?? false)
//                                         ? 'Unpin Project'
//                                         : 'Pin Project'),
//                                   ],
//                                 ),
//                                 onTap: () => _handlePinProject(project),
//                               ),
//                               // Add other context menu items here if needed
//                             ],
//                           );
//                         },
//                         child: MouseRegion(
//                           onEnter: (_) => setState(() => hoveredIndex = index),
//                           onExit: (_) => setState(() => hoveredIndex = null),
//                           child: ProjectGridItem(
//                             project: project,
//                             isChecked: showArchived
//                                 ? archivedCheckedProjects[index]
//                                 : showRecycleBin
//                                     ? recycleBinCheckedProjects[index]
//                                     : checkedProjects[index],
//                             onCheckChanged: showArchived
//                                 ? (value) {
//                                     setState(() {
//                                       archivedCheckedProjects[index] =
//                                           value ?? false;
//                                       archivedSelectAll =
//                                           archivedCheckedProjects
//                                               .every((checked) => checked);
//                                     });
//                                   }
//                                 : showRecycleBin
//                                     ? (value) {
//                                         setState(() {
//                                           recycleBinCheckedProjects[index] =
//                                               value ?? false;
//                                           recycleBinSelectAll =
//                                               recycleBinCheckedProjects
//                                                   .every((checked) => checked);
//                                         });
//                                       }
//                                     : (value) =>
//                                         _handleCheckboxChange(index, value),
//                             onEdit: showRecycleBin || showArchived
//                                 ? () {}
//                                 : () => _handleEdit(index),
//                             onDelete: showRecycleBin
//                                 ? () => _handlePermanentDelete(index)
//                                 : () => _handleDelete(index),
//                             onRestore: (showRecycleBin || showArchived)
//                                 ? () => _handleRestore(index)
//                                 : null,
//                             isHovered: hoveredIndex == index,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _handleRestoreSelectedArchived() async {
//     final selectedProjects = archivedProjects
//         .asMap()
//         .entries
//         .where((entry) => archivedCheckedProjects[entry.key])
//         .map((entry) => entry.value)
//         .toList();

//     if (selectedProjects.isEmpty) return;

//     final bool? confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(
//               PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.fill),
//               color: AppColors.accent,
//               size: 24,
//             ),
//             const SizedBox(width: 8),
//             const Text('Restore Selected Projects'),
//           ],
//         ),
//         content: Text(
//           'Are you sure you want to restore ${selectedProjects.length} selected projects?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                 color: Theme.of(context).textTheme.bodyLarge?.color,
//               ),
//             ),
//           ),
//           FilledButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: FilledButton.styleFrom(
//               backgroundColor: AppColors.accent,
//             ),
//             child: const Text('Restore'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       try {
//         for (final project in selectedProjects) {
//           final restoredProject = Project(
//             id: project.id,
//             name: project.name,
//             description: project.description,
//             startDate: project.startDate,
//             dueDate: project.dueDate,
//             tasks: project.tasks,
//             completedTasks: project.completedTasks,
//             priority: project.priority,
//             status: 'in progress',
//             category: project.category,
//           );

//           await _projectDatabaseService.updateProject(restoredProject);
//         }

//         setState(() {
//           // Remove restored projects from archived
//           archivedProjects.removeWhere((project) =>
//               selectedProjects.any((selected) => selected.id == project.id));
//           // Add to active projects
//           projects.addAll(selectedProjects.map((p) => Project(
//                 id: p.id,
//                 name: p.name,
//                 description: p.description,
//                 startDate: p.startDate,
//                 dueDate: p.dueDate,
//                 tasks: p.tasks,
//                 completedTasks: p.completedTasks,
//                 priority: p.priority,
//                 status: 'in progress',
//                 category: p.category,
//               )));

//           // Reset checkbox states
//           archivedCheckedProjects =
//               List.generate(archivedProjects.length, (_) => false);
//           checkedProjects = List.generate(projects.length, (_) => false);
//           archivedSelectAll = false;
//         });

//         _showSuccessMessage(
//           message: 'Selected projects have been restored',
//           icon: PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.fill),
//         );
//       } catch (e) {
//         _showError('Failed to restore projects: $e');
//       }
//     }
//   }

//   void _handleDeleteSelectedArchived() async {
//     final selectedProjects = archivedProjects
//         .asMap()
//         .entries
//         .where((entry) => archivedCheckedProjects[entry.key])
//         .map((entry) => entry.value)
//         .toList();

//     if (selectedProjects.isEmpty) return;

//     final bool? confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(
//               PhosphorIcons.trash(PhosphorIconsStyle.fill),
//               color: Colors.red.shade400,
//               size: 24,
//             ),
//             const SizedBox(width: 8),
//             const Text('Move to Recycle Bin'),
//           ],
//         ),
//         content: Text(
//           'Are you sure you want to move ${selectedProjects.length} selected projects to recycle bin?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                 color: Theme.of(context).textTheme.bodyLarge?.color,
//               ),
//             ),
//           ),
//           FilledButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: FilledButton.styleFrom(
//               backgroundColor: Colors.red.shade400,
//             ),
//             child: const Text('Move to Recycle Bin'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       try {
//         for (final project in selectedProjects) {
//           await _projectDatabaseService.moveArchivedToRecycleBin(project);
//         }

//         setState(() {
//           archivedProjects.removeWhere((project) =>
//               selectedProjects.any((selected) => selected.id == project.id));
//           archivedCheckedProjects =
//               List.generate(archivedProjects.length, (_) => false);
//           archivedSelectAll = false;
//           _newlyDeletedCount += selectedProjects.length;
//           _hasVisitedRecycleBin = false;
//         });

//         await _loadDeletedProjects();

//         _showSuccessMessage(
//           message: 'Selected projects have been moved to recycle bin',
//           icon: PhosphorIcons.trash(PhosphorIconsStyle.fill),
//         );
//       } catch (e) {
//         _showError('Failed to move projects to recycle bin: $e');
//       }
//     }
//   }

//   List<Project> _getFilteredProjects() {
//     final List<Project> currentProjects = showArchived
//         ? archivedProjects
//         : showRecycleBin
//             ? deletedProjects
//             : projects;

//     List<Project> filteredProjects = currentProjects.where((project) {
//       // Search filter
//       if (searchQuery.isNotEmpty) {
//         final String projectName = project.name.toLowerCase();
//         final String projectDescription =
//             (project.description ?? '').toLowerCase();
//         final String query = searchQuery.toLowerCase();
//         if (!projectName.contains(query) &&
//             !projectDescription.contains(query)) {
//           return false;
//         }
//       }

//       // Priority filter
//       if (selectedPriority != null && selectedPriority != 'all') {
//         if (project.priority != selectedPriority) {
//           return false;
//         }
//       }

//       // Status filter
//       if (selectedStatus != null && selectedStatus != 'all') {
//         if (project.status != selectedStatus) {
//           return false;
//         }
//       }

//       // Category filter - Add this section
//       if (selectedCategory != null && selectedCategory != 'all') {
//         if (project.category != selectedCategory) {
//           return false;
//         }
//       }

//       // Date range filter
//       if (_selectedDateRange != null) {
//         if (project.startDate.isBefore(_selectedDateRange!.start) ||
//             project.dueDate.isAfter(_selectedDateRange!.end)) {
//           return false;
//         }
//       }

//       return true;
//     }).toList();

//     // Always sort pinned projects first
//     filteredProjects.sort((a, b) {
//       if ((a.isPinned ?? false) && !(b.isPinned ?? false)) return -1;
//       if (!(a.isPinned ?? false) && (b.isPinned ?? false)) return 1;
//       // Then apply other sorting
//       if (_selectedNameSort != null) {
//         final comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
//         return _selectedNameSort == 'asc' ? comparison : -comparison;
//       } else if (_selectedStartDateSort != null) {
//         // ... rest of existing sorting logic ...
//       }
//       return 0;
//     });

//     return filteredProjects;
//   }

//   // Add this method to handle pinning/unpinning
//   Future<void> _handlePinProject(Project project) async {
//     try {
//       final updatedProject = project.copyWith(
//         isPinned: !(project.isPinned ?? false), // Handle nullable
//       );
//       await _projectDatabaseService.updateProject(updatedProject);

//       await _loadProjects();

//       _showSuccessMessage(
//         message: (updatedProject.isPinned ?? false) // Handle nullable
//             ? 'Project "${project.name}" has been pinned'
//             : 'Project "${project.name}" has been unpinned',
//         icon: (updatedProject.isPinned ?? false) // Handle nullable
//             ? PhosphorIcons.pushPin(PhosphorIconsStyle.fill)
//             : PhosphorIcons.pushPin(PhosphorIconsStyle.bold),
//       );
//     } catch (e) {
//       _showError('Failed to update project: $e');
//     }
//   }
// }
