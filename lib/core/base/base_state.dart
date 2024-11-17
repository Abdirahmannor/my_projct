import 'package:flutter/material.dart';
import 'base_item.dart';

abstract class BaseState<T extends BaseItem> {
  // Filter states
  String? selectedPriority;
  String? selectedStatus;
  String? selectedNameSort;
  String? selectedStartDateSort;
  String? selectedDueDateSort;
  String? selectedTasksSort;
  DateTimeRange? selectedDateRange;
  String searchQuery = '';

  // View states
  bool isListView = true;
  bool showArchived = false;
  bool showRecycleBin = false;
  int? hoveredIndex;
  bool isLoading = false;

  // Item states
  List<T> items = [];
  List<T> archivedItems = [];
  List<T> deletedItems = [];

  // Checkbox states
  List<bool> checkedItems = [];
  List<bool> archivedCheckedItems = [];
  List<bool> recycleBinCheckedItems = [];
  bool selectAll = false;
  bool archivedSelectAll = false;
  bool recycleBinSelectAll = false;

  // Counter states
  int newlyDeletedCount = 0;
  int newlyArchivedCount = 0;
  int newlyActiveCount = 0;

  // Visit states
  bool hasVisitedRecycleBin = false;
  bool hasVisitedArchived = false;
  bool hasVisitedActive = false;

  // Header hover states
  bool isPriorityHeaderHovered = false;
  bool isStatusHeaderHovered = false;
  bool isNameHeaderHovered = false;
  bool isStartDateHeaderHovered = false;
  bool isDueDateHeaderHovered = false;
  bool isTasksHeaderHovered = false;

  // Clear all states
  void clearAllStates() {
    selectedPriority = null;
    selectedStatus = null;
    selectedNameSort = null;
    selectedStartDateSort = null;
    selectedDueDateSort = null;
    selectedTasksSort = null;
    selectedDateRange = null;
    searchQuery = '';
    hoveredIndex = null;
  }

  // Check if any filters are active
  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      selectedPriority != null ||
      selectedStatus != null ||
      selectedNameSort != null ||
      selectedStartDateSort != null ||
      selectedDueDateSort != null ||
      selectedTasksSort != null ||
      selectedDateRange != null;
}
