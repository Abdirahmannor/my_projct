import 'package:flutter/material.dart';
import '../../../core/base/base_grid_item.dart';
import '../../../core/base/base_utils.dart';
import '../models/project.dart';

class ProjectGridItem extends BaseGridItem<Project> {
  const ProjectGridItem({
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
            padding: const EdgeInsets.all(12),
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
                    _buildPriorityBadge(context, project.priority),
                  ],
                ),
                Row(
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
              ],
            ),
          ),

          // Project info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (project.archivedDate != null) ...[
                            const SizedBox(height: 4),
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
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  project.description ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                        decoration: onRestore != null
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

          // Progress indicators
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProgressSection(
                  context,
                  'Tasks Progress',
                  project.completedTasks,
                  project.tasks,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateInfo(
                        context,
                        'Start',
                        project.startDate,
                        PhosphorIcons.calendarBlank(PhosphorIconsStyle.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDateInfo(
                        context,
                        'Due',
                        project.dueDate,
                        PhosphorIcons.calendarCheck(PhosphorIconsStyle.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildStatusBadge(context, project.status),
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
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.accent),
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
      BuildContext context, String label, DateTime date, IconData icon) {
    final DateTime now = DateTime.now();
    final int daysRemaining = date.difference(now).inDays;

    final bool isOverdue = label == 'Due' && daysRemaining < 0;
    final bool isUpcoming = label == 'Start' && daysRemaining > 0;

    final Color dateColor = isOverdue
        ? Colors.red.shade400
        : isUpcoming
            ? Colors.green.shade400
            : Theme.of(context).hintColor;

=======
  Widget buildMainContent(BuildContext context) {
>>>>>>> 4bcc1dd96e70ceefa4cbf56552da0566cd5a6bab
    return Column(
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
                      decoration:
                          item.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (item.isPinned ?? false) const Icon(Icons.push_pin, size: 16),
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Priority
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    BaseUtils.getPriorityColor(item.priority).withOpacity(0.1),
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

            // Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: BaseUtils.getStatusColor(item.status).withOpacity(0.1),
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

            // Category if exists
            if (item.category != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          ],
        ),
      ],
    );
  }

  @override
  Widget buildFooter(BuildContext context) {
    return Column(
      children: [
        // Progress Row
        if (item.tasks?.isNotEmpty ?? false) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
          ),
          const SizedBox(height: 8),
        ],

        // Due Date
        Text(
          BaseUtils.getDueStatus(item.dueDate),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),

        // Actions
        buildActions(context),
      ],
    );
  }
}
