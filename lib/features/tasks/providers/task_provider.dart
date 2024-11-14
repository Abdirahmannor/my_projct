import 'package:flutter/foundation.dart';

class TaskProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, dynamic>> _completedTasks = [];
  final Map<int, String> _originalStatuses = {};

  List<Map<String, dynamic>> get tasks => _tasks;
  List<Map<String, dynamic>> get completedTasks => _completedTasks;
  Map<int, String> get originalStatuses => _originalStatuses;

  void addTask(Map<String, dynamic> task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(int index, Map<String, dynamic> task) {
    _tasks[index] = task;
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  void completeTask(int index) {
    final task = _tasks[index];
    _originalStatuses[index] = task['status'];
    task['status'] = 'done';
    _completedTasks.add(task);
    _tasks.removeAt(index);
    notifyListeners();
  }

  void restoreTask(int index) {
    final task = _completedTasks[index];
    task['status'] = _originalStatuses[index] ?? 'to do';
    _tasks.add(task);
    _completedTasks.removeAt(index);
    _originalStatuses.remove(index);
    notifyListeners();
  }

  void deleteCompletedTask(int index) {
    _completedTasks.removeAt(index);
    notifyListeners();
  }

  void completeAllTasks() {
    for (var task in _tasks) {
      _originalStatuses[_tasks.indexOf(task)] = task['status'];
      task['status'] = 'done';
      _completedTasks.add(task);
    }
    _tasks.clear();
    notifyListeners();
  }

  void restoreAllTasks() {
    for (var task in _completedTasks) {
      final index = _completedTasks.indexOf(task);
      task['status'] = _originalStatuses[index] ?? 'to do';
      _tasks.add(task);
    }
    _completedTasks.clear();
    _originalStatuses.clear();
    notifyListeners();
  }
}
