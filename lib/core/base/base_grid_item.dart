import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../constants/app_colors.dart';
import 'base_item.dart';
import 'base_styles.dart';
import 'base_utils.dart';

abstract class BaseGridItem<T extends BaseItem> extends StatelessWidget {
  final T item;
  final bool isChecked;
  final bool isHovered;
  final Function(bool?) onCheckChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onRestore;

  const BaseGridItem({
    super.key,
    required this.item,
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
      decoration: BaseStyles.getItemDecoration(
        context,
        isHovered: isHovered,
        isSelected: isChecked,
      ),
      child: Stack(
        children: [
          // Checkbox
          Positioned(
            top: 8,
            left: 8,
            child: Checkbox(
              value: isChecked,
              onChanged: onCheckChanged,
            ),
          ),
          // Pin indicator if applicable
          if (item.isPinned ?? false)
            Positioned(
              top: 8,
              right: 8,
              child: Icon(
                PhosphorIcons.pushPin(PhosphorIconsStyle.fill),
                size: 16,
                color: AppColors.accent,
              ),
            ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24), // Space for checkbox
                buildMainContent(context),
                const Spacer(),
                buildFooter(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Abstract methods to be implemented by subclasses
  Widget buildMainContent(BuildContext context);
  Widget buildFooter(BuildContext context);

  // Shared methods that can be used by subclasses
  Widget buildPriorityIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: BaseStyles.getPriorityColor(item.priority).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        BaseUtils.capitalize(item.priority),
        style: TextStyle(
          color: BaseStyles.getPriorityColor(item.priority),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildStatusIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: BaseStyles.getStatusColor(item.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        BaseUtils.capitalize(item.status),
        style: TextStyle(
          color: BaseStyles.getStatusColor(item.status),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onRestore != null)
          IconButton(
            onPressed: onRestore,
            icon: Icon(
              PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.bold),
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
    );
  }
}
