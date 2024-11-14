class Task {
  final String id;
  final String name;
  final String? description;
  final String project;
  final String dueDate;
  final String priority;
  final String status;
  final bool isCompleted;

  Task({
    required this.id,
    required this.name,
    this.description,
    required this.project,
    required this.dueDate,
    required this.priority,
    required this.status,
    this.isCompleted = false,
  });

  Task copyWith({
    String? id,
    String? name,
    String? description,
    String? project,
    String? dueDate,
    String? priority,
    String? status,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      project: project ?? this.project,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
