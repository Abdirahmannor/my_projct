import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';

class ProjectListItem extends StatelessWidget {
  final String name;
  final String? description;
  final String startDate;
  final String dueDate;
  final int completedTasks;
  final int totalTasks;
  final String priority;
  final String status;
  final bool isChecked;
  final bool isHovered;
  final Function(bool?) onCheckChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onRestore;

  const ProjectListItem({
    super.key,
    required this.name,
    this.description,
    required this.startDate,
    required this.dueDate,
    required this.completedTasks,
    required this.totalTasks,
    required this.priority,
    required this.status,
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
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.3)
              : Theme.of(context).dividerColor,
          width: Theme.of(context).brightness == Brightness.dark ? 2.0 : 1,
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
              child: Transform.scale(
                scale: 0.8,
                child: Checkbox(
                  value: isChecked,
                  onChanged: onCheckChanged,
                  side: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.3)
                        : Theme.of(context).dividerColor,
                    width: Theme.of(context).brightness == Brightness.dark
                        ? 2.0
                        : 1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: isChecked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: isChecked ? Theme.of(context).hintColor : null,
                        ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description!,
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
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: _buildDateInfo(
                context,
                startDate,
                PhosphorIcons.calendarBlank(PhosphorIconsStyle.bold),
                isStart: true,
              ),
            ),
            Expanded(
              flex: 2,
              child: _buildDateInfo(
                context,
                dueDate,
                PhosphorIcons.calendarCheck(PhosphorIconsStyle.bold),
                isStart: false,
              ),
            ),
            Expanded(
              child: _buildProgressIndicator(context),
            ),
            Expanded(
              child: _buildPriorityBadge(context),
            ),
            Expanded(
              child: _buildStatusBadge(context),
            ),
            SizedBox(
              width: 80,
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
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                      visualDensity: VisualDensity.compact,
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
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Edit',
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(
                        PhosphorIcons.trash(PhosphorIconsStyle.bold),
                        size: 18,
                        color: Colors.red,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
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

  Widget _buildProgressIndicator(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tooltip(
          message: '$completedTasks of $totalTasks tasks completed',
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
                  value: totalTasks > 0 ? completedTasks / totalTasks : 0,
                  backgroundColor:
                      Theme.of(context).dividerColor.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.accent.withOpacity(0.9),
                  ),
                  strokeWidth: 4,
                ),
                Center(
                  child: Text(
                    '$completedTasks/$totalTasks',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
    );
  }

  Widget _buildPriorityBadge(BuildContext context) {
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
          message:
              priorityMessages[priority.toLowerCase()] ?? 'Unknown priority',
          child: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colors[priority.toLowerCase()]?.withOpacity(0.3) ??
                    Colors.grey.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                CircularProgressIndicator(
                  value: priorityValues[priority.toLowerCase()] ?? 0,
                  backgroundColor:
                      colors[priority.toLowerCase()]?.withOpacity(0.1) ??
                          Colors.grey.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colors[priority.toLowerCase()] ?? Colors.grey,
                  ),
                  strokeWidth: 4,
                ),
                Center(
                  child: Icon(
                    _getPriorityIcon(),
                    size: 16,
                    color: colors[priority.toLowerCase()]?.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tooltip(
          message: statusMessages[status.toLowerCase()] ?? 'Unknown status',
          child: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colors[status.toLowerCase()]?.withOpacity(0.3) ??
                    Colors.grey.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                CircularProgressIndicator(
                  value: statusValues[status.toLowerCase()] ?? 0,
                  backgroundColor:
                      colors[status.toLowerCase()]?.withOpacity(0.1) ??
                          Colors.grey.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colors[status.toLowerCase()] ?? Colors.grey,
                  ),
                  strokeWidth: 4,
                ),
                Center(
                  child: Icon(
                    _getStatusIcon(),
                    size: 16,
                    color: colors[status.toLowerCase()]?.withOpacity(0.8),
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
    String date,
    IconData icon, {
    required bool isStart,
  }) {
    final DateTime now = DateTime.now();
    final DateTime dateTime = _parseDate(date);
    final int daysRemaining = dateTime.difference(now).inDays;

    final bool isOverdue = !isStart && daysRemaining < 0;
    final bool isUpcoming = isStart && daysRemaining > 0;

    final Color dateColor = isOverdue
        ? Colors.red.shade400
        : isUpcoming
            ? Colors.green.shade400
            : daysRemaining <= 2 && !isStart
                ? Colors.orange.shade400
                : Theme.of(context).hintColor;

    final String timeString = _formatTime(dateTime);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: dateColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
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
                _formatDateCompact(dateTime),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              Wrap(
                spacing: 4,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: dateColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          PhosphorIcons.clock(PhosphorIconsStyle.fill),
                          size: 10,
                          color: dateColor,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          timeString,
                          style: TextStyle(
                            color: dateColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isStart)
                    Text(
                      isOverdue
                          ? '${daysRemaining.abs()}d overdue'
                          : daysRemaining == 0
                              ? 'Due today'
                              : '${daysRemaining}d remaining',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: dateColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getPriorityIcon() {
    switch (priority.toLowerCase()) {
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

  IconData _getStatusIcon() {
    switch (status.toLowerCase()) {
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

  DateTime _parseDate(String date) {
    final parts = date.split(' ');
    final day = int.parse(parts[0]);
    final month = _getMonth(parts[1]);
    final year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  int _getMonth(String month) {
    const months = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12
    };
    return months[month.replaceAll(',', '')] ?? 1;
  }

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

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
