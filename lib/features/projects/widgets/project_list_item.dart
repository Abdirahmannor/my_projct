import 'package:flutter/material.dart';
import '../../../core/base/base_list_item.dart';
import '../../../core/base/base_utils.dart';
import '../models/project.dart';
<<<<<<< HEAD
import '../screens/projects_screen.dart';
import '../screens/project_detail_screen.dart';

class ProjectListItem extends StatelessWidget {
  final Project project;
  final bool isChecked;
  final bool isHovered;
  final Function(bool?) onCheckChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onRestore;
=======
>>>>>>> 4bcc1dd96e70ceefa4cbf56552da0566cd5a6bab

class ProjectListItem extends BaseListItem<Project> {
  const ProjectListItem({
    super.key,
    required super.item,
    required super.isChecked,
    required super.isHovered,
    required super.onCheckChanged,
    required super.onEdit,
    required super.onDelete,
    super.onRestore,
  });

  @override
<<<<<<< HEAD
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('=== Project Tap Debug ===');
        print('Tapping project: ${project.name}');
        print('Project data: ${project.toMap()}');
        print('Project status: ${project.status}');
        print('Project priority: ${project.priority}');

        try {
          project.validate();
          print('Project validation passed');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                print('Building ProjectDetailScreen for ${project.name}');
                return ProjectDetailScreen(project: project);
              },
            ),
          ).then((_) {
            print('Returned from ProjectDetailScreen');
          });
        } catch (e, stackTrace) {
          print('Error during navigation: $e');
          print('Stack trace: $stackTrace');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isHovered
              ? Theme.of(context).hoverColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
          boxShadow: [
            if (isHovered)
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: ProjectListLayout.rowHorizontalPadding,
            vertical: ProjectListLayout.rowVerticalPadding,
          ),
          child: Row(
            children: [
              SizedBox(
                width: ProjectListLayout.checkboxWidth,
                child: Checkbox(
                  value: isChecked,
                  onChanged: onCheckChanged,
                ),
              ),
              const SizedBox(width: ProjectListLayout.iconSpacing),
              Expanded(
                flex: ProjectListLayout.nameColumnFlex,
                child: Row(
                  children: [
                    _buildCategoryIcon(context, project.category),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  decoration: onRestore != null
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                          ),
                          const SizedBox(height: 4),
                          if (project.archivedDate != null) ...[
                            Text(
                              'Archived on ${_formatDate(project.archivedDate!)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.orange.shade400,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const SizedBox(height: 4),
                          ],
                          Text(
                            project.description ?? '',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).hintColor,
                                      decoration: onRestore != null
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: ProjectListLayout.dateColumnFlex,
                child: _buildDateInfo(
                  context,
                  'Start',
                  project.startDate,
                  PhosphorIcons.calendarBlank(PhosphorIconsStyle.bold),
                  isStart: true,
                ),
              ),
              Expanded(
                flex: ProjectListLayout.dateColumnFlex,
                child: _buildDateInfo(
                  context,
                  'Due',
                  project.dueDate,
                  PhosphorIcons.calendarCheck(PhosphorIconsStyle.bold),
                  isStart: false,
                ),
              ),
              SizedBox(
                width: ProjectListLayout.tasksWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tooltip(
                      message:
                          '${project.completedTasks} of ${project.tasks} tasks completed',
                      child: Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                        ),
                        child: Stack(
                          children: [
                            CircularProgressIndicator(
                              value: project.completedTasks / project.tasks,
                              backgroundColor: Theme.of(context)
                                  .dividerColor
                                  .withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.accent.withOpacity(0.9),
                              ),
                              strokeWidth: 4,
                            ),
                            Center(
                              child: Text(
                                '${project.completedTasks}/${project.tasks}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: ProjectListLayout.priorityWidth,
                child: _buildPriorityBadge(context, project.priority),
              ),
              SizedBox(
                width: ProjectListLayout.statusWidth,
                child: _buildStatusBadge(context, project.status),
              ),
              SizedBox(
                width: ProjectListLayout.actionsWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (onRestore != null) ...[
                      IconButton(
                        onPressed: onRestore,
                        icon: Icon(
                          PhosphorIcons.arrowCounterClockwise(
                              PhosphorIconsStyle.bold),
                          size: 18,
                          color: AppColors.accent,
                        ),
                        tooltip: 'Restore',
                      ),
                      IconButton(
                        onPressed: onDelete,
                        icon: Icon(
                          PhosphorIcons.trash(PhosphorIconsStyle.bold),
                          size: 18,
                          color: Colors.red,
                        ),
                        tooltip: project.status == 'completed'
                            ? 'Move to Recycle Bin'
                            : 'Delete Permanently',
                      ),
                    ] else ...[
                      IconButton(
                        onPressed: onEdit,
                        icon: Icon(
                          PhosphorIcons.pencilSimple(PhosphorIconsStyle.bold),
                          size: 18,
                          color: Theme.of(context).hintColor,
                        ),
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        onPressed: onDelete,
                        icon: Icon(
                          PhosphorIcons.trash(PhosphorIconsStyle.bold),
                          size: 18,
                          color: Colors.red,
                        ),
                        tooltip: 'Delete',
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(BuildContext context, String priority) {
    final colors = {
      'high': Colors.red.shade400,
      'medium': Colors.orange.shade400,
      'low': Colors.green.shade400,
    };

    final priorityMessages = {
      'high': 'High Priority - Urgent attention needed',
      'medium': 'Medium Priority - Important but not urgent',
      'low': 'Low Priority - Can be handled later',
    };

    final priorityValues = {
      'high': 1.0,
      'medium': 0.66,
      'low': 0.33,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tooltip(
          message: priorityMessages[priority] ?? 'Unknown priority',
          child: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colors[priority]?.withOpacity(0.3) ??
                    Colors.grey.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                CircularProgressIndicator(
                  value: priorityValues[priority] ?? 0,
                  backgroundColor: colors[priority]?.withOpacity(0.1) ??
                      Colors.grey.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colors[priority] ?? Colors.grey,
                  ),
                  strokeWidth: 4,
                ),
                Center(
                  child: Icon(
                    PhosphorIcons.warning(PhosphorIconsStyle.fill),
                    size: 16,
                    color: colors[priority]?.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    final colors = {
      'not started': Colors.grey.shade400,
      'in progress': Colors.blue.shade400,
      'on hold': Colors.orange.shade400,
      'completed': Colors.green.shade400,
    };

    final statusMessages = {
      'not started': 'Project has not been started yet',
      'in progress': 'Project is currently being worked on',
      'on hold': 'Project is temporarily paused',
      'completed': 'Project has been completed',
    };

    final statusValues = {
      'not started': 0.0,
      'in progress': 0.5,
      'on hold': 0.75,
      'completed': 1.0,
    };

    IconData getStatusIcon() {
      switch (status) {
        case 'not started':
          return PhosphorIcons.pause(PhosphorIconsStyle.fill);
        case 'in progress':
          return PhosphorIcons.play(PhosphorIconsStyle.fill);
        case 'on hold':
          return PhosphorIcons.clock(PhosphorIconsStyle.fill);
        case 'completed':
          return PhosphorIcons.check(PhosphorIconsStyle.fill);
        default:
          return PhosphorIcons.circle(PhosphorIconsStyle.fill);
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tooltip(
          message: statusMessages[status] ?? 'Unknown status',
          child: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colors[status]?.withOpacity(0.3) ??
                    Colors.grey.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                CircularProgressIndicator(
                  value: statusValues[status] ?? 0,
                  backgroundColor: colors[status]?.withOpacity(0.1) ??
                      Colors.grey.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colors[status] ?? Colors.grey,
                  ),
                  strokeWidth: 4,
                ),
                Center(
                  child: Icon(
                    getStatusIcon(),
                    size: 16,
                    color: colors[status]?.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateInfo(
    BuildContext context,
    String label,
    DateTime date,
    IconData icon, {
    required bool isStart,
  }) {
    final DateTime now = DateTime.now();
    final int daysRemaining = date.difference(now).inDays;

    final bool isOverdue = !isStart && daysRemaining < 0;
    final bool isUpcoming = isStart && daysRemaining > 0;

    final Color dateColor = isOverdue
        ? Colors.red.shade400
        : isUpcoming
            ? Colors.green.shade400
            : Theme.of(context).hintColor;

=======
  Widget buildContent(BuildContext context) {
>>>>>>> 4bcc1dd96e70ceefa4cbf56552da0566cd5a6bab
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Pin
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: item.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (item.isPinned ?? false)
                    const Icon(Icons.push_pin, size: 16),
                ],
              ),
              const SizedBox(height: 4),

              // Description
              if (item.description != null) ...[
                Text(
                  item.description!,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],

              // Status Row
              Row(
                children: [
                  // Priority
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: BaseUtils.getPriorityColor(item.priority)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      BaseUtils.capitalize(item.priority),
                      style: TextStyle(
                        color: BaseUtils.getPriorityColor(item.priority),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Status
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: BaseUtils.getStatusColor(item.status)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      BaseUtils.capitalize(item.status),
                      style: TextStyle(
                        color: BaseUtils.getStatusColor(item.status),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Category if exists
                  if (item.category != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        BaseUtils.capitalize(item.category!),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

                  // Progress
                  if (item.tasks?.isNotEmpty ?? false) ...[
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        value: item.progress,
                        strokeWidth: 2,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation(
                          item.isCompleted
                              ? Colors.green
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${item.tasks?.length ?? 0} tasks',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],

                  const Spacer(),

                  // Due Date
                  Text(
                    BaseUtils.getDueStatus(item.dueDate),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        buildActions(context),
      ],
    );
  }
}
