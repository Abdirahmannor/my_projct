import 'package:flutter/foundation.dart';

class ProjectProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _projects = [];
  final List<Map<String, dynamic>> _completedProjects = [];
  final Map<int, String> _originalStatuses = {};
  final List<Map<String, dynamic>> _deletedProjects = [];

  List<Map<String, dynamic>> get projects => _projects;
  List<Map<String, dynamic>> get completedProjects => _completedProjects;
  Map<int, String> get originalStatuses => _originalStatuses;
  List<Map<String, dynamic>> get deletedProjects => _deletedProjects;

  void addProject(Map<String, dynamic> project) {
    _projects.add(project);
    notifyListeners();
  }

  void updateProject(int index, Map<String, dynamic> project) {
    _projects[index] = project;
    notifyListeners();
  }

  void deleteProject(int index) {
    _projects.removeAt(index);
    _deletedProjects.add(_projects[index]);
    notifyListeners();
  }

  void completeProject(int index) {
    final project = _projects[index];
    _originalStatuses[index] = project['status'];
    project['status'] = 'completed';
    _completedProjects.add(project);
    _projects.removeAt(index);
    notifyListeners();
  }

  void restoreProject(int index) {
    final project = _deletedProjects[index];
    project['status'] = _originalStatuses[index] ?? 'not started';
    _projects.add(project);
    _deletedProjects.removeAt(index);
    _originalStatuses.remove(index);
    notifyListeners();
  }

  void deleteCompletedProject(int index) {
    _completedProjects.removeAt(index);
    notifyListeners();
  }

  void completeAllProjects() {
    for (var project in _projects) {
      _originalStatuses[_projects.indexOf(project)] = project['status'];
      project['status'] = 'completed';
      _completedProjects.add(project);
    }
    _projects.clear();
    notifyListeners();
  }

  void restoreAllProjects() {
    for (var project in _completedProjects) {
      final index = _completedProjects.indexOf(project);
      project['status'] = _originalStatuses[index] ?? 'not started';
      _projects.add(project);
    }
    _completedProjects.clear();
    _originalStatuses.clear();
    notifyListeners();
  }

  void permanentlyDeleteProject(int index) {
    _deletedProjects.removeAt(index);
    notifyListeners();
  }

  void addSampleProjects() {
    final sampleProjects = [
      {
        'id': '1',
        'name': 'School Management System',
        'description': 'Develop a comprehensive school management system',
        'startDate': '15 Mar, 2024',
        'dueDate': '30 Apr, 2024',
        'tasks': 8,
        'completedTasks': 3,
        'priority': 'high',
        'status': 'in progress',
      },
      {
        'id': '2',
        'name': 'Mobile Learning App',
        'description': 'Create an interactive mobile learning application',
        'startDate': '1 Mar, 2024',
        'dueDate': '15 May, 2024',
        'tasks': 12,
        'completedTasks': 4,
        'priority': 'medium',
        'status': 'to do',
      },
      {
        'id': '3',
        'name': 'Digital Library Portal',
        'description': 'Build an online digital library system',
        'startDate': '10 Mar, 2024',
        'dueDate': '25 Apr, 2024',
        'tasks': 6,
        'completedTasks': 6,
        'priority': 'high',
        'status': 'completed',
      },
    ];

    for (var project in sampleProjects) {
      _projects.add(project);
    }
    notifyListeners();
  }
}
