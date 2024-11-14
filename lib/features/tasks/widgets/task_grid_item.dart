import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/string_extensions.dart';

class TaskGridItem extends StatelessWidget {
  final Map<String, dynamic> task;
  final bool isChecked;
  final bool isHovered;
  final Function(bool?) onCheckChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onRestore;

  const TaskGridItem({
    super.key,
    required this.task,
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
      decoration: BoxDecoration(
        color: isHovered
            ? Theme.of(context).hoverColor
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with checkbox and actions
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: isChecked,
                        onChanged: onCheckChanged,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildPriorityBadge(context, task['priority']),
                  ],
                ),
                Row(
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
              ],
            ),
          ),

          // Task info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['name'],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: isChecked
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: isChecked ? Theme.of(context).hintColor : null,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                if (task['description'] != null)
                  Text(
                    task['description'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).hintColor,
                          decoration: isChecked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          const Spacer(),

          // Project and Due Date
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Project Badge
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        PhosphorIcons.folder(PhosphorIconsStyle.fill),
                        size: 14,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          task['project'],
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildDateInfo(
                  context,
                  'Due',
                  task['dueDate'],
                  PhosphorIcons.calendarCheck(PhosphorIconsStyle.bold),
                ),
                const SizedBox(height: 12),
                _buildStatusBadge(context, task['status']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(BuildContext context, String priority) {
    final colors = {
      'critical': Colors.red.shade600,
      'high': Colors.red.shade400,
      'medium': Colors.orange.shade400,
      'low': Colors.green.shade400,
    };

    final priorityMessages = {
      'critical': 'Critical Priority - Immediate attention required',
      'high': 'High Priority - Urgent attention needed',
      'medium': 'Medium Priority - Important but not urgent',
      'low': 'Low Priority - Can be handled later',
    };

    final priorityValues = {
      'critical': 1.0,
      'high': 0.75,
      'medium': 0.5,
      'low': 0.25,
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
                    _getPriorityIcon(priority),
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
      'to do': Colors.blue.shade400,
      'in progress': Colors.orange.shade400,
      'done': Colors.green.shade400,
      'blocked': Colors.red.shade400,
      'review': Colors.purple.shade400,
      'on hold': Colors.grey.shade400,
    };

    final statusMessages = {
      'to do': 'Task has not been started',
      'in progress': 'Task is being worked on',
      'done': 'Task has been completed',
      'blocked': 'Task is blocked',
      'review': 'Task is under review',
      'on hold': 'Task is on hold',
    };

    final statusValues = {
      'to do': 0.0,
      'in progress': 0.5,
      'done': 1.0,
      'blocked': 0.25,
      'review': 0.75,
      'on hold': 0.15,
    };

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
                    _getStatusIcon(status),
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
    String date,
    IconData icon,
  ) {
    final DateTime now = DateTime.now();
    final DateTime dateTime = _parseDate(date);
    final int daysRemaining = dateTime.difference(now).inDays;
    final bool isOverdue = daysRemaining < 0;

    final Color dateColor = isOverdue
        ? Colors.red.shade400
        : daysRemaining <= 2
            ? Colors.orange.shade400
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
                date,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
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
          ),
        ),
      ],
    );
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return PhosphorIcons.warning(PhosphorIconsStyle.fill);
      case 'high':
        return PhosphorIcons.arrowUp(PhosphorIconsStyle.fill);
      case 'medium':
        return PhosphorIcons.minus(PhosphorIconsStyle.fill);
      case 'low':
        return PhosphorIcons.arrowDown(PhosphorIconsStyle.fill);
      default:
        return PhosphorIcons.minus(PhosphorIconsStyle.fill);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'to do':
        return PhosphorIcons.circle(PhosphorIconsStyle.fill);
      case 'in progress':
        return PhosphorIcons.play(PhosphorIconsStyle.fill);
      case 'done':
        return PhosphorIcons.check(PhosphorIconsStyle.fill);
      case 'blocked':
        return PhosphorIcons.x(PhosphorIconsStyle.fill);
      case 'review':
        return PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.fill);
      case 'on hold':
        return PhosphorIcons.pause(PhosphorIconsStyle.fill);
      default:
        return PhosphorIcons.circle(PhosphorIconsStyle.fill);
    }
  }

  DateTime _parseDate(String date) {
    try {
      return DateTime.parse(date);
    } catch (e) {
      try {
        final parts = date.split(' ');
        if (parts.length >= 3) {
          final day = int.parse(parts[0].replaceAll(',', ''));
          final month = _getMonth(parts[1].replaceAll(',', ''));
          final year = int.parse(parts[2]);
          return DateTime(year, month, day);
        } else {
          return DateTime.now();
        }
      } catch (e) {
        return DateTime.now();
      }
    }
  }

  int _getMonth(String month) {
    final monthMap = {
      'jan': 1,
      'january': 1,
      'feb': 2,
      'february': 2,
      'mar': 3,
      'march': 3,
      'apr': 4,
      'april': 4,
      'may': 5,
      'jun': 6,
      'june': 6,
      'jul': 7,
      'july': 7,
      'aug': 8,
      'august': 8,
      'sep': 9,
      'september': 9,
      'oct': 10,
      'october': 10,
      'nov': 11,
      'november': 11,
      'dec': 12,
      'december': 12,
    };

    return monthMap[month.toLowerCase()] ?? 1;
  }
}
