import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../models/project.dart';

class ProjectGridItem extends StatelessWidget {
  final Project project;
  final bool isHovered;
  final bool isChecked;
  final Function(bool?)? onCheckChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onRestore;

  const ProjectGridItem({
    super.key,
    required this.project,
    required this.isHovered,
    this.isChecked = false,
    this.onCheckChanged,
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
          _buildHeader(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (onCheckChanged != null)
                    Checkbox(
                      value: isChecked,
                      onChanged: onCheckChanged,
                    ),
                  _buildTitle(context),
                  const SizedBox(height: 8),
                  _buildDescription(context),
                  const SizedBox(height: 16),
                  _buildProgress(context),
                  const Spacer(),
                  _buildFooter(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCategoryBadge(context),
          if (isHovered)
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
    );
  }

  Widget _buildCategoryBadge(BuildContext context) {
    final categoryInfo = {
      'school': (
        PhosphorIcons.graduationCap(PhosphorIconsStyle.fill),
        AppColors.accent
      ),
      'personal': (PhosphorIcons.user(PhosphorIconsStyle.fill), Colors.purple),
      'work': (PhosphorIcons.briefcase(PhosphorIconsStyle.fill), Colors.blue),
      'other': (PhosphorIcons.folder(PhosphorIconsStyle.fill), Colors.grey),
    };

    final (icon, color) =
        categoryInfo[project.category?.toLowerCase()] ?? categoryInfo['other']!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            project.category?.toUpperCase() ?? 'OTHER',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        if (project.isPinned ?? false)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              PhosphorIcons.pushPin(PhosphorIconsStyle.fill),
              size: 14,
              color: AppColors.accent,
            ),
          ),
        Expanded(
          child: Text(
            project.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      project.description ?? '',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).hintColor,
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildProgress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
            Text(
              '${(project.completedTasks / project.tasks * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: project.completedTasks / project.tasks,
          backgroundColor: Theme.of(context).dividerColor,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateInfo(context),
        _buildPriorityBadge(context),
      ],
    );
  }

  Widget _buildDateInfo(BuildContext context) {
    final DateTime now = DateTime.now();
    final int daysRemaining = project.dueDate.difference(now).inDays;
    final bool isOverdue = daysRemaining < 0;

    final Color dateColor = isOverdue
        ? Colors.red.shade400
        : daysRemaining <= 2
            ? Colors.orange.shade400
            : Theme.of(context).hintColor;

    return Row(
      children: [
        Icon(
          PhosphorIcons.clock(PhosphorIconsStyle.bold),
          size: 14,
          color: dateColor,
        ),
        const SizedBox(width: 4),
        Text(
          isOverdue
              ? '${daysRemaining.abs()}d overdue'
              : daysRemaining == 0
                  ? 'Due today'
                  : '${daysRemaining}d remaining',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: dateColor,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  Widget _buildPriorityBadge(BuildContext context) {
    final priorityColors = {
      'high': Colors.red.shade400,
      'medium': Colors.orange.shade400,
      'low': Colors.green.shade400,
    };

    final color = priorityColors[project.priority] ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        project.priority.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
