import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/string_extensions.dart';

class ProjectGridItem extends StatelessWidget {
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

  const ProjectGridItem({
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
            padding: const EdgeInsets.all(16),
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
                    _buildPriorityBadge(context, priority),
                  ],
                ),
                Row(
                  children: [
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
                ),
              ],
            ),
          ),

          // Project info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  description ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const Spacer(),

          // Progress indicators
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProgressSection(
                  context,
                  'Tasks Progress',
                  completedTasks,
                  totalTasks,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateInfo(
                        context,
                        'Start',
                        startDate,
                        PhosphorIcons.calendarBlank(PhosphorIconsStyle.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDateInfo(
                        context,
                        'Due',
                        dueDate,
                        PhosphorIcons.calendarCheck(PhosphorIconsStyle.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildStatusBadge(context, status),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(
      BuildContext context, String title, int completed, int total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).hintColor,
              ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: completed / total,
                backgroundColor:
                    Theme.of(context).dividerColor.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                minHeight: 8,
              ),
            ),
            Positioned(
              right: 0,
              top: -4,
              child: Text(
                '$completed/$total',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateInfo(
      BuildContext context, String label, String date, IconData icon) {
    // Calculate days remaining or days passed
    final DateTime now = DateTime.now();
    final DateTime dateTime = _parseDate(date);
    final int daysRemaining = dateTime.difference(now).inDays;

    final bool isOverdue = label == 'Due' && daysRemaining < 0;
    final bool isUpcoming = label == 'Start' && daysRemaining > 0;

    final Color dateColor = isOverdue
        ? Colors.red.shade400
        : isUpcoming
            ? Colors.green.shade400
            : Theme.of(context).hintColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
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
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (label == 'Due') ...[
          const SizedBox(height: 4),
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
    );
  }

  DateTime _parseDate(String date) {
    final parts = date.split(' ');
    final day = int.parse(parts[0]);
    final month = _getMonth(parts[1].replaceAll(',', ''));
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
    return months[month] ?? 1;
  }

  Widget _buildPriorityBadge(BuildContext context, String priority) {
    final colors = {
      'high': Colors.red.shade400,
      'medium': Colors.orange.shade400,
      'low': Colors.green.shade400,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors[priority]?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors[priority]?.withOpacity(0.3) ?? Colors.transparent,
        ),
      ),
      child: Text(
        priority.capitalize(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors[priority],
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    final colors = {
      'not started': Colors.grey.shade400,
      'in progress': Colors.blue.shade400,
      'on hold': Colors.orange.shade400,
      'completed': Colors.green.shade400,
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colors[status]?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colors[status]?.withOpacity(0.3) ?? Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            getStatusIcon(),
            size: 14,
            color: colors[status],
          ),
          const SizedBox(width: 8),
          Text(
            status.capitalize(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors[status],
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
