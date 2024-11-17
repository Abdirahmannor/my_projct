import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'base_item.dart';
import '../constants/app_colors.dart';

abstract class BaseListItem<T extends BaseItem> extends StatelessWidget {
  final T item;
  final bool isChecked;
  final bool isHovered;
  final Function(bool?) onCheckChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onRestore;

  const BaseListItem({
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
    return buildContainer(
      context: context,
      child: buildContent(context),
    );
  }

  // Template methods to be implemented by subclasses
  Widget buildContent(BuildContext context);

  // Shared methods that can be used by subclasses
  Widget buildContainer(
      {required BuildContext context, required Widget child}) {
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
      child: child,
    );
  }

  Widget buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
