import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../lib/core/base/base_persistence.dart';
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
  Map<String, dynamic> toMap() => {};
}

// Create mock implementation of BasePersistence
class MockPersistence extends BasePersistence<MockItem> {
  MockPersistence()
      : super(boxName: 'mock_items', deletedBoxName: 'deleted_mock_items');
}

void main() {
  group('BasePersistence Tests', () {
    late MockPersistence persistence;

    setUp(() async {
      await Hive.initFlutter();
      persistence = MockPersistence();
    });

    tearDown(() async {
      await Hive.deleteBoxFromDisk('mock_items');
      await Hive.deleteBoxFromDisk('deleted_mock_items');
    });

    test('should save and retrieve item', () async {
      final item = MockItem(
        id: '1',
        name: 'Test Item',
        dueDate: DateTime.now(),
        priority: 'high',
        status: 'in progress',
      );

      await persistence.saveItem(item);
      final retrieved = await persistence.getItem('1');

      expect(retrieved?.name, equals('Test Item'));
    });

    test('should delete item', () async {
      final item = MockItem(
        id: '1',
        name: 'Test Item',
        dueDate: DateTime.now(),
        priority: 'high',
        status: 'in progress',
      );

      await persistence.saveItem(item);
      await persistence.deleteItem('1');
      final retrieved = await persistence.getItem('1');

      expect(retrieved, isNull);
    });

    test('should get all items', () async {
      final items = [
        MockItem(
          id: '1',
          name: 'Item 1',
          dueDate: DateTime.now(),
          priority: 'high',
          status: 'in progress',
        ),
        MockItem(
          id: '2',
          name: 'Item 2',
          dueDate: DateTime.now(),
          priority: 'low',
          status: 'completed',
        ),
      ];

      for (final item in items) {
        await persistence.saveItem(item);
      }

      final allItems = await persistence.getAllItems();
      expect(allItems.length, equals(2));
    });

    test('should update pin state', () async {
      final item = MockItem(
        id: '1',
        name: 'Test Item',
        dueDate: DateTime.now(),
        priority: 'high',
        status: 'in progress',
      );

      await persistence.saveItem(item);
      await persistence.updatePinState('1', true);
      final retrieved = await persistence.getItem('1');

      expect(retrieved?.isPinned, isTrue);
    });

    test('should cleanup old items', () async {
      final item = MockItem(
        id: '1',
        name: 'Old Item',
        dueDate: DateTime.now(),
        priority: 'high',
        status: 'in progress',
      );

      final deletedBox = await persistence.deletedBox;
      await deletedBox.put('1', item);

      await persistence.cleanupOldItems(30);
      final items = await persistence.getAllItems();
      expect(items.length, equals(0));
    });
  });
}
