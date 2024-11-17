// import 'package:hive_flutter/hive_flutter.dart';
// import '../models/project.dart';
// import 'package:uuid/uuid.dart';

// class ProjectDatabaseService {
//   static const String boxName = 'projects';
//   static const String deletedBoxName = 'deleted_projects';
//   final _uuid = const Uuid();

//   // Get box instances
//   Future<Box<Project>> get _box async => await Hive.openBox<Project>(boxName);
//   Future<Box<Project>> get _deletedBox async =>
//       await Hive.openBox<Project>(deletedBoxName);

//   // Create
//   Future<void> addProject(Project project) async {
//     final box = await _box;
//     final id = _uuid.v4();
//     final newProject = Project(
//       id: id,
//       name: project.name,
//       description: project.description,
//       startDate: project.startDate,
//       dueDate: project.dueDate,
//       tasks: project.tasks,
//       completedTasks: project.completedTasks,
//       priority: project.priority,
//       status: project.status,
//       category: project.category,
//     );
//     await box.put(id, newProject);
//   }

//   // Archive project
//   Future<void> archiveProject(Project project) async {
//     final box = await _box;
//     final archivedProject = Project(
//       id: project.id,
//       name: project.name,
//       description: project.description,
//       startDate: project.startDate,
//       dueDate: project.dueDate,
//       tasks: project.tasks,
//       completedTasks: project.completedTasks,
//       priority: project.priority,
//       status: 'completed',
//       category: project.category,
//       archivedDate: DateTime.now(),
//     );
//     await box.put(project.id!, archivedProject);
//   }

//   // Move archived to recycle bin
//   Future<void> moveArchivedToRecycleBin(Project project) async {
//     final box = await _box;
//     final deletedBox = await _deletedBox;

//     final deletedProject = Project(
//       id: project.id,
//       name: project.name,
//       description: project.description,
//       startDate: project.startDate,
//       dueDate: project.dueDate,
//       tasks: project.tasks,
//       completedTasks: project.completedTasks,
//       priority: project.priority,
//       status: project.status,
//       category: project.category,
//       archivedDate: project.archivedDate,
//       deletedAt: DateTime.now(),
//     );

//     await deletedBox.put(project.id, deletedProject);
//     await box.delete(project.id);
//   }

//   // Restore from recycle bin to archived
//   Future<void> restoreToArchived(String projectId) async {
//     final box = await _box;
//     final deletedBox = await _deletedBox;

//     final project = await deletedBox.get(projectId);
//     if (project != null) {
//       final restoredProject = Project(
//         id: project.id,
//         name: project.name,
//         description: project.description,
//         startDate: project.startDate,
//         dueDate: project.dueDate,
//         tasks: project.tasks,
//         completedTasks: project.completedTasks,
//         priority: project.priority,
//         status: 'completed',
//         category: project.category,
//         archivedDate: DateTime.now(),
//         lastRestoredDate: DateTime.now(),
//       );

//       await box.put(projectId, restoredProject);
//       await deletedBox.delete(projectId);
//     }
//   }

//   // Clean up old archived projects (move to recycle bin after 2 months)
//   Future<void> cleanupOldArchivedProjects() async {
//     final box = await _box;
//     final now = DateTime.now();
//     final projects = box.values.where((p) => p.status == 'completed').toList();

//     for (final project in projects) {
//       if (project.archivedDate != null) {
//         final difference = now.difference(project.archivedDate!);
//         if (difference.inDays >= 60) {
//           await moveArchivedToRecycleBin(project);
//         }
//       }
//     }
//   }

//   // Update existing cleanup method for recycle bin
//   Future<void> cleanupOldProjects() async {
//     final deletedBox = await _deletedBox;
//     final now = DateTime.now();
//     final deletedProjects = deletedBox.values.toList();

//     for (final project in deletedProjects) {
//       if (project.deletedAt != null) {
//         final difference = now.difference(project.deletedAt!);
//         if (difference.inDays >= 7) {
//           await deletedBox.delete(project.id);
//         }
//       }
//     }

//     // Also cleanup old archived projects
//     await cleanupOldArchivedProjects();
//   }

//   // Read
//   Future<List<Project>> getAllProjects() async {
//     final box = await _box;
//     return box.values.toList();
//   }

//   Future<Project?> getProject(String id) async {
//     final box = await _box;
//     return box.get(id);
//   }

//   // Update
//   Future<void> updateProject(Project project) async {
//     final box = await _box;
//     final existingProject = await box.get(project.id);
//     final updatedProject = project.copyWith(
//       isPinned: project.isPinned ?? existingProject?.isPinned ?? false,
//     );
//     await box.put(project.id, updatedProject);
//   }

//   // Delete
//   Future<void> deleteProject(String id) async {
//     final box = await _box;
//     await box.delete(id);
//   }

//   // Move project to recycle bin
//   Future<void> moveToRecycleBin(Project project) async {
//     final box = await _box;
//     final deletedBox = await _deletedBox;

//     final projectWithDeleteDate = Project(
//       id: project.id,
//       name: project.name,
//       description: project.description,
//       startDate: project.startDate,
//       dueDate: project.dueDate,
//       tasks: project.tasks,
//       completedTasks: project.completedTasks,
//       priority: project.priority,
//       status: project.status,
//       category: project.category,
//       deletedAt: DateTime.now(),
//     );

//     await deletedBox.put(project.id, projectWithDeleteDate);
//     await box.delete(project.id);
//   }

//   // Get all deleted projects
//   Future<List<Project>> getDeletedProjects() async {
//     final deletedBox = await _deletedBox;
//     return deletedBox.values.toList();
//   }

//   // Restore project from recycle bin
//   Future<void> restoreFromRecycleBin(String projectId) async {
//     final box = await _box;
//     final deletedBox = await _deletedBox;

//     final project = await deletedBox.get(projectId);
//     if (project != null) {
//       // Always restore to active projects
//       final restoredProject = Project(
//         id: project.id,
//         name: project.name,
//         description: project.description,
//         startDate: project.startDate,
//         dueDate: project.dueDate,
//         tasks: project.tasks,
//         completedTasks: project.completedTasks,
//         priority: project.priority,
//         status: 'in progress', // Always set to in progress
//         category: project.category,
//         // Clear all special dates since it's going back to active projects
//         archivedDate: null,
//         lastRestoredDate: null,
//         deletedAt: null,
//       );

//       // Save to active projects
//       await box.put(projectId, restoredProject);
//       // Remove from recycle bin
//       await deletedBox.delete(projectId);
//     }
//   }

//   // Permanently delete project
//   Future<void> permanentlyDelete(String projectId) async {
//     final deletedBox = await _deletedBox;
//     await deletedBox.delete(projectId);
//   }
// }
