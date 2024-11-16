import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../lib/core/base/base_database.dart';
import '../../lib/core/base/base_item.dart';

// Create a mock item for testing
class MockItem extends BaseItem {
  MockItem({
    String? id,
    required String name,
    required DateTime dueDate,
    required String priority,
    required String status,
  }) : super(
          id: id,
          name: name,
          dueDate: dueDate,
          priority: priority,
          status: status,
        );

  @override
  MockItem copyWith({
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
    return MockItem(
      id: id ?? this.id,
      name: name ?? this.name,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'dueDate': dueDate.toIso8601String(),
        'priority': priority,
        'status': status,
      };
}

// Create mock implementation of BaseDatabase
class MockDatabase extends BaseDatabase<MockItem> {
  MockDatabase()
      : super(boxName: 'mock_items', deletedBoxName: 'deleted_mock_items');

  @override
  Future<void> add(MockItem item) async {
    final itemBox = await box;
    await itemBox.put(item.id, item);
  }

  @override
  Future<void> update(MockItem item) async {
    final itemBox = await box;
    await itemBox.put(item.id, item);
  }

  @override
  Future<void> delete(String id) async {
    final itemBox = await box;
    await itemBox.delete(id);
  }

  @override
  Future<MockItem?> get(String id) async {
    final itemBox = await box;
    return itemBox.get(id);
  }

  @override
  Future<List<MockItem>> getAll() async {
    final itemBox = await box;
    return itemBox.values.toList();
  }

  @override
  Future<List<MockItem>> getDeleted() async {
    final deletedItemBox = await deletedBox;
    return deletedItemBox.values.toList();
  }

  @override
  Future<void> moveToRecycleBin(MockItem item) async {
    final itemBox = await box;
    final deletedItemBox = await deletedBox;

    await itemBox.delete(item.id);
    await deletedItemBox.put(
        item.id,
        item.copyWith(
          deletedAt: DateTime.now(),
        ));
  }

  @override
  Future<void> restoreFromRecycleBin(String id) async {
    final itemBox = await box;
    final deletedItemBox = await deletedBox;

    final item = await deletedItemBox.get(id);
    if (item != null) {
      await itemBox.put(
          id,
          item.copyWith(
            deletedAt: null,
            lastRestoredDate: DateTime.now(),
          ));
      await deletedItemBox.delete(id);
    }
  }

  @override
  Future<void> permanentlyDelete(String id) async {
    final deletedItemBox = await deletedBox;
    await deletedItemBox.delete(id);
  }

  @override
  Future<void> cleanupOldItems(int days) async {
    final deletedItemBox = await deletedBox;
    final now = DateTime.now();
    final items = deletedItemBox.values.toList();

    for (final item in items) {
      if (item.deletedAt != null) {
        final difference = now.difference(item.deletedAt!);
        if (difference.inDays >= days) {
          await deletedItemBox.delete(item.id);
        }
      }
    }
  }
}

void main() {
  group('BaseDatabase Tests', () {
    late MockDatabase database;

    setUp(() async {
      await Hive.initFlutter();
      database = MockDatabase();
    });

    tearDown(() async {
      await Hive.deleteBoxFromDisk('mock_items');
      await Hive.deleteBoxFromDisk('deleted_mock_items');
    });

    test('should add and retrieve item', () async {
      final item = MockItem(
        id: '1',
        name: 'Test Item',
        dueDate: DateTime.now(),
        priority: 'high',
        status: 'in progress',
      );

      await database.add(item);
      final retrieved = await database.get('1');

      expect(retrieved?.name, equals('Test Item'));
      expect(retrieved?.priority, equals('high'));
    });

    test('should update item', () async {
      final item = MockItem(
        id: '1',
        name: 'Test Item',
        dueDate: DateTime.now(),
        priority: 'high',
        status: 'in progress',
      );

      await database.add(item);

      final updatedItem = MockItem(
        id: '1',
        name: 'Updated Item',
        dueDate: DateTime.now(),
        priority: 'low',
        status: 'completed',
      );

      await database.update(updatedItem);
      final retrieved = await database.get('1');

      expect(retrieved?.name, equals('Updated Item'));
      expect(retrieved?.priority, equals('low'));
    });

    test('should move item to recycle bin', () async {
      final item = MockItem(
        id: '1',
        name: 'Test Item',
        dueDate: DateTime.now(),
        priority: 'high',
        status: 'in progress',
      );

      await database.add(item);
      await database.moveToRecycleBin(item);

      final deletedItems = await database.getDeleted();
      expect(deletedItems.length, equals(1));
      expect(deletedItems.first.name, equals('Test Item'));
      expect(deletedItems.first.deletedAt, isNotNull);
    });

    test('should restore item from recycle bin', () async {
      final item = MockItem(
        id: '1',
        name: 'Test Item',
        dueDate: DateTime.now(),
        priority: 'high',
        status: 'in progress',
      );

      await database.add(item);
      await database.moveToRecycleBin(item);
      await database.restoreFromRecycleBin('1');

      final activeItems = await database.getAll();
      final deletedItems = await database.getDeleted();

      expect(activeItems.length, equals(1));
      expect(deletedItems.length, equals(0));
      expect(activeItems.first.lastRestoredDate, isNotNull);
    });

    test('should cleanup old items', () async {
      final oldItem = MockItem(
        id: '1',
        name: 'Old Item',
        dueDate: DateTime.now(),
        priority: 'high',
        status: 'in progress',
      );

      await database.add(oldItem);
      await database.moveToRecycleBin(oldItem);

      // Simulate item being deleted 31 days ago
      final deletedItemBox = await database.deletedBox;
      final item = await deletedItemBox.get('1');
      if (item != null) {
        await deletedItemBox.put(
            '1',
            item.copyWith(
              deletedAt: DateTime.now().subtract(const Duration(days: 31)),
            ));
      }

      await database.cleanupOldItems(30); // Cleanup items older than 30 days
      final deletedItems = await database.getDeleted();
      expect(deletedItems.length, equals(0));
    });

    // Add more tests...
  });
}
