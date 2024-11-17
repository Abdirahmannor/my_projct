import 'package:flutter/foundation.dart';
import '../models/project.dart';

class ProjectProvider extends ChangeNotifier {
  List<Project> _projects = [];

  List<Project> get projects => _projects;

  void addSampleProjects() {
    _projects = [
      Project(
        id: '1',
        name: 'Math Assignment',
        description: 'Complete calculus homework',
        startDate: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(days: 7)),
        priority: 'High',
        status: 'In Progress',
        category: 'Homework',
      ),
      Project(
        id: '2',
        name: 'Physics Project',
        description: 'Research paper on quantum mechanics',
        startDate: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(days: 14)),
        priority: 'Medium',
        status: 'Not Started',
        category: 'Research',
      ),
    ];
    notifyListeners();
  }
}
