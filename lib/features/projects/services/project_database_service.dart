import 'package:hive_flutter/hive_flutter.dart';
import '../models/project.dart';
import 'package:uuid/uuid.dart';

class ProjectDatabaseService {
  static const String boxName = 'projects';
  static const String deletedBoxName = 'deleted_projects';
  final _uuid = const Uuid();

  // Get box instances
  Future<Box<Project>> get _box async => await Hive.openBox<Project>(boxName);
  Future<Box<Project>> get _deletedBox async =>
      await Hive.openBox<Project>(deletedBoxName);

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

  // Move project to recycle bin
  Future<void> moveToRecycleBin(Project project) async {
    final box = await _box;
    final deletedBox = await _deletedBox;

    final projectWithDeleteDate = Project(
      id: project.id,
      name: project.name,
      description: project.description,
      startDate: project.startDate,
      dueDate: project.dueDate,
      tasks: project.tasks,
      completedTasks: project.completedTasks,
      priority: project.priority,
      status: project.status,
      category: project.category,
      deletedAt: DateTime.now(),
    );

    await deletedBox.put(project.id, projectWithDeleteDate);
    await box.delete(project.id);
  }

  // Get all deleted projects
  Future<List<Project>> getDeletedProjects() async {
    final deletedBox = await _deletedBox;
    return deletedBox.values.toList();
  }

  // Restore project from recycle bin
  Future<void> restoreFromRecycleBin(String projectId) async {
    final box = await _box;
    final deletedBox = await _deletedBox;

    final project = await deletedBox.get(projectId);
    if (project != null) {
      final restoredProject = Project(
        id: project.id,
        name: project.name,
        description: project.description,
        startDate: project.startDate,
        dueDate: project.dueDate,
        tasks: project.tasks,
        completedTasks: project.completedTasks,
        priority: project.priority,
        status: project.status,
        category: project.category,
        deletedAt: null,
      );

      await box.put(projectId, restoredProject);
      await deletedBox.delete(projectId);
    }
  }

  // Permanently delete project
  Future<void> permanentlyDelete(String projectId) async {
    final deletedBox = await _deletedBox;
    await deletedBox.delete(projectId);
  }

  // Clean up old deleted projects (older than 7 days)
  Future<void> cleanupOldProjects() async {
    final deletedBox = await _deletedBox;
    final now = DateTime.now();
    final deletedProjects = deletedBox.values.toList();

    for (final project in deletedProjects) {
      if (project.deletedAt != null) {
        final difference = now.difference(project.deletedAt!);
        if (difference.inDays >= 7) {
          await deletedBox.delete(project.id);
        }
      }
    }
  }
}
