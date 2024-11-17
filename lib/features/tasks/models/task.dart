class Task {
  final String? id;
  final String name;
  final String? description;
  final DateTime dueDate;
  final String priority;
  final String status;
  final bool? isPinned;
  final DateTime? deletedAt;
  final DateTime? lastRestoredDate;
  final String projectId;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime? startDate;
  final List? assignees;
  final List? labels;
  final String? parentTaskId;
  final List? subtaskIds;
  final int? estimatedHours;
  final int? actualHours;
  final String? originalStatus;

  Task({
    this.id,
    required this.name,
    this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    this.isPinned,
    this.deletedAt,
    this.lastRestoredDate,
    required this.projectId,
    required this.isCompleted,
    this.completedAt,
    this.startDate,
    this.assignees,
    this.labels,
    this.parentTaskId,
    this.subtaskIds,
    this.estimatedHours,
    this.actualHours,
    this.originalStatus,
  });
}
