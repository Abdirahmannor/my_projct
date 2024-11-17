import 'package:hive/hive.dart';
import '../../../core/base/base_item.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends BaseItem {
  @HiveField(20)
  final String projectId;
  @HiveField(21)
  final bool isCompleted;
  @HiveField(22)
  final DateTime? completedAt;
  @HiveField(23)
  final DateTime? startDate;
  @HiveField(24)
  final List<String>? assignees;
  @HiveField(25)
  final List<String>? labels;
  @HiveField(26)
  final String? parentTaskId;
  @HiveField(27)
  final List<String>? subtaskIds;
  @HiveField(28)
  final int? estimatedHours;
  @HiveField(29)
  final int? actualHours;
  @HiveField(30)
  final String? originalStatus;

  Task({
    String? id,
    required String name,
    String? description,
    required DateTime dueDate,
    required String priority,
    required String status,
    bool? isPinned,
    DateTime? deletedAt,
    DateTime? lastRestoredDate,
    required this.projectId,
    required this.isCompleted,
    this.completedAt,
    this.startDate,
    List<dynamic>? assignees,
    List<dynamic>? labels,
    this.parentTaskId,
    List<dynamic>? subtaskIds,
    this.estimatedHours,
    this.actualHours,
    this.originalStatus,
  })  : this.assignees = assignees?.cast<String>(),
        this.labels = labels?.cast<String>(),
        this.subtaskIds = subtaskIds?.cast<String>(),
        super(
          id: id,
          name: name,
          description: description,
          dueDate: dueDate,
          priority: priority,
          status: status,
          isPinned: isPinned,
          deletedAt: deletedAt,
          lastRestoredDate: lastRestoredDate,
        );

  @override
  Task copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? dueDate,
    String? priority,
    String? status,
    bool? isPinned,
    DateTime? deletedAt,
    DateTime? lastRestoredDate,
    String? projectId,
    bool? isCompleted,
    DateTime? completedAt,
    DateTime? startDate,
    List<String>? assignees,
    List<String>? labels,
    String? parentTaskId,
    List<String>? subtaskIds,
    int? estimatedHours,
    int? actualHours,
    String? originalStatus,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      isPinned: isPinned ?? this.isPinned,
      deletedAt: deletedAt ?? this.deletedAt,
      lastRestoredDate: lastRestoredDate ?? this.lastRestoredDate,
      projectId: projectId ?? this.projectId,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      startDate: startDate ?? this.startDate,
      assignees: assignees ?? this.assignees,
      labels: labels ?? this.labels,
      parentTaskId: parentTaskId ?? this.parentTaskId,
      subtaskIds: subtaskIds ?? this.subtaskIds,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      actualHours: actualHours ?? this.actualHours,
      originalStatus: originalStatus ?? this.originalStatus,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'status': status,
      'isPinned': isPinned,
      'deletedAt': deletedAt?.toIso8601String(),
      'lastRestoredDate': lastRestoredDate?.toIso8601String(),
      'projectId': projectId,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'assignees': assignees,
      'labels': labels,
      'parentTaskId': parentTaskId,
      'subtaskIds': subtaskIds,
      'estimatedHours': estimatedHours,
      'actualHours': actualHours,
      'originalStatus': originalStatus,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      priority: map['priority'],
      status: map['status'],
      isPinned: map['isPinned'],
      deletedAt:
          map['deletedAt'] != null ? DateTime.parse(map['deletedAt']) : null,
      lastRestoredDate: map['lastRestoredDate'] != null
          ? DateTime.parse(map['lastRestoredDate'])
          : null,
      projectId: map['projectId'],
      isCompleted: map['isCompleted'],
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
      startDate:
          map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      assignees: map['assignees'] != null
          ? List<String>.from(map['assignees'] as List)
          : null,
      labels: map['labels'] != null
          ? List<String>.from(map['labels'] as List)
          : null,
      parentTaskId: map['parentTaskId'],
      subtaskIds: map['subtaskIds'] != null
          ? List<String>.from(map['subtaskIds'] as List)
          : null,
      estimatedHours: map['estimatedHours'],
      actualHours: map['actualHours'],
      originalStatus: map['originalStatus'],
    );
  }

  // Helper methods
  bool get isOverdue => !isCompleted && dueDate.isBefore(DateTime.now());
  bool get hasStarted => startDate != null;
  bool get isSubtask => parentTaskId != null;
  bool get hasSubtasks => subtaskIds != null && subtaskIds!.isNotEmpty;
  double get progress =>
      actualHours != null && estimatedHours != null && estimatedHours! > 0
          ? (actualHours! / estimatedHours!).clamp(0.0, 1.0)
          : 0.0;
}
