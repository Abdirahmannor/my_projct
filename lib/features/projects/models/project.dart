import '../../../core/base/base_item.dart';

class Project extends BaseItem {
  final int tasks;
  final int completedTasks;
  final String? category;
  final String? originalStatus;
  final DateTime? archivedDate;

  Project({
    String? id,
    required String name,
    String? description,
    required DateTime dueDate,
    required String priority,
    required String status,
    bool? isPinned,
    DateTime? deletedAt,
    DateTime? lastRestoredDate,
    required this.tasks,
    required this.completedTasks,
    this.category,
    this.originalStatus,
    this.archivedDate,
  }) : super(
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
  Project copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? dueDate,
    String? priority,
    String? status,
    bool? isPinned,
    DateTime? deletedAt,
    DateTime? lastRestoredDate,
    int? tasks,
    int? completedTasks,
    String? category,
    String? originalStatus,
    DateTime? archivedDate,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      isPinned: isPinned ?? this.isPinned,
      deletedAt: deletedAt ?? this.deletedAt,
      lastRestoredDate: lastRestoredDate ?? this.lastRestoredDate,
      tasks: tasks ?? this.tasks,
      completedTasks: completedTasks ?? this.completedTasks,
      category: category ?? this.category,
      originalStatus: originalStatus ?? this.originalStatus,
      archivedDate: archivedDate ?? this.archivedDate,
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
      'tasks': tasks,
      'completedTasks': completedTasks,
      'category': category,
      'originalStatus': originalStatus,
      'archivedDate': archivedDate?.toIso8601String(),
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
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
      tasks: map['tasks'],
      completedTasks: map['completedTasks'],
      category: map['category'],
      originalStatus: map['originalStatus'],
      archivedDate: map['archivedDate'] != null
          ? DateTime.parse(map['archivedDate'])
          : null,
    );
  }

  double get progress => tasks > 0 ? completedTasks / tasks : 0.0;
  bool get isCompleted => completedTasks == tasks;
}
