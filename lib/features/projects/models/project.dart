import 'package:hive/hive.dart';

part 'project.g.dart';

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
  final DateTime? archivedDate;

  @HiveField(11)
  final String? originalStatus;

  @HiveField(12)
  final bool? isPinned;

  @HiveField(13)
  final DateTime? deletedAt;

  @HiveField(14)
  final DateTime? lastRestoredDate;

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
    this.archivedDate,
    this.originalStatus,
    this.isPinned,
    this.deletedAt,
    this.lastRestoredDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'tasks': tasks,
      'completedTasks': completedTasks,
      'priority': priority,
      'status': status,
      'category': category,
      'archivedDate': archivedDate?.toIso8601String(),
      'originalStatus': originalStatus,
      'isPinned': isPinned,
      'deletedAt': deletedAt?.toIso8601String(),
      'lastRestoredDate': lastRestoredDate?.toIso8601String(),
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      name: map['name'] ?? 'Untitled Project',
      description: map['description'],
      startDate: DateTime.tryParse(map['startDate']) ?? DateTime.now(),
      dueDate: DateTime.tryParse(map['dueDate']) ?? DateTime.now(),
      tasks: map['tasks'] ?? 0,
      completedTasks: map['completedTasks'] ?? 0,
      priority: map['priority'] ?? 'Medium',
      status: map['status'] ?? 'Not Started',
      category: map['category'] ?? 'Other',
      archivedDate: map['archivedDate'] != null
          ? DateTime.parse(map['archivedDate'])
          : null,
      originalStatus: map['originalStatus'],
      isPinned: map['isPinned'],
      deletedAt:
          map['deletedAt'] != null ? DateTime.parse(map['deletedAt']) : null,
      lastRestoredDate: map['lastRestoredDate'] != null
          ? DateTime.parse(map['lastRestoredDate'])
          : null,
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

  void validate() {
    print('=== Validating Project ===');
    print('Name: $name');
    print('Start Date: $startDate');
    print('Due Date: $dueDate');
    print('Status: $status');
    print('Priority: $priority');

    if (name.isEmpty) {
      throw ArgumentError('Project name cannot be empty');
    }
    if (dueDate.isBefore(startDate)) {
      throw ArgumentError('Due date cannot be before start date');
    }
    if (status.isEmpty) {
      throw ArgumentError('Project status cannot be empty');
    }
    if (priority.isEmpty) {
      throw ArgumentError('Project priority cannot be empty');
    }
    if (category.isEmpty) {
      throw ArgumentError('Project category cannot be empty');
    }

    print('Validation passed');
  }
}
