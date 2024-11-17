// import 'package:hive_flutter/hive_flutter.dart';
// import '../models/project.dart';
// import 'package:uuid/uuid.dart';

// class ProjectDatabaseService {
//   static const String boxName = 'projects';
//   static const String deletedBoxName = 'deleted_projects';
//   final _uuid = const Uuid();

<<<<<<< HEAD
  // Single method to get box
  Box<Project> getBox() {
    if (!Hive.isBoxOpen(boxName)) {
      throw Exception('Box is not open. Please initialize first.');
    }
    return Hive.box<Project>(boxName);
  }

  Box<Project> getDeletedBox() {
    if (!Hive.isBoxOpen(deletedBoxName)) {
      throw Exception('Deleted box is not open. Please initialize first.');
    }
    return Hive.box<Project>(deletedBoxName);
  }

  Future<void> init() async {
    try {
      await Hive.openBox<Project>(boxName);
      await Hive.openBox<Project>(deletedBoxName);
      print('ProjectDatabaseService initialized');
      print('Projects in box: ${getBox().length}');
    } catch (e) {
      print('Error initializing ProjectDatabaseService: $e');
      rethrow;
    }
  }

  // Create
  Future<void> addProject(Project project) async {
    final box = getBox();
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

  // Archive project
  Future<void> archiveProject(Project project) async {
    final box = getBox();
    final archivedProject = Project(
      id: project.id,
      name: project.name,
      description: project.description,
      startDate: project.startDate,
      dueDate: project.dueDate,
      tasks: project.tasks,
      completedTasks: project.completedTasks,
      priority: project.priority,
      status: 'completed',
      category: project.category,
      archivedDate: DateTime.now(),
    );
    await box.put(project.id!, archivedProject);
  }

  // Move archived to recycle bin
  Future<void> moveArchivedToRecycleBin(Project project) async {
    final box = getBox();
    final deletedBox = getDeletedBox();
=======
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
>>>>>>> 4bcc1dd96e70ceefa4cbf56552da0566cd5a6bab

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

<<<<<<< HEAD
  // Restore from recycle bin to archived
  Future<void> restoreToArchived(String projectId) async {
    final box = getBox();
    final deletedBox = getDeletedBox();

    final project = deletedBox.get(projectId);
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
        status: 'completed',
        category: project.category,
        archivedDate: DateTime.now(),
        lastRestoredDate: DateTime.now(),
      );
=======
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
>>>>>>> 4bcc1dd96e70ceefa4cbf56552da0566cd5a6bab

//       await box.put(projectId, restoredProject);
//       await deletedBox.delete(projectId);
//     }
//   }

<<<<<<< HEAD
  // Clean up old archived projects (move to recycle bin after 2 months)
  Future<void> cleanupOldArchivedProjects() async {
    final box = getBox();
    final now = DateTime.now();
    final projects = box.values.where((p) => p.status == 'completed').toList();
=======
//   // Clean up old archived projects (move to recycle bin after 2 months)
//   Future<void> cleanupOldArchivedProjects() async {
//     final box = await _box;
//     final now = DateTime.now();
//     final projects = box.values.where((p) => p.status == 'completed').toList();
>>>>>>> 4bcc1dd96e70ceefa4cbf56552da0566cd5a6bab

//     for (final project in projects) {
//       if (project.archivedDate != null) {
//         final difference = now.difference(project.archivedDate!);
//         if (difference.inDays >= 60) {
//           await moveArchivedToRecycleBin(project);
//         }
//       }
//     }
//   }

<<<<<<< HEAD
  // Update existing cleanup method for recycle bin
  Future<void> cleanupOldProjects() async {
    final deletedBox = getDeletedBox();
    final now = DateTime.now();
    final deletedProjects = deletedBox.values.toList();
=======
//   // Update existing cleanup method for recycle bin
//   Future<void> cleanupOldProjects() async {
//     final deletedBox = await _deletedBox;
//     final now = DateTime.now();
//     final deletedProjects = deletedBox.values.toList();
>>>>>>> 4bcc1dd96e70ceefa4cbf56552da0566cd5a6bab

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

<<<<<<< HEAD
  // Read
  Future<List<Project>> getAllProjects() async {
    final box = getBox();
    return box.values.toList();
  }

  Project? getProject(String id) {
    try {
      final box = getBox();
      return box.get(id);
    } catch (e) {
      print('Error getting project: $e');
      return null;
    }
  }

  // Update
  Future<void> updateProject(Project project) async {
    final box = getBox();
    await box.put(project.id, project);
  }

  // Delete
  Future<void> deleteProject(String id) async {
    final box = getBox();
    await box.delete(id);
  }

  // Move project to recycle bin
  Future<void> moveToRecycleBin(Project project) async {
    final box = getBox();
    final deletedBox = getDeletedBox();
=======
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
>>>>>>> 4bcc1dd96e70ceefa4cbf56552da0566cd5a6bab

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

<<<<<<< HEAD
  // Get all deleted projects
  Future<List<Project>> getDeletedProjects() async {
    final deletedBox = getDeletedBox();
    return deletedBox.values.toList();
  }

  // Restore project from recycle bin
  Future<void> restoreFromRecycleBin(String projectId) async {
    final box = getBox();
    final deletedBox = getDeletedBox();

    final project = deletedBox.get(projectId);
    if (project != null) {
      // Always restore to active projects
      final restoredProject = Project(
        id: project.id,
        name: project.name,
        description: project.description,
        startDate: project.startDate,
        dueDate: project.dueDate,
        tasks: project.tasks,
        completedTasks: project.completedTasks,
        priority: project.priority,
        status: 'in progress', // Always set to in progress
        category: project.category,
        // Clear all special dates since it's going back to active projects
        archivedDate: null,
        lastRestoredDate: null,
        deletedAt: null,
      );
=======
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
>>>>>>> 4bcc1dd96e70ceefa4cbf56552da0566cd5a6bab

//       // Save to active projects
//       await box.put(projectId, restoredProject);
//       // Remove from recycle bin
//       await deletedBox.delete(projectId);
//     }
//   }

<<<<<<< HEAD
  // Permanently delete project
  Future<void> permanentlyDelete(String projectId) async {
    final deletedBox = getDeletedBox();
    await deletedBox.delete(projectId);
  }

  // Clear all data
  Future<void> clearAllData() async {
    final box = getBox();
    final deletedBox = getDeletedBox();

    print('Before clearing:');
    print('Projects in main box: ${box.length}');
    print('Projects in deleted box: ${deletedBox.length}');

    await box.clear();
    await deletedBox.clear();

    print('After clearing:');
    print('Projects in main box: ${box.length}');
    print('Projects in deleted box: ${deletedBox.length}');
  }

  // Add sample projects for testing
  Future<void> addSampleProjects() async {
    final box = getBox();

    final projects = [
      Project(
        id: const Uuid().v4(),
        name: 'Math Assignment',
        description: 'Complete calculus homework',
        startDate: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(days: 7)),
        priority: 'High',
        status: 'In Progress',
        category: 'Homework',
      ),
      Project(
        id: const Uuid().v4(),
        name: 'Physics Project',
        description: 'Research paper on quantum mechanics',
        startDate: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(days: 14)),
        priority: 'Medium',
        status: 'Not Started',
        category: 'Research',
      ),
      Project(
        id: const Uuid().v4(),
        name: 'History Essay',
        description: 'Write about World War II',
        startDate: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(days: 5)),
        priority: 'High',
        status: 'In Progress',
        category: 'Essay',
      ),
    ];

    for (final project in projects) {
      await box.put(project.id, project);
    }

    print('Added ${projects.length} sample projects');
    print('Total projects in box: ${box.length}');
  }
}
=======
//   // Permanently delete project
//   Future<void> permanentlyDelete(String projectId) async {
//     final deletedBox = await _deletedBox;
//     await deletedBox.delete(projectId);
//   }
// }
>>>>>>> 4bcc1dd96e70ceefa4cbf56552da0566cd5a6bab
