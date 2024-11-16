import 'package:flutter_test/flutter_test.dart';
import '../../lib/core/base/base_item.dart';

class TestItem extends BaseItem {
  TestItem({
    String? id,
    required String name,
    String? description,
    required DateTime dueDate,
    required String priority,
    required String status,
    bool? isPinned,
    DateTime? deletedAt,
    DateTime? lastRestoredDate,
  }) : super(
          id: id,
          name: name,
          description: description,
          dueDate: dueDate,
          priority: priority,
          status: status,
          isPinned: isPinned,
          deletedAt: deletedAt,
          lastRestoredDate: lastRestoredDate,
        );

  @override
  TestItem copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? dueDate,
    String? priority,
    String? status,
    bool? isPinned,
    DateTime? deletedAt,
    DateTime? lastRestoredDate,
  }) {
    return TestItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      isPinned: isPinned ?? this.isPinned,
      deletedAt: deletedAt ?? this.deletedAt,
      lastRestoredDate: lastRestoredDate ?? this.lastRestoredDate,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'status': status,
      'isPinned': isPinned,
      'deletedAt': deletedAt?.toIso8601String(),
      'lastRestoredDate': lastRestoredDate?.toIso8601String(),
    };
  }
}

void main() {
  group('BaseItem Tests', () {
    final now = DateTime.now();
    late TestItem testItem;

    setUp(() {
      testItem = TestItem(
        id: '1',
        name: 'Test Item',
        description: 'Test Description',
        dueDate: now,
        priority: 'high',
        status: 'in progress',
        isPinned: false,
      );
    });

    test('should create item with required fields', () {
      expect(testItem.id, '1');
      expect(testItem.name, 'Test Item');
      expect(testItem.dueDate, now);
      expect(testItem.priority, 'high');
      expect(testItem.status, 'in progress');
    });

    test('should create item with optional fields', () {
      expect(testItem.description, 'Test Description');
      expect(testItem.isPinned, false);
      expect(testItem.deletedAt, null);
      expect(testItem.lastRestoredDate, null);
    });

    test('should copy with new values', () {
      final newDate = DateTime.now().add(const Duration(days: 1));
      final copiedItem = testItem.copyWith(
        name: 'New Name',
        description: 'New Description',
        dueDate: newDate,
        priority: 'low',
        status: 'completed',
        isPinned: true,
      );

      expect(copiedItem.id, '1'); // Unchanged
      expect(copiedItem.name, 'New Name');
      expect(copiedItem.description, 'New Description');
      expect(copiedItem.dueDate, newDate);
      expect(copiedItem.priority, 'low');
      expect(copiedItem.status, 'completed');
      expect(copiedItem.isPinned, true);
    });

    test('should copy with partial values', () {
      final copiedItem = testItem.copyWith(
        name: 'New Name',
      );

      expect(copiedItem.name, 'New Name');
      expect(copiedItem.description, 'Test Description'); // Unchanged
      expect(copiedItem.dueDate, now); // Unchanged
      expect(copiedItem.priority, 'high'); // Unchanged
      expect(copiedItem.status, 'in progress'); // Unchanged
      expect(copiedItem.isPinned, false); // Unchanged
    });

    test('should convert to map', () {
      final map = testItem.toMap();

      expect(map['id'], '1');
      expect(map['name'], 'Test Item');
      expect(map['description'], 'Test Description');
      expect(map['dueDate'], now.toIso8601String());
      expect(map['priority'], 'high');
      expect(map['status'], 'in progress');
      expect(map['isPinned'], false);
      expect(map['deletedAt'], null);
      expect(map['lastRestoredDate'], null);
    });

    test('should handle deletion dates', () {
      final deletedAt = DateTime.now();
      final deletedItem = testItem.copyWith(deletedAt: deletedAt);
      final map = deletedItem.toMap();

      expect(map['deletedAt'], deletedAt.toIso8601String());
    });

    test('should handle restoration dates', () {
      final restoredAt = DateTime.now();
      final restoredItem = testItem.copyWith(lastRestoredDate: restoredAt);
      final map = restoredItem.toMap();

      expect(map['lastRestoredDate'], restoredAt.toIso8601String());
    });
  });
}
