import 'package:hive/hive.dart';

part 'project.g.dart'; // This will be auto-generated

@HiveType(typeId: 0)
class Project {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final DateTime startDate;

  @HiveField(4)
  final DateTime dueDate;

  @HiveField(5)
  final int tasks;

  @HiveField(6)
  final int completedTasks;

  @HiveField(7)
  final String priority;

  @HiveField(8)
  final String status;

  @HiveField(9)
  final String category;

  @HiveField(10)
  final DateTime? deletedAt;

  Project({
    this.id,
    required this.name,
    this.description,
    required this.startDate,
    required this.dueDate,
    this.tasks = 0,
    this.completedTasks = 0,
    required this.priority,
    required this.status,
    required this.category,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': _formatDate(startDate),
      'dueDate': _formatDate(dueDate),
      'tasks': tasks,
      'completedTasks': completedTasks,
      'priority': priority,
      'status': status,
      'category': category,
      'deletedAt': deletedAt,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      startDate: _parseDate(map['startDate']),
      dueDate: _parseDate(map['dueDate']),
      tasks: map['tasks'],
      completedTasks: map['completedTasks'],
      priority: map['priority'],
      status: map['status'],
      category: map['category'],
      deletedAt: map['deletedAt'],
    );
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

  static DateTime _parseDate(String date) {
    final parts = date.split(' ');
    final day = int.parse(parts[0]);
    final month = _getMonth(parts[1].replaceAll(',', ''));
    final year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  static int _getMonth(String monthName) {
    const months = [
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
    return months.indexOf(monthName) + 1;
  }
}
