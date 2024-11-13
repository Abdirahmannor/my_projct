import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/string_extensions.dart';

class ProjectListItem extends StatelessWidget {
  final Map<String, dynamic> project;
  final bool isChecked;
  final bool isHovered;
  final Function(bool?) onCheckChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProjectListItem({
    super.key,
    required this.project,
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
                value: isChecked,
                onChanged: onCheckChanged,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project['name'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    project['description'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                project['startDate'],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                project['dueDate'],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
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
                          value: project['completedTasks'] / project['tasks'],
                          backgroundColor:
                              Theme.of(context).dividerColor.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.accent.withOpacity(0.9),
                          ),
                          strokeWidth: 4,
                        ),
                        Center(
                          child: Text(
                            '${project['completedTasks']}/${project['tasks']}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildPriorityBadge(context, project['priority']),
            ),
            Expanded(
              child: _buildStatusBadge(context, project['status']),
            ),
            SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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

    final priorityValues = {
      'high': 1.0,
      'medium': 0.66,
      'low': 0.33,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
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
        Container(
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
      ],
    );
  }
}
