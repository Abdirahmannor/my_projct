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

  const TaskListItem({
    super.key,
    required this.task,
    required this.isChecked,
    required this.isHovered,
    required this.onCheckChanged,
    required this.onEdit,
    required this.onDelete,
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
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          // Checkbox
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: isChecked,
                onChanged: onCheckChanged,
              ),
            ),
          ),
          // Task Info
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task['name'],
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (task['description'] != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      task['description'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Project
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    PhosphorIcons.folder(PhosphorIconsStyle.fill),
                    size: 14,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
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
          ),
          // Due Date
          Expanded(
            flex: 2,
            child: _buildDueDate(context),
          ),
          // Priority
          Expanded(
            child: _buildPriorityBadge(context),
          ),
          // Status
          Expanded(
            child: _buildStatusBadge(context),
          ),
          // Progress
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: task['completedSubtasks'] / task['totalSubtasks'],
                      backgroundColor:
                          Theme.of(context).dividerColor.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        task['completedSubtasks'] == task['totalSubtasks']
                            ? Colors.green.shade400
                            : AppColors.accent,
                      ),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${task['completedSubtasks']}/${task['totalSubtasks']} subtasks',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                        ),
                  ),
                ],
              ),
            ),
          ),
          // Actions
          if (isHovered)
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
            )
          else
            const SizedBox(width: 100),
        ],
      ),
    );
  }

  Widget _buildDueDate(BuildContext context) {
    final DateTime dueDate = DateTime.parse(task['dueDate']);
    final DateTime now = DateTime.now();
    final int daysRemaining = dueDate.difference(now).inDays;
    final bool isOverdue = daysRemaining < 0;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isOverdue ? Colors.red.shade50 : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            PhosphorIcons.clock(PhosphorIconsStyle.fill),
            size: 14,
            color: isOverdue ? Colors.red.shade400 : Colors.orange.shade400,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isOverdue
                  ? '${daysRemaining.abs()} days overdue'
                  : daysRemaining == 0
                      ? 'Due today'
                      : '$daysRemaining days left',
              style: TextStyle(
                color: isOverdue ? Colors.red.shade400 : Colors.orange.shade400,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              task['dueDate'],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                    fontSize: 11,
                  ),
            ),
          ],
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors[task['priority']]?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: colors[task['priority']],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            task['priority'].toString().capitalize(),
            style: TextStyle(
              color: colors[task['priority']],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final colors = {
      'to do': Colors.grey.shade400,
      'in progress': Colors.blue.shade400,
      'done': Colors.green.shade400,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors[task['status']]?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: colors[task['status']],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            task['status'].toString().capitalize(),
            style: TextStyle(
              color: colors[task['status']],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
