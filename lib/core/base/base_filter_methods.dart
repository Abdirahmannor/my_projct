import 'package:flutter/material.dart';
import 'base_item.dart';
import 'base_constants.dart';

mixin BaseFilterMethods<T extends BaseItem> {
  // Filter by search query
  bool matchesSearch(T item, String query) {
    if (query.isEmpty) return true;
    final searchLower = query.toLowerCase();
    return item.name.toLowerCase().contains(searchLower) ||
        (item.description?.toLowerCase().contains(searchLower) ?? false);
  }

  // Filter by priority
  bool matchesPriority(T item, String? priority) {
    if (priority == null || priority == 'all') return true;
    return item.priority == priority;
  }

  // Filter by status
  bool matchesStatus(T item, String? status) {
    if (status == null || status == 'all') return true;
    return item.status == status;
  }

  // Filter by date range
  bool matchesDateRange(T item, DateTimeRange? dateRange) {
    if (dateRange == null) return true;
    return !item.dueDate.isBefore(dateRange.start) &&
        !item.dueDate.isAfter(dateRange.end);
  }

  // Sort methods
  void sortByName(List<T> items, String direction) {
    items.sort((a, b) {
      final comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      return direction == 'asc' ? comparison : -comparison;
    });
  }

  void sortByDate(List<T> items, String direction) {
    items.sort((a, b) {
      final comparison = a.dueDate.compareTo(b.dueDate);
      return direction == 'asc' ? comparison : -comparison;
    });
  }

  void sortByPriority(List<T> items, String direction) {
    final priorityOrder = BaseConstants.priorities.keys.toList();
    items.sort((a, b) {
      final aIndex = priorityOrder.indexOf(a.priority);
      final bIndex = priorityOrder.indexOf(b.priority);
      final comparison = aIndex.compareTo(bIndex);
      return direction == 'asc' ? comparison : -comparison;
    });
  }

  // Pin sorting
  void sortByPin(List<T> items) {
    items.sort((a, b) {
      if ((a.isPinned ?? false) && !(b.isPinned ?? false)) return -1;
      if (!(a.isPinned ?? false) && (b.isPinned ?? false)) return 1;
      return 0;
    });
  }

  // Combined filter method
  List<T> filterItems({
    required List<T> items,
    String searchQuery = '',
    String? priority,
    String? status,
    DateTimeRange? dateRange,
    String? nameSort,
    String? dateSort,
    String? prioritySort,
  }) {
    List<T> filteredItems = items.where((item) {
      return matchesSearch(item, searchQuery) &&
          matchesPriority(item, priority) &&
          matchesStatus(item, status) &&
          matchesDateRange(item, dateRange);
    }).toList();

    // Apply sorting
    if (nameSort != null) {
      sortByName(filteredItems, nameSort);
    } else if (dateSort != null) {
      sortByDate(filteredItems, dateSort);
    } else if (prioritySort != null) {
      sortByPriority(filteredItems, prioritySort);
    }

    // Always sort pinned items first
    sortByPin(filteredItems);

    return filteredItems;
  }
}
