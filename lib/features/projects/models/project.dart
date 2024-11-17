import 'package:hive/hive.dart';
import '../../../core/base/base_item.dart';

part 'project.g.dart';

@HiveType(typeId: 2)
class Project extends BaseItem {
  @HiveField(40)
  final String? color;

  @HiveField(41)
  final List<String>? tasks;

  @HiveField(42)
  final DateTime? startDate;

  @HiveField(43)
  final DateTime? endDate;

  @HiveField(44)
  final String? category;

  int _completedTasksCount = 0;

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
    this.color,
    List<dynamic>? tasks,
    this.startDate,
    this.endDate,
    this.category,
  })  : this.tasks = tasks?.cast<String>(),
        super(
          id: id ?? '${DateTime.now().millisecondsSinceEpoch}_${name.hashCode}',
          name: name,
          description: description,
          dueDate: dueDate,
          priority: priority,
          status: status,
          isPinned: isPinned ?? false,
          deletedAt: deletedAt,
          lastRestoredDate: lastRestoredDate,
        ) {
    _completedTasksCount = 0;
  }

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
    String? color,
    List<String>? tasks,
    DateTime? startDate,
    DateTime? endDate,
    String? category,
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
      color: color ?? this.color,
      tasks: tasks ?? this.tasks,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'color': color,
      'tasks': tasks,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'category': category,
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
      color: map['color'],
      tasks: map['tasks'] != null ? List<String>.from(map['tasks']) : null,
      startDate:
          map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      category: map['category'],
    );
  }

  double get progress {
    if (tasks == null || tasks!.isEmpty) return 0.0;
    return _completedTasksCount / tasks!.length;
  }

  bool get isCompleted =>
      tasks != null &&
      tasks!.isNotEmpty &&
      _completedTasksCount == tasks!.length;

  void updateCompletedTasksCount(int count) {
    _completedTasksCount = count;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Project &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          dueDate == other.dueDate &&
          priority == other.priority &&
          status == other.status &&
          isPinned == other.isPinned &&
          color == other.color &&
          tasks == other.tasks &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          category == other.category;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      dueDate.hashCode ^
      priority.hashCode ^
      status.hashCode ^
      isPinned.hashCode ^
      color.hashCode ^
      tasks.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      category.hashCode;
}
