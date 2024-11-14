import 'package:hive_flutter/hive_flutter.dart';
import '../models/project.dart';
import 'package:uuid/uuid.dart';

class ProjectDatabaseService {
  static const String boxName = 'projects';
  final _uuid = const Uuid();

  Future<Box<Project>> get _box async => await Hive.openBox<Project>(boxName);

  // Create
  Future<void> addProject(Project project) async {
    final box = await _box;
    final id = _uuid.v4();
    final newProject = Project(
      id: id,
      name: project.name,
      description: project.description,
      startDate: project.startDate,
      dueDate: project.dueDate,
      tasks: project.tasks,
      completedTasks: project.completedTasks,
      priority: project.priority,
      status: project.status,
      category: project.category,
    );
    await box.put(id, newProject);
  }

  // Read
  Future<List<Project>> getAllProjects() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<Project?> getProject(String id) async {
    final box = await _box;
    return box.get(id);
  }

  // Update
  Future<void> updateProject(Project project) async {
    final box = await _box;
    await box.put(project.id, project);
  }

  // Delete
  Future<void> deleteProject(String id) async {
    final box = await _box;
    await box.delete(id);
  }
}
