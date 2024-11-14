class Project {
  final String id;
  final String name;
  final String? description;
  final String startDate;
  final String dueDate;
  final int completedTasks;
  final int totalTasks;
  final String priority;
  final String status;
  final bool isCompleted;

  Project({
    required this.id,
    required this.name,
    this.description,
    required this.startDate,
    required this.dueDate,
    required this.completedTasks,
    required this.totalTasks,
    required this.priority,
    required this.status,
    this.isCompleted = false,
  });

  Project copyWith({
    String? id,
    String? name,
    String? description,
    String? startDate,
    String? dueDate,
    int? completedTasks,
    int? totalTasks,
    String? priority,
    String? status,
    bool? isCompleted,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      completedTasks: completedTasks ?? this.completedTasks,
      totalTasks: totalTasks ?? this.totalTasks,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
