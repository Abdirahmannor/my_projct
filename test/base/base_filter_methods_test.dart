import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../lib/core/base/base_filter_methods.dart';
import '../../lib/core/base/base_item.dart';

// Create a mock item for testing
class MockItem extends BaseItem {
  MockItem({
    String? id,
    required String name,
    String? description,
    required DateTime dueDate,
    required String priority,
    required String status,
    bool? isPinned,
  }) : super(
          id: id,
          name: name,
          description: description,
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
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  @override
  Map<String, dynamic> toMap() => {};
}

// Create mock implementation of BaseFilterMethods
class MockFilter with BaseFilterMethods<MockItem> {}

void main() {
  group('BaseFilterMethods Tests', () {
    late MockFilter filter;
    late List<MockItem> items;
    final now = DateTime.now();

    setUp(() {
      filter = MockFilter();
      items = [
        MockItem(
          id: '1',
          name: 'First Item',
          description: 'Description 1',
          dueDate: now,
          priority: 'high',
          status: 'in progress',
          isPinned: true,
        ),
        MockItem(
          id: '2',
          name: 'Second Item',
          description: 'Description 2',
          dueDate: now.add(const Duration(days: 1)),
          priority: 'low',
          status: 'completed',
          isPinned: false,
        ),
      ];
    });

    group('Search Filtering', () {
      test('should filter by name', () {
        expect(filter.matchesSearch(items[0], 'First'), isTrue);
        expect(filter.matchesSearch(items[0], 'Second'), isFalse);
      });

      test('should filter by description', () {
        expect(filter.matchesSearch(items[0], 'Description 1'), isTrue);
        expect(filter.matchesSearch(items[0], 'Description 2'), isFalse);
      });

      test('should be case insensitive', () {
        expect(filter.matchesSearch(items[0], 'FIRST'), isTrue);
        expect(filter.matchesSearch(items[0], 'description'), isTrue);
      });

      test('should handle null description', () {
        final itemWithoutDesc = MockItem(
          name: 'Test',
          dueDate: now,
          priority: 'high',
          status: 'in progress',
        );
        expect(filter.matchesSearch(itemWithoutDesc, 'description'), isFalse);
      });
    });

    group('Priority Filtering', () {
      test('should filter by priority', () {
        expect(filter.matchesPriority(items[0], 'high'), isTrue);
        expect(filter.matchesPriority(items[0], 'low'), isFalse);
      });

      test('should handle null/all priority', () {
        expect(filter.matchesPriority(items[0], null), isTrue);
        expect(filter.matchesPriority(items[0], 'all'), isTrue);
      });
    });

    group('Status Filtering', () {
      test('should filter by status', () {
        expect(filter.matchesStatus(items[0], 'in progress'), isTrue);
        expect(filter.matchesStatus(items[0], 'completed'), isFalse);
      });

      test('should handle null/all status', () {
        expect(filter.matchesStatus(items[0], null), isTrue);
        expect(filter.matchesStatus(items[0], 'all'), isTrue);
      });
    });

    group('Date Range Filtering', () {
      test('should filter by date range', () {
        final dateRange = DateTimeRange(
          start: now.subtract(const Duration(days: 1)),
          end: now.add(const Duration(days: 2)),
        );
        expect(filter.matchesDateRange(items[0], dateRange), isTrue);
        expect(filter.matchesDateRange(items[1], dateRange), isTrue);
      });

      test('should handle null date range', () {
        expect(filter.matchesDateRange(items[0], null), isTrue);
      });

      test('should exclude items outside range', () {
        final dateRange = DateTimeRange(
          start: now.subtract(const Duration(days: 2)),
          end: now.subtract(const Duration(days: 1)),
        );
        expect(filter.matchesDateRange(items[0], dateRange), isFalse);
      });
    });

    group('Sorting', () {
      test('should sort by name', () {
        final itemsToSort = [...items];
        filter.sortByName(itemsToSort, 'asc');
        expect(itemsToSort.first.name, 'First Item');

        filter.sortByName(itemsToSort, 'desc');
        expect(itemsToSort.first.name, 'Second Item');
      });

      test('should sort by date', () {
        final itemsToSort = [...items];
        filter.sortByDate(itemsToSort, 'asc');
        expect(itemsToSort.first.dueDate, now);

        filter.sortByDate(itemsToSort, 'desc');
        expect(itemsToSort.first.dueDate, now.add(const Duration(days: 1)));
      });

      test('should sort by priority', () {
        final itemsToSort = [...items];
        filter.sortByPriority(itemsToSort, 'asc');
        expect(itemsToSort.first.priority, 'high');

        filter.sortByPriority(itemsToSort, 'desc');
        expect(itemsToSort.first.priority, 'low');
      });

      test('should sort pinned items first', () {
        final itemsToSort = [...items];
        filter.sortByPin(itemsToSort);
        expect(itemsToSort.first.isPinned, isTrue);
      });
    });

    group('Combined Filtering', () {
      test('should apply multiple filters', () {
        final filtered = filter.filterItems(
          items: items,
          searchQuery: 'First',
          priority: 'high',
          status: 'in progress',
          dateRange: DateTimeRange(
            start: now.subtract(const Duration(days: 1)),
            end: now.add(const Duration(days: 1)),
          ),
        );

        expect(filtered.length, 1);
        expect(filtered.first.name, 'First Item');
      });

      test('should handle empty results', () {
        final filtered = filter.filterItems(
          items: items,
          searchQuery: 'Nonexistent',
        );

        expect(filtered.isEmpty, isTrue);
      });
    });
  });
}
