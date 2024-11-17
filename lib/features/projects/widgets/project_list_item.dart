import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../models/project.dart';
import '../constants/project_list_layout.dart';

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
        padding: EdgeInsets.symmetric(
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
            SizedBox(width: ProjectListLayout.iconSpacing),
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
              flex: ProjectListLayout.nameColumnFlex,
              child: Row(
                children: [
                  _buildCategoryIcon(context, project.category ?? ''),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
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
    );
  }

  Widget _buildCategoryIcon(BuildContext context, String category) {
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
        categoryInfo[category.toLowerCase()] ?? categoryInfo['other']!;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        size: 16,
        color: color,
      ),
    );
  }

  Widget _buildDateInfo(
    BuildContext context,
    String label,
    DateTime date,
    IconData icon, {
    required bool isStart,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDate(date),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
          ],
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
}
