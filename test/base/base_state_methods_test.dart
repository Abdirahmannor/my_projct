import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../lib/core/base/base_state_methods.dart';
import '../../lib/core/base/base_item.dart';

// Create a mock item for testing
class MockItem extends BaseItem {
  MockItem({
    String? id,
    required String name,
    required DateTime dueDate,
    required String priority,
    required String status,
    bool? isPinned,
  }) : super(
          id: id,
          name: name,
          dueDate: dueDate,
          priority: priority,
          status: status,
          isPinned: isPinned,
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
      isPinned: isPinned ?? this.isPinned,
    );
  }

  @override
  Map<String, dynamic> toMap() => {};
}

// Create mock implementation of BaseStateMethods
class MockStateManager with BaseStateMethods<MockItem> {}

void main() {
  group('BaseStateMethods Tests', () {
    late MockStateManager stateManager;
    late List<bool> checkedItems;
    late List<MockItem> items;

    setUp(() {
      stateManager = MockStateManager();
      items = [
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
      checkedItems = List.generate(items.length, (_) => false);
    });

    group('Selection Management', () {
      test('should toggle select all', () {
        stateManager.toggleSelectAll(checkedItems, true);
        expect(checkedItems.every((checked) => checked), true);

        stateManager.toggleSelectAll(checkedItems, false);
        expect(checkedItems.every((checked) => !checked), true);
      });
    });

    group('Sort Management', () {
      test('should handle name sorting', () {
        final itemsToSort = [...items];
        stateManager.handleSort(itemsToSort, 'name', 'asc');
        expect(itemsToSort.first.name, 'Item 1');

        stateManager.handleSort(itemsToSort, 'name', 'desc');
        expect(itemsToSort.first.name, 'Item 2');
      });

      test('should handle date sorting', () {
        final itemsToSort = [...items];
        final now = DateTime.now();
        itemsToSort[0] =
            itemsToSort[0].copyWith(dueDate: now.add(const Duration(days: 1)));
        itemsToSort[1] = itemsToSort[1].copyWith(dueDate: now);

        stateManager.handleSort(itemsToSort, 'date', 'asc');
        expect(itemsToSort.first.dueDate, now);

        stateManager.handleSort(itemsToSort, 'date', 'desc');
        expect(itemsToSort.first.dueDate, now.add(const Duration(days: 1)));
      });

      test('should handle priority sorting', () {
        final itemsToSort = [...items];
        stateManager.handleSort(itemsToSort, 'priority', 'asc');
        expect(itemsToSort.first.priority, 'high');

        stateManager.handleSort(itemsToSort, 'priority', 'desc');
        expect(itemsToSort.first.priority, 'low');
      });
    });

    group('Search Management', () {
      test('should match search query', () {
        expect(stateManager.matchesSearch(items[0], 'Item 1'), true);
        expect(stateManager.matchesSearch(items[0], 'Item 2'), false);
        expect(stateManager.matchesSearch(items[0], 'item'),
            true); // Case insensitive
      });
    });

    testWidgets('should show success message for filter clearing',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () => stateManager.clearFilters(context),
                child: const Text('Clear Filters'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Clear Filters'));
      await tester.pumpAndSettle();

      expect(find.text('All filters have been cleared'), findsOneWidget);
    });
  });
}
