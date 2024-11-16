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
        final now = DateTime.now();
        final itemsToSort = [
          MockItem(
            name: 'Item 1',
            dueDate: now.add(const Duration(days: 1)),
            priority: 'high',
            status: 'in progress',
          ),
          MockItem(
            name: 'Item 2',
            dueDate: now,
            priority: 'low',
            status: 'completed',
          ),
        ];

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

      test('should handle invalid sort type', () {
        final itemsToSort = [...items];
        final originalOrder = [...itemsToSort];
        stateManager.handleSort(itemsToSort, 'invalid', 'asc');
        expect(itemsToSort, equals(originalOrder));
      });
    });

    group('Selection Management', () {
      test('should toggle select all', () {
        final checkedItems = List.generate(items.length, (_) => false);
        stateManager.toggleSelectAll(checkedItems, true);
        expect(checkedItems.every((checked) => checked), isTrue);

        stateManager.toggleSelectAll(checkedItems, false);
        expect(checkedItems.every((checked) => !checked), isTrue);
      });
    });

    group('Search Management', () {
      test('should match search query', () {
        expect(stateManager.matchesSearch(items[0], 'Item 1'), isTrue);
        expect(stateManager.matchesSearch(items[0], 'Item 2'), isFalse);
        expect(stateManager.matchesSearch(items[0], 'item'),
            isTrue); // Case insensitive
      });

      test('should handle empty search query', () {
        expect(stateManager.matchesSearch(items[0], ''), isTrue);
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
