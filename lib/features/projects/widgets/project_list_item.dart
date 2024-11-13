import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';

class ProjectListItem extends StatefulWidget {
  final Map<String, dynamic> project;
  final bool isChecked;
  final Function(bool?) onCheckChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isHovered;

  const ProjectListItem({
    super.key,
    required this.project,
    required this.isChecked,
    required this.onCheckChanged,
    required this.onEdit,
    required this.onDelete,
    required this.isHovered,
  });

  @override
  State<ProjectListItem> createState() => _ProjectListItemState();
}

class _ProjectListItemState extends State<ProjectListItem> {
  bool showDeleteConfirm = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: widget.isHovered
            ? Theme.of(context).cardColor.withOpacity(0.8)
            : Theme.of(context).cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getPriorityColor(widget.project['priority']).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: widget.isHovered
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Checkbox(
              value: widget.isChecked,
              onChanged: widget.onCheckChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.project['name'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: widget.isChecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                if (widget.project['description'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.project['description'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withOpacity(0.7),
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
            child: Row(
              children: [
                Icon(
                  PhosphorIcons.calendar(PhosphorIconsStyle.bold),
                  size: 14,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.project['startDate'] ?? '15 Sep, 2024',
                  style: TextStyle(
                    fontSize: 14,
                    decoration: widget.isChecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(
                  PhosphorIcons.clockCountdown(PhosphorIconsStyle.bold),
                  size: 14,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.project['dueDate'] ?? '15 Oct, 2024',
                  style: TextStyle(
                    fontSize: 14,
                    decoration: widget.isChecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(
                  PhosphorIcons.listChecks(PhosphorIconsStyle.bold),
                  size: 14,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.project['tasks'] ?? 5}',
                  style: TextStyle(
                    fontSize: 14,
                    decoration: widget.isChecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: _getPriorityBackgroundColor(widget.project['priority']),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _getPriorityText(widget.project['priority']),
                style: TextStyle(
                  color: _getPriorityColor(widget.project['priority']),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: _getStatusBackgroundColor(widget.project['status']),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _getStatusText(widget.project['status']),
                style: TextStyle(
                  color: _getStatusColor(widget.project['status']),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    // View project details
                  },
                  icon: Icon(
                    PhosphorIcons.eye(PhosphorIconsStyle.bold),
                    size: 16,
                    color: widget.isHovered ? AppColors.accent : null,
                  ),
                  tooltip: 'View Details',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: widget.onEdit,
                  icon: Icon(
                    PhosphorIcons.pencilSimple(PhosphorIconsStyle.bold),
                    size: 16,
                    color: widget.isHovered ? AppColors.warning : null,
                  ),
                  tooltip: 'Edit Project',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    if (!showDeleteConfirm) {
                      setState(() => showDeleteConfirm = true);
                      Future.delayed(const Duration(seconds: 3), () {
                        if (mounted) {
                          setState(() => showDeleteConfirm = false);
                        }
                      });
                    } else {
                      widget.onDelete();
                    }
                  },
                  icon: Icon(
                    showDeleteConfirm
                        ? PhosphorIcons.check(PhosphorIconsStyle.bold)
                        : PhosphorIcons.trash(PhosphorIconsStyle.bold),
                    size: 16,
                    color: showDeleteConfirm ? AppColors.error : null,
                  ),
                  tooltip:
                      showDeleteConfirm ? 'Confirm Delete' : 'Delete Project',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      case 'low':
        return AppColors.success;
      default:
        return AppColors.info;
    }
  }

  Color _getPriorityBackgroundColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFF442926);
      case 'medium':
        return const Color(0xFF3D3425);
      case 'low':
        return const Color(0xFF2A3524);
      default:
        return const Color(0xFF252D3D);
    }
  }

  String _getPriorityText(String priority) {
    return priority[0].toUpperCase() + priority.substring(1).toLowerCase();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.success;
      case 'in progress':
        return AppColors.accent;
      case 'on hold':
        return AppColors.warning;
      default:
        return AppColors.error;
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF243524);
      case 'in progress':
        return const Color(0xFF252D3D);
      case 'on hold':
        return const Color(0xFF3D3425);
      default:
        return const Color(0xFF442926);
    }
  }

  String _getStatusText(String status) {
    return status
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
