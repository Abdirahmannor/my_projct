import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../lib/core/base/base_filter_methods.dart';
import '../../lib/core/base/base_item.dart';

// Create a mock item for testing
class MockItem extends BaseItem {
  MockItem({
    required String name,
    String? description,
    required DateTime dueDate,
    required String priority,
    required String status,
    bool? isPinned,
  }) : super(
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

    setUp(() {
      filter = MockFilter();
      items = [
        MockItem(
          name: 'Test Item 1',
          description: 'Description 1',
          dueDate: DateTime(2024, 3, 15),
          priority: 'high',
          status: 'in progress',
        ),
        MockItem(
          name: 'Test Item 2',
          description: 'Description 2',
          dueDate: DateTime(2024, 3, 20),
          priority: 'low',
          status: 'completed',
          isPinned: true,
        ),
      ];
    });

    group('Search Filtering', () {
      test('should filter by name', () {
        expect(filter.matchesSearch(items[0], 'Item 1'), true);
        expect(filter.matchesSearch(items[0], 'Item 2'), false);
      });

      test('should filter by description', () {
        expect(filter.matchesSearch(items[0], 'Description 1'), true);
        expect(filter.matchesSearch(items[0], 'Description 2'), false);
      });

      test('should be case insensitive', () {
        expect(filter.matchesSearch(items[0], 'TEST'), true);
        expect(filter.matchesSearch(items[0], 'description'), true);
      });
    });

    group('Priority Filtering', () {
      test('should filter by priority', () {
        expect(filter.matchesPriority(items[0], 'high'), true);
        expect(filter.matchesPriority(items[0], 'low'), false);
      });

      test('should accept null priority as all', () {
        expect(filter.matchesPriority(items[0], null), true);
        expect(filter.matchesPriority(items[0], 'all'), true);
      });
    });

    group('Status Filtering', () {
      test('should filter by status', () {
        expect(filter.matchesStatus(items[0], 'in progress'), true);
        expect(filter.matchesStatus(items[0], 'completed'), false);
      });

      test('should accept null status as all', () {
        expect(filter.matchesStatus(items[0], null), true);
        expect(filter.matchesStatus(items[0], 'all'), true);
      });
    });

    group('Date Range Filtering', () {
      test('should filter by date range', () {
        final dateRange = DateTimeRange(
          start: DateTime(2024, 3, 14),
          end: DateTime(2024, 3, 16),
        );
        expect(filter.matchesDateRange(items[0], dateRange), true);
        expect(filter.matchesDateRange(items[1], dateRange), false);
      });

      test('should accept null date range', () {
        expect(filter.matchesDateRange(items[0], null), true);
      });
    });

    group('Sorting', () {
      test('should sort by name', () {
        final itemsToSort = [...items];
        filter.sortByName(itemsToSort, 'asc');
        expect(itemsToSort.first.name, 'Test Item 1');

        filter.sortByName(itemsToSort, 'desc');
        expect(itemsToSort.first.name, 'Test Item 2');
      });

      test('should sort by date', () {
        final itemsToSort = [...items];
        filter.sortByDate(itemsToSort, 'asc');
        expect(itemsToSort.first.dueDate, DateTime(2024, 3, 15));

        filter.sortByDate(itemsToSort, 'desc');
        expect(itemsToSort.first.dueDate, DateTime(2024, 3, 20));
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
        expect(itemsToSort.first.isPinned, true);
      });
    });

    group('Combined Filtering', () {
      test('should apply multiple filters', () {
        final filtered = filter.filterItems(
          items: items,
          searchQuery: 'Item 1',
          priority: 'high',
          status: 'in progress',
          dateRange: DateTimeRange(
            start: DateTime(2024, 3, 14),
            end: DateTime(2024, 3, 16),
          ),
        );

        expect(filtered.length, 1);
        expect(filtered.first.name, 'Test Item 1');
      });
    });
  });
}
