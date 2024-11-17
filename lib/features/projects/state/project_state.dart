import '../../../core/base/base_state.dart';
import '../models/project.dart';

class ProjectState extends BaseState<Project> {
  // Project-specific state properties
  String? selectedCategory;
  bool showCompletedOnly = false;
  bool showOverdueOnly = false;

  // Project statistics
  int get totalProjects => items.length;
  int get completedProjects => items.where((p) => p.isCompleted).length;
  int get overdueProjects =>
      items.where((p) => p.dueDate.isBefore(DateTime.now())).length;

  // Project grouping
  Map<String, List<Project>> get projectsByCategory {
    final grouped = <String, List<Project>>{};
    for (final project in items) {
      final category = project.category ?? 'Uncategorized';
      grouped.putIfAbsent(category, () => []).add(project);
    }
    return grouped;
  }

  Map<String, List<Project>> get projectsByStatus {
    final grouped = <String, List<Project>>{};
    for (final project in items) {
      grouped.putIfAbsent(project.status, () => []).add(project);
    }
    return grouped;
  }

  Map<String, List<Project>> get projectsByPriority {
    final grouped = <String, List<Project>>{};
    for (final project in items) {
      grouped.putIfAbsent(project.priority, () => []).add(project);
    }
    return grouped;
  }

  // Filter helpers
  List<Project> getFilteredProjects() {
    var filtered = [...items];

    // Apply category filter
    if (selectedCategory != null) {
      filtered = filtered.where((p) => p.category == selectedCategory).toList();
    }

    // Apply completion filter
    if (showCompletedOnly) {
      filtered = filtered.where((p) => p.isCompleted).toList();
    }

    // Apply overdue filter
    if (showOverdueOnly) {
      filtered =
          filtered.where((p) => p.dueDate.isBefore(DateTime.now())).toList();
    }

    return filtered;
  }

  // Get all unique categories
  Set<String> get categories {
    return items
        .where((p) => p.category != null)
        .map((p) => p.category!)
        .toSet();
  }

  // Clear project-specific filters
  @override
  void clearAllStates() {
    super.clearAllStates();
    selectedCategory = null;
    showCompletedOnly = false;
    showOverdueOnly = false;
  }
}
