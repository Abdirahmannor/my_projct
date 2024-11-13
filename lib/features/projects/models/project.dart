class Project {
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime dueDate;
  final int tasks;
  final String priority;
  final String status;

  Project({
    required this.name,
    this.description,
    required this.startDate,
    required this.dueDate,
    this.tasks = 0,
    required this.priority,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'startDate': _formatDate(startDate),
      'dueDate': _formatDate(dueDate),
      'tasks': tasks,
      'priority': priority,
      'status': status,
    };
  }

  static String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}
