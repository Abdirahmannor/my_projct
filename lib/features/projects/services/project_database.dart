import 'package:flutter/foundation.dart';
import '../../../core/base/base_database.dart';
import '../models/project.dart';

class ProjectDatabase extends BaseDatabase<Project> {
  // Add ValueNotifier for projects
  final ValueNotifier<List<Project>> projectsNotifier =
      ValueNotifier<List<Project>>([]);

  ProjectDatabase()
      : super(boxName: 'projects', deletedBoxName: 'deleted_projects') {
    // Initialize the notifier with existing projects
    _initializeProjects();
  }

  Future<void> _initializeProjects() async {
    final projects = await getAll();
    projectsNotifier.value = projects;
  }

  @override
  Future<void> add(Project project) async {
    try {
      final projectBox = await box;

      // Ensure we have a valid ID
      final id = project.id ?? DateTime.now().millisecondsSinceEpoch.toString();
      final newProject = project.copyWith(id: id);

      // Add to box
      await projectBox.put(id, newProject);

      // Update the notifier with a fresh list
      final updatedProjects = await getAll();
      projectsNotifier.value = updatedProjects;

      print('Project added successfully with ID: $id');
    } catch (e) {
      print('Error adding project: $e');
      rethrow;
    }
  }

  @override
  Future<void> update(Project project) async {
    try {
      final projectBox = await box;
      if (project.id == null) {
        throw Exception('Project ID cannot be null for update operation');
      }
      await projectBox.put(project.id, project);

      // Update the notifier
      final currentProjects = List<Project>.from(projectsNotifier.value);
      final index = currentProjects.indexWhere((p) => p.id == project.id);
      if (index != -1) {
        currentProjects[index] = project;
        projectsNotifier.value = currentProjects;
      }

      print('Project updated successfully: ${project.id}');
    } catch (e) {
      print('Error updating project: $e');
      rethrow;
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      final projectBox = await box;
      await projectBox.delete(id);

      // Update the notifier
      final currentProjects = List<Project>.from(projectsNotifier.value);
      currentProjects.removeWhere((p) => p.id == id);
      projectsNotifier.value = currentProjects;
    } catch (e) {
      print('Error deleting project: $e');
      rethrow;
    }
  }

  @override
  Future<List<Project>> getAll() async {
    try {
      final projectBox = await box;
      final projects = projectBox.values.toList();

      // Sort projects by creation date or another criteria
      projects.sort((a, b) => b.dueDate.compareTo(a.dueDate));

      return projects;
    } catch (e) {
      print('Error getting all projects: $e');
      return [];
    }
  }

  @override
  Future<void> moveToRecycleBin(Project project) async {
    final projectBox = await box;
    final deletedBox = await this.deletedBox;

    await projectBox.delete(project.id);
    await deletedBox.put(
      project.id,
      project.copyWith(
        deletedAt: DateTime.now(),
        status: 'deleted',
      ),
    );
  }

  @override
  Future<void> restoreFromRecycleBin(String id) async {
    final projectBox = await box;
    final deletedBox = await this.deletedBox;

    final project = await deletedBox.get(id);
    if (project != null) {
      await projectBox.put(
        id,
        project.copyWith(
          deletedAt: null,
          status: 'active',
          lastRestoredDate: DateTime.now(),
        ),
      );
      await deletedBox.delete(id);
    }
  }

  @override
  Future<void> permanentlyDelete(String id) async {
    final box = await deletedBox;
    await box.delete(id);
  }

  @override
  Future<void> cleanupOldItems(int days) async {
    final box = await deletedBox;
    final now = DateTime.now();
    final items = box.values.toList();

    for (final item in items) {
      if (item.deletedAt != null) {
        final difference = now.difference(item.deletedAt!);
        if (difference.inDays >= days) {
          await box.delete(item.id);
        }
      }
    }
  }

  // Project-specific methods
  Future<void> updateTaskCount(String id, List<String> taskIds) async {
    final project = await get(id);
    if (project != null) {
      await update(
        project.copyWith(
          tasks: taskIds,
        ),
      );
      project.updateCompletedTasksCount(taskIds.length);
    }
  }

  Future<void> archiveProject(Project project) async {
    final projectBox = await box;
    await projectBox.put(
      project.id,
      project.copyWith(
        status: 'archived',
      ),
    );
  }

  Future<void> unarchiveProject(String id) async {
    final project = await get(id);
    if (project != null) {
      await update(
        project.copyWith(
          status: 'active',
        ),
      );
    }
  }

  @override
  Future<Project?> get(String id) async {
    try {
      final projectBox = await box;
      return projectBox.get(id);
    } catch (e) {
      print('Error getting project: $e');
      return null;
    }
  }

  @override
  Future<List<Project>> getDeleted() async {
    try {
      final box = await deletedBox;
      return box.values.toList();
    } catch (e) {
      print('Error getting deleted projects: $e');
      return [];
    }
  }

  // Dispose method to clean up
  void dispose() {
    projectsNotifier.dispose();
  }
}
