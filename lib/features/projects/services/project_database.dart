import '../../../core/base/base_database.dart';
import '../models/project.dart';

class ProjectDatabase extends BaseDatabase<Project> {
  ProjectDatabase()
      : super(boxName: 'projects', deletedBoxName: 'deleted_projects');

  @override
  Future<void> add(Project project) async {
    final projectBox = await box;
    await projectBox.put(project.id, project);
  }

  @override
  Future<void> update(Project project) async {
    final projectBox = await box;
    await projectBox.put(project.id, project);
  }

  @override
  Future<void> delete(String id) async {
    final projectBox = await box;
    await projectBox.delete(id);
  }

  @override
  Future<Project?> get(String id) async {
    final projectBox = await box;
    return projectBox.get(id);
  }

  @override
  Future<List<Project>> getAll() async {
    final projectBox = await box;
    return projectBox.values.toList();
  }

  @override
  Future<List<Project>> getDeleted() async {
    final box = await deletedBox;
    return box.values.toList();
  }

  @override
  Future<void> moveToRecycleBin(Project project) async {
    final projectBox = await box;
    final box = await deletedBox;

    await projectBox.delete(project.id);
    await box.put(
      project.id,
      project.copyWith(
        deletedAt: DateTime.now(),
        originalStatus: project.status,
      ),
    );
  }

  @override
  Future<void> restoreFromRecycleBin(String id) async {
    final projectBox = await box;
    final box = await deletedBox;

    final project = await box.get(id);
    if (project != null) {
      await projectBox.put(
        id,
        project.copyWith(
          deletedAt: null,
          status: project.originalStatus ?? project.status,
          originalStatus: null,
          lastRestoredDate: DateTime.now(),
        ),
      );
      await box.delete(id);
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
  Future<void> updateTaskCount(String id,
      {required int totalTasks, required int completedTasks}) async {
    final project = await get(id);
    if (project != null) {
      await update(
        project.copyWith(
          tasks: totalTasks,
          completedTasks: completedTasks,
        ),
      );
    }
  }

  Future<void> archiveProject(Project project) async {
    final projectBox = await box;
    await projectBox.put(
      project.id,
      project.copyWith(
        archivedDate: DateTime.now(),
        originalStatus: project.status,
        status: 'archived',
      ),
    );
  }

  Future<void> unarchiveProject(String id) async {
    final project = await get(id);
    if (project != null) {
      await update(
        project.copyWith(
          archivedDate: null,
          status: project.originalStatus ?? project.status,
          originalStatus: null,
        ),
      );
    }
  }
}
