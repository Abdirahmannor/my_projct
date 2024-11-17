import '../../../core/base/base_state.dart';
import '../models/task.dart';

class TaskState extends BaseState<Task> {
  // Task-specific state properties
  String? selectedProject;
  String? selectedAssignee;
  String? selectedLabel;
  bool showCompletedOnly = false;
  bool showOverdueOnly = false;
  bool showUnassignedOnly = false;
  bool showParentTasksOnly = false;

  // Task statistics
  int get totalTasks => items.length;
  int get completedTasks => items.where((t) => t.isCompleted).length;
  int get overdueTasks => items.where((t) => t.isOverdue).length;
  int get unassignedTasks =>
      items.where((t) => t.assignees == null || t.assignees!.isEmpty).length;
  int get parentTasks => items.where((t) => !t.isSubtask).length;
  int get subtasks => items.where((t) => t.isSubtask).length;

  // Task grouping
  Map<String, List<Task>> get tasksByProject {
    final grouped = <String, List<Task>>{};
    for (final task in items) {
      grouped.putIfAbsent(task.projectId, () => []).add(task);
    }
    return grouped;
  }

  Map<String, List<Task>> get tasksByAssignee {
    final grouped = <String, List<Task>>{};
    for (final task in items) {
      if (task.assignees != null) {
        for (final assignee in task.assignees!) {
          grouped.putIfAbsent(assignee, () => []).add(task);
        }
      } else {
        grouped.putIfAbsent('Unassigned', () => []).add(task);
      }
    }
    return grouped;
  }

  Map<String, List<Task>> get tasksByLabel {
    final grouped = <String, List<Task>>{};
    for (final task in items) {
      if (task.labels != null) {
        for (final label in task.labels!) {
          grouped.putIfAbsent(label, () => []).add(task);
        }
      } else {
        grouped.putIfAbsent('No Label', () => []).add(task);
      }
    }
    return grouped;
  }

  Map<String, List<Task>> get tasksByStatus {
    final grouped = <String, List<Task>>{};
    for (final task in items) {
      grouped.putIfAbsent(task.status, () => []).add(task);
    }
    return grouped;
  }

  Map<String, List<Task>> get tasksByPriority {
    final grouped = <String, List<Task>>{};
    for (final task in items) {
      grouped.putIfAbsent(task.priority, () => []).add(task);
    }
    return grouped;
  }

  // Filter helpers
  List<Task> getFilteredTasks() {
    var filtered = [...items];

    // Apply project filter
    if (selectedProject != null) {
      filtered = filtered.where((t) => t.projectId == selectedProject).toList();
    }

    // Apply assignee filter
    if (selectedAssignee != null) {
      filtered = filtered
          .where((t) => t.assignees?.contains(selectedAssignee) ?? false)
          .toList();
    }

    // Apply label filter
    if (selectedLabel != null) {
      filtered = filtered
          .where((t) => t.labels?.contains(selectedLabel) ?? false)
          .toList();
    }

    // Apply completion filter
    if (showCompletedOnly) {
      filtered = filtered.where((t) => t.isCompleted).toList();
    }

    // Apply overdue filter
    if (showOverdueOnly) {
      filtered = filtered.where((t) => t.isOverdue).toList();
    }

    // Apply unassigned filter
    if (showUnassignedOnly) {
      filtered = filtered
          .where((t) => t.assignees == null || t.assignees!.isEmpty)
          .toList();
    }

    // Apply parent tasks filter
    if (showParentTasksOnly) {
      filtered = filtered.where((t) => !t.isSubtask).toList();
    }

    return filtered;
  }

  // Get subtasks for a parent task
  List<Task> getSubtasks(String parentId) {
    return items.where((t) => t.parentTaskId == parentId).toList();
  }

  // Get all assignees
  Set<String> get assignees {
    final allAssignees = <String>{};
    for (final task in items) {
      if (task.assignees != null) {
        allAssignees.addAll(task.assignees!);
      }
    }
    return allAssignees;
  }

  // Get all labels
  Set<String> get labels {
    final allLabels = <String>{};
    for (final task in items) {
      if (task.labels != null) {
        allLabels.addAll(task.labels!);
      }
    }
    return allLabels;
  }

  // Clear task-specific filters
  @override
  void clearAllStates() {
    super.clearAllStates();
    selectedProject = null;
    selectedAssignee = null;
    selectedLabel = null;
    showCompletedOnly = false;
    showOverdueOnly = false;
    showUnassignedOnly = false;
    showParentTasksOnly = false;
  }
}
