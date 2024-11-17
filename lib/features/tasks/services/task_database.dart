import '../../../core/base/base_database.dart';
import '../models/task.dart';

class TaskDatabase extends BaseDatabase<Task> {
  TaskDatabase() : super(boxName: 'tasks', deletedBoxName: 'deleted_tasks');

  @override
  Future<void> add(Task task) async {
    final taskBox = await box;
    await taskBox.put(task.id, task);
  }

  @override
  Future<void> update(Task task) async {
    final taskBox = await box;
    await taskBox.put(task.id, task);
  }

  @override
  Future<void> delete(String id) async {
    final taskBox = await box;
    await taskBox.delete(id);
  }

  @override
  Future<Task?> get(String id) async {
    final taskBox = await box;
    return taskBox.get(id);
  }

  @override
  Future<List<Task>> getAll() async {
    final taskBox = await box;
    return taskBox.values.toList();
  }

  @override
  Future<List<Task>> getDeleted() async {
    final deletedBox = await this.deletedBox;
    return deletedBox.values.toList();
  }

  @override
  Future<void> moveToRecycleBin(Task task) async {
    final taskBox = await box;
    final deletedBox = await this.deletedBox;

    await taskBox.delete(task.id);
    await deletedBox.put(
      task.id,
      task.copyWith(
        deletedAt: DateTime.now(),
        originalStatus: task.status,
      ),
    );
  }

  @override
  Future<void> restoreFromRecycleBin(String id) async {
    final taskBox = await box;
    final deletedBox = await this.deletedBox;

    final task = await deletedBox.get(id);
    if (task != null) {
      await taskBox.put(
        id,
        task.copyWith(
          deletedAt: null,
          status: task.originalStatus ?? task.status,
          originalStatus: null,
          lastRestoredDate: DateTime.now(),
        ),
      );
      await deletedBox.delete(id);
    }
  }

  @override
  Future<void> permanentlyDelete(String id) async {
    final deletedBox = await this.deletedBox;
    await deletedBox.delete(id);
  }

  @override
  Future<void> cleanupOldItems(int days) async {
    final deletedBox = await this.deletedBox;
    final now = DateTime.now();
    final items = deletedBox.values.toList();

    for (final item in items) {
      if (item.deletedAt != null) {
        final difference = now.difference(item.deletedAt!);
        if (difference.inDays >= days) {
          await deletedBox.delete(item.id);
        }
      }
    }
  }

  // Task-specific methods
  Future<List<Task>> getTasksForProject(String projectId) async {
    final taskBox = await box;
    return taskBox.values.where((task) => task.projectId == projectId).toList();
  }

  Future<void> completeTask(String id) async {
    final task = await get(id);
    if (task != null) {
      await update(
        task.copyWith(
          isCompleted: true,
          completedAt: DateTime.now(),
          status: 'completed',
        ),
      );
    }
  }

  Future<void> uncompleteTask(String id) async {
    final task = await get(id);
    if (task != null) {
      await update(
        task.copyWith(
          isCompleted: false,
          completedAt: null,
          status: task.originalStatus ?? 'in progress',
        ),
      );
    }
  }

  Future<void> startTask(String id) async {
    final task = await get(id);
    if (task != null && !task.hasStarted) {
      await update(
        task.copyWith(
          startDate: DateTime.now(),
          status: 'in progress',
        ),
      );
    }
  }

  Future<void> updateTaskTime(String id, {required int actualHours}) async {
    final task = await get(id);
    if (task != null) {
      await update(
        task.copyWith(
          actualHours: actualHours,
        ),
      );
    }
  }

  Future<void> addSubtask(String parentId, Task subtask) async {
    final parent = await get(parentId);
    if (parent != null) {
      await add(subtask);

      final List<String> subtaskIds = [
        ...(parent.subtaskIds ?? []),
        subtask.id!
      ];
      await update(parent.copyWith(subtaskIds: subtaskIds));
    }
  }

  Future<void> removeSubtask(String parentId, String subtaskId) async {
    final parent = await get(parentId);
    if (parent != null && parent.subtaskIds != null) {
      // Remove subtask ID from parent
      final subtaskIds = [...parent.subtaskIds!]..remove(subtaskId);
      await update(parent.copyWith(subtaskIds: subtaskIds));

      // Delete the subtask
      await delete(subtaskId);
    }
  }
}
