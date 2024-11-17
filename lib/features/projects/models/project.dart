class Project {
  final String id;
  final String name;
  final String description;
  final DateTime dueDate;
  final DateTime startDate;
  final String priority;
  final String status;
  final String category;
  final int tasks;
  final int completedTasks;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.dueDate,
    required this.startDate,
    required this.priority,
    required this.status,
    required this.category,
    this.tasks = 0,
    this.completedTasks = 0,
  });
}
