import 'package:flutter/foundation.dart';

class TaskProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _tasks = [];
  final List<Map<String, dynamic>> _deletedTasks = [];
  final List<Map<String, dynamic>> _completedTasks = [];

  List<Map<String, dynamic>> get tasks => List.unmodifiable(_tasks);
  List<Map<String, dynamic>> get deletedTasks =>
      List.unmodifiable(_deletedTasks);
  List<Map<String, dynamic>> get completedTasks =>
      List.unmodifiable(_completedTasks);

  void addTask(Map<String, dynamic> task) {
    _tasks.add(task);
    notifyListeners();
  }

  void deleteTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      final task = _tasks[index];
      _tasks.removeAt(index);
      _deletedTasks.add(task);
      notifyListeners();
    }
  }

  void restoreTask(int index) {
    if (index >= 0 && index < _deletedTasks.length) {
      try {
        final task = _deletedTasks[index];
        _deletedTasks.removeAt(index);
        _tasks.add(task);
        notifyListeners();
      } catch (e) {
        print('Error restoring task: $e');
      }
    }
  }

  void permanentlyDeleteTask(int index) {
    if (index >= 0 && index < _deletedTasks.length) {
      _deletedTasks.removeAt(index);
      notifyListeners();
    }
  }

  void completeTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      final task = _tasks[index];
      task['status'] = 'completed';
      _tasks.removeAt(index);
      _completedTasks.add(task);
      notifyListeners();
    }
  }

  void updateTask(int index, Map<String, dynamic> updatedTask) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  Map<String, dynamic>? getTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      return _tasks[index];
    }
    return null;
  }

  Map<String, dynamic>? getDeletedTask(int index) {
    if (index >= 0 && index < _deletedTasks.length) {
      return _deletedTasks[index];
    }
    return null;
  }

  void completeAllTasks() {
    for (var task in List.from(_tasks)) {
      task['status'] = 'completed';
      _completedTasks.add(task);
    }
    _tasks.clear();
    notifyListeners();
  }

  void restoreAllTasks() {
    _tasks.addAll(_deletedTasks);
    _deletedTasks.clear();
    notifyListeners();
  }

  void deleteCompletedTask(int index) {
    if (index >= 0 && index < _completedTasks.length) {
      final task = _completedTasks[index];
      _completedTasks.removeAt(index);
      _deletedTasks.add(task);
      notifyListeners();
    }
  }

  void addSampleTasks() {
    final sampleTasks = [
      {
        'id': '1',
        'name': 'Design User Interface',
        'description':
            'Create modern and intuitive UI designs for the main dashboard',
        'project': 'School Management System',
        'dueDate': '20 Mar, 2024',
        'priority': 'high',
        'status': 'in progress',
      },
      {
        'id': '2',
        'name': 'Database Schema',
        'description': 'Design and implement the database structure',
        'project': 'School Management System',
        'dueDate': '25 Mar, 2024',
        'priority': 'critical',
        'status': 'to do',
      },
      {
        'id': '3',
        'name': 'Authentication System',
        'description': 'Implement secure user authentication and authorization',
        'project': 'Mobile Learning App',
        'dueDate': '15 Mar, 2024',
        'priority': 'high',
        'status': 'completed',
      },
      {
        'id': '4',
        'name': 'Content Management',
        'description':
            'Develop content management system for learning materials',
        'project': 'Digital Library Portal',
        'dueDate': '5 Apr, 2024',
        'priority': 'medium',
        'status': 'in progress',
      },
      {
        'id': '5',
        'name': 'Testing and QA',
        'description': 'Perform comprehensive testing of all features',
        'project': 'Mobile Learning App',
        'dueDate': '10 Apr, 2024',
        'priority': 'medium',
        'status': 'on hold',
      },
    ];

    for (var task in sampleTasks) {
      _tasks.add(task);
    }
    notifyListeners();
  }
}
