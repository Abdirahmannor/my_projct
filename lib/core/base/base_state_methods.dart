import 'package:flutter/material.dart';
import 'base_item.dart';
import 'base_dialog_helper.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../constants/app_colors.dart';

mixin BaseStateMethods<T extends BaseItem> {
  // Filter methods
  void clearFilters(BuildContext context) {
    BaseDialogHelper.showSuccessMessage(
      context: context,
      message: 'All filters have been cleared',
      icon: PhosphorIcons.funnel(PhosphorIconsStyle.fill),
    );
  }

  // Sort methods
  void handleSort(List<T> items, String? sortType, String direction) {
    if (sortType == null) return;

    items.sort((a, b) {
      switch (sortType) {
        case 'name':
          final comparison =
              a.name.toLowerCase().compareTo(b.name.toLowerCase());
          return direction == 'asc' ? comparison : -comparison;
        case 'date':
          final comparison = a.dueDate.compareTo(b.dueDate);
          return direction == 'asc' ? comparison : -comparison;
        case 'priority':
          final priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
          final comparison = (priorityOrder[a.priority] ?? 0)
              .compareTo(priorityOrder[b.priority] ?? 0);
          return direction == 'asc' ? comparison : -comparison;
        default:
          return 0;
      }
    });
  }

  // View methods
  void toggleView(bool isList) {}

  // Selection methods
  void toggleSelectAll(List<bool> checkedItems, bool value) {
    for (var i = 0; i < checkedItems.length; i++) {
      checkedItems[i] = value;
    }
  }

  // Status methods
  void updateStatus(T item, String newStatus) {}

  // Archive methods
  void moveToArchive(T item) {}

  // Delete methods
  void moveToRecycleBin(T item) {}

  // Restore methods
  void restoreFromRecycleBin(T item) {}

  // Pin methods
  void togglePin(T item) {}

  // Search methods
  bool matchesSearch(T item, String query) {
    if (query.isEmpty) return true;
    final searchLower = query.toLowerCase();
    return item.name.toLowerCase().contains(searchLower) ||
        (item.description?.toLowerCase().contains(searchLower) ?? false);
  }
}
