import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../models/project.dart';

class ProjectListItem extends StatelessWidget {
  final Project project;
  final bool isChecked;
  final bool isHovered;
  final Function(bool?) onCheckChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onRestore;

  const ProjectListItem({
    super.key,
    required this.project,
    required this.isChecked,
    required this.isHovered,
    required this.onCheckChanged,
    required this.onEdit,
    required this.onDelete,
    this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Checkbox(
                value: onRestore != null ? true : isChecked,
                onChanged: onCheckChanged,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
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
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    decoration: onRestore != null
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                        ),
                        const SizedBox(height: 4),
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
              flex: 2,
              child: _buildDateInfo(
                context,
                'Start',
                project.startDate,
                PhosphorIcons.calendarBlank(PhosphorIconsStyle.bold),
                isStart: true,
              ),
            ),
            Expanded(
              flex: 2,
              child: _buildDateInfo(
                context,
                'Due',
                project.dueDate,
                PhosphorIcons.calendarCheck(PhosphorIconsStyle.bold),
                isStart: false,
              ),
            ),
            Expanded(
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
                            backgroundColor:
                                Theme.of(context).dividerColor.withOpacity(0.2),
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
            Expanded(
              child: _buildPriorityBadge(context, project.priority),
            ),
            Expanded(
              child: _buildStatusBadge(context, project.status),
            ),
            SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (onRestore != null)
                    IconButton(
                      onPressed: onRestore,
                      icon: Icon(
                        PhosphorIcons.arrowCounterClockwise(
                            PhosphorIconsStyle.bold),
                        size: 18,
                        color: AppColors.accent,
                      ),
                      tooltip: 'Restore',
                    )
                  else ...[
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

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: dateColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: dateColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatDate(date),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (!isStart) ...[
                const SizedBox(height: 2),
                Text(
                  isOverdue
                      ? '${daysRemaining.abs()} days overdue'
                      : daysRemaining == 0
                          ? 'Due today'
                          : '$daysRemaining days remaining',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: dateColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
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
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  Widget _buildCategoryIcon(BuildContext context, String category) {
    final categoryInfo = {
      'school': (
        PhosphorIcons.graduationCap(PhosphorIconsStyle.fill),
        AppColors.accent,
        'School Project'
      ),
      'personal': (
        PhosphorIcons.user(PhosphorIconsStyle.fill),
        Colors.purple.shade400,
        'Personal Project'
      ),
      'work': (
        PhosphorIcons.briefcase(PhosphorIconsStyle.fill),
        Colors.blue.shade400,
        'Work Project'
      ),
      'online': (
        PhosphorIcons.globe(PhosphorIconsStyle.fill),
        Colors.green.shade400,
        'Online Project'
      ),
      'other': (
        PhosphorIcons.folder(PhosphorIconsStyle.fill),
        Colors.grey.shade400,
        'Other Project'
      ),
    };

    final (icon, color, tooltip) =
        categoryInfo[category] ?? categoryInfo['other']!;

    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 16,
          color: color,
        ),
      ),
    );
  }
}
