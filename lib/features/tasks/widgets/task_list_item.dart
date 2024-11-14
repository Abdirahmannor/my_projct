import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/string_extensions.dart';

class TaskListItem extends StatelessWidget {
  final Map<String, dynamic> task;
  final bool isChecked;
  final bool isHovered;
  final Function(bool?) onCheckChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onRestore;

  const TaskListItem({
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            // Checkbox
            SizedBox(
              width: 16,
              child: Transform.scale(
                scale: 0.8,
                child: Checkbox(
                  value: isChecked,
                  onChanged: onCheckChanged,
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Task Info
            Expanded(
              flex: 2,
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
                  ),
                  const SizedBox(height: 4),
                  if (task['description'] != null)
                    Text(
                      task['description'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).hintColor,
                            decoration: isChecked
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // Project Badge
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Icon(
                        PhosphorIcons.folder(PhosphorIconsStyle.fill),
                        size: 14,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['project'],
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Project',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 10,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  if (isHovered)
                    Tooltip(
                      message: 'Go to project',
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            PhosphorIcons.arrowSquareOut(
                                PhosphorIconsStyle.bold),
                            size: 12,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Due Date
            Expanded(
              child: _buildDateInfo(
                context,
                'Due',
                task['dueDate'],
                PhosphorIcons.calendarCheck(PhosphorIconsStyle.bold),
              ),
            ),

            // Priority Badge
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        task['priority']?.toString() ?? '',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.priorityColors[task['priority']] ??
                              Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 28,
                        height: 28,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color:
                                (AppColors.priorityColors[task['priority']] ??
                                        Colors.grey)
                                    .withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            _getPriorityIcon(task['priority']),
                            size: 14,
                            color:
                                (AppColors.priorityColors[task['priority']] ??
                                        Colors.grey)
                                    .withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            // Status Badge
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildStatusBadge(context, task['status']),
                ],
              ),
            ),

            // Actions
            SizedBox(
              width: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (onRestore != null)
                    IconButton(
                      onPressed: onRestore,
                      icon: Icon(
                        PhosphorIcons.arrowCounterClockwise(
                            PhosphorIconsStyle.bold),
                        size: 14,
                        color: AppColors.accent,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Restore',
                    )
                  else ...[
                    IconButton(
                      onPressed: onEdit,
                      icon: Icon(
                        PhosphorIcons.pencilSimple(PhosphorIconsStyle.bold),
                        size: 14,
                        color: Theme.of(context).hintColor,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(
                        PhosphorIcons.trash(PhosphorIconsStyle.bold),
                        size: 14,
                        color: Colors.red,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      visualDensity: VisualDensity.compact,
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
            width: 28,
            height: 28,
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

    // Format time more compactly
    final String timeString = _formatTime(dateTime);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: dateColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 14,
            color: dateColor,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      _formatDateCompact(dateTime),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                    decoration: BoxDecoration(
                      color: dateColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      timeString,
                      style: TextStyle(
                        color: dateColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                isOverdue
                    ? '${daysRemaining.abs()}d'
                    : daysRemaining == 0
                        ? 'Today'
                        : '${daysRemaining}d',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: dateColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Add this new helper method for compact date formatting
  String _formatDateCompact(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]}';
  }

  // Update the _formatTime method to be more compact:
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final hour12 = hour > 12
        ? hour - 12
        : hour == 0
            ? 12
            : hour;
    // Even more compact format
    return minute == '00'
        ? '$hour12${hour >= 12 ? "p" : "a"}'
        : '$hour12$minute${hour >= 12 ? "p" : "a"}';
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
      if (date.contains('T')) {
        // Handle ISO format
        return DateTime.parse(date);
      } else {
        // Handle custom format
        final parts = date.split(' ');
        if (parts.length >= 3) {
          final day = int.parse(parts[0].replaceAll(',', ''));
          final month = _getMonth(parts[1].replaceAll(',', ''));
          final year = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
    return DateTime.now();
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
