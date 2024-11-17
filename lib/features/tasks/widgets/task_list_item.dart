import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';

class TaskListItem extends StatelessWidget {
  final Map<String, dynamic> task;
  final bool isChecked;
  final bool isHovered;
  final Function(bool?) onCheckChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onRestore;
=======
import '../../../core/base/base_list_item.dart';
import '../../../core/base/base_utils.dart';
import '../../../core/base/base_styles.dart';
import '../models/task.dart';
>>>>>>> 4bcc1dd96e70ceefa4cbf56552da0566cd5a6bab

class TaskListItem extends BaseListItem<Task> {
  const TaskListItem({
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
  Widget buildContent(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Pin
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: BaseStyles.getTitleStyle(context).copyWith(
                        decoration: item.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (item.isPinned ?? false)
                    const Icon(Icons.push_pin, size: 16),
                ],
              ),
              const SizedBox(height: 4),

              // Description
              if (item.description != null) ...[
                Text(
                  item.description!,
                  style: BaseStyles.getSubtitleStyle(context).copyWith(
                    decoration:
                        item.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],

              // Task Info Row
              Row(
                children: [
                  // Priority Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: BaseUtils.getPriorityColor(item.priority)
                          .withOpacity(0.1),
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
                  const SizedBox(width: 8),

                  // Status Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: BaseUtils.getStatusColor(item.status)
                          .withOpacity(0.1),
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
                ],
              ),
            ],
          ),
        ),

        // Due Date
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                BaseUtils.formatDate(item.dueDate),
                style: BaseStyles.getSubtitleStyle(context),
              ),
              Text(
                BaseUtils.getDueStatus(item.dueDate),
                style: TextStyle(
                  color: item.isOverdue ? Colors.red : Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        // Progress
        if (item.estimatedHours != null) ...[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BaseStyles.buildProgressIndicator(
                  context,
                  item.progress,
                  size: 32,
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.actualHours ?? 0}/${item.estimatedHours}h',
                  style: BaseStyles.getSubtitleStyle(context),
                ),
              ],
            ),
          ),
        ],

        // Assignees
        if (item.assignees != null && item.assignees!.isNotEmpty)
          Expanded(
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: item.assignees!.map((assignee) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    assignee,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

        // Labels
        if (item.labels != null && item.labels!.isNotEmpty)
          Expanded(
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: item.labels!.map((label) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

        // Actions
        const SizedBox(width: 16),
        buildActions(context),
      ],
    );
  }
}
