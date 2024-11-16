import 'package:flutter/material.dart';
import '../../../core/base/base_list_item.dart';
import '../../../core/base/base_utils.dart';
import '../models/project.dart';

class ProjectListItem extends BaseListItem<Project> {
  const ProjectListItem({
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
          child: Column(
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
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],

              // Status Row
              Row(
                children: [
                  // Priority
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

                  // Status
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
                  const SizedBox(width: 8),

                  // Category if exists
                  if (item.category != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
                    const SizedBox(width: 8),
                  ],

                  // Progress
                  if (item.tasks > 0) ...[
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
                      '${item.completedTasks}/${item.tasks}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],

                  const Spacer(),

                  // Due Date
                  Text(
                    BaseUtils.getDueStatus(item.dueDate),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        buildActions(context),
      ],
    );
  }
}
