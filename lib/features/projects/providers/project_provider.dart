import 'package:flutter/foundation.dart';

class ProjectProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _projects = [];
  List<Map<String, dynamic>> _completedProjects = [];
  final Map<int, String> _originalStatuses = {};

  List<Map<String, dynamic>> get projects => _projects;
  List<Map<String, dynamic>> get completedProjects => _completedProjects;
  Map<int, String> get originalStatuses => _originalStatuses;

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
    final project = _completedProjects[index];
    project['status'] = _originalStatuses[index] ?? 'not started';
    _projects.add(project);
    _completedProjects.removeAt(index);
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
}
