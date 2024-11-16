import 'package:flutter_test/flutter_test.dart';
import '../../../../lib/features/projects/models/project.dart';

void main() {
  group('Project Model Tests', () {
    final now = DateTime.now();
    late Project project;

    setUp(() {
      project = Project(
        id: '1',
        name: 'Test Project',
        description: 'Test Description',
        dueDate: now,
        priority: 'high',
        status: 'in progress',
        tasks: 10,
        completedTasks: 5,
        category: 'work',
        isPinned: false,
      );
    });

    test('should create project with all fields', () {
      expect(project.id, '1');
      expect(project.name, 'Test Project');
      expect(project.description, 'Test Description');
      expect(project.dueDate, now);
      expect(project.priority, 'high');
      expect(project.status, 'in progress');
      expect(project.tasks, 10);
      expect(project.completedTasks, 5);
      expect(project.category, 'work');
      expect(project.isPinned, false);
      expect(project.originalStatus, null);
      expect(project.archivedDate, null);
    });

    test('should calculate progress correctly', () {
      expect(project.progress, 0.5); // 5/10 tasks completed

      final noTasks = Project(
        name: 'No Tasks',
        dueDate: now,
        priority: 'low',
        status: 'not started',
        tasks: 0,
        completedTasks: 0,
      );
      expect(noTasks.progress, 0.0);

      final completed = Project(
        name: 'Completed',
        dueDate: now,
        priority: 'high',
        status: 'completed',
        tasks: 3,
        completedTasks: 3,
      );
      expect(completed.progress, 1.0);
    });

    test('should determine completion status correctly', () {
      expect(project.isCompleted, false); // 5/10 tasks completed

      final completed = Project(
        name: 'Completed',
        dueDate: now,
        priority: 'high',
        status: 'completed',
        tasks: 3,
        completedTasks: 3,
      );
      expect(completed.isCompleted, true);
    });

    test('should copy with new values', () {
      final newDate = DateTime.now().add(const Duration(days: 1));
      final copiedProject = project.copyWith(
        name: 'New Name',
        description: 'New Description',
        dueDate: newDate,
        priority: 'low',
        status: 'completed',
        tasks: 15,
        completedTasks: 7,
        category: 'personal',
        isPinned: true,
        originalStatus: 'in progress',
        archivedDate: now,
      );

      expect(copiedProject.id, '1'); // Unchanged
      expect(copiedProject.name, 'New Name');
      expect(copiedProject.description, 'New Description');
      expect(copiedProject.dueDate, newDate);
      expect(copiedProject.priority, 'low');
      expect(copiedProject.status, 'completed');
      expect(copiedProject.tasks, 15);
      expect(copiedProject.completedTasks, 7);
      expect(copiedProject.category, 'personal');
      expect(copiedProject.isPinned, true);
      expect(copiedProject.originalStatus, 'in progress');
      expect(copiedProject.archivedDate, now);
    });

    test('should convert to map', () {
      final map = project.toMap();

      expect(map['id'], '1');
      expect(map['name'], 'Test Project');
      expect(map['description'], 'Test Description');
      expect(map['dueDate'], now.toIso8601String());
      expect(map['priority'], 'high');
      expect(map['status'], 'in progress');
      expect(map['tasks'], 10);
      expect(map['completedTasks'], 5);
      expect(map['category'], 'work');
      expect(map['isPinned'], false);
      expect(map['originalStatus'], null);
      expect(map['archivedDate'], null);
    });

    test('should create from map', () {
      final map = {
        'id': '1',
        'name': 'Test Project',
        'description': 'Test Description',
        'dueDate': now.toIso8601String(),
        'priority': 'high',
        'status': 'in progress',
        'tasks': 10,
        'completedTasks': 5,
        'category': 'work',
        'isPinned': false,
        'originalStatus': null,
        'archivedDate': null,
      };

      final fromMap = Project.fromMap(map);

      expect(fromMap.id, '1');
      expect(fromMap.name, 'Test Project');
      expect(fromMap.description, 'Test Description');
      expect(fromMap.dueDate.toIso8601String(), now.toIso8601String());
      expect(fromMap.priority, 'high');
      expect(fromMap.status, 'in progress');
      expect(fromMap.tasks, 10);
      expect(fromMap.completedTasks, 5);
      expect(fromMap.category, 'work');
      expect(fromMap.isPinned, false);
      expect(fromMap.originalStatus, null);
      expect(fromMap.archivedDate, null);
    });
  });
}
