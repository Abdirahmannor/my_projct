import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../lib/core/base/base_state.dart';
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

// Create concrete implementation of BaseState for testing
class TestState extends BaseState<MockItem> {}

void main() {
  group('BaseState Tests', () {
    late TestState state;

    setUp(() {
      state = TestState();
    });

    test('should initialize with default values', () {
      expect(state.selectedPriority, isNull);
      expect(state.selectedStatus, isNull);
      expect(state.selectedNameSort, isNull);
      expect(state.selectedStartDateSort, isNull);
      expect(state.selectedDueDateSort, isNull);
      expect(state.selectedTasksSort, isNull);
      expect(state.selectedDateRange, isNull);
      expect(state.searchQuery, isEmpty);
      expect(state.isListView, isTrue);
      expect(state.showArchived, isFalse);
      expect(state.showRecycleBin, isFalse);
      expect(state.items, isEmpty);
      expect(state.archivedItems, isEmpty);
      expect(state.deletedItems, isEmpty);
      expect(state.checkedItems, isEmpty);
      expect(state.archivedCheckedItems, isEmpty);
      expect(state.recycleBinCheckedItems, isEmpty);
    });

    test('should clear all states', () {
      // Set some states
      state.selectedPriority = 'high';
      state.selectedStatus = 'in progress';
      state.searchQuery = 'test';
      state.selectedDateRange = DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(days: 1)),
      );

      // Clear states
      state.clearAllStates();

      // Verify all states are cleared
      expect(state.selectedPriority, isNull);
      expect(state.selectedStatus, isNull);
      expect(state.selectedNameSort, isNull);
      expect(state.selectedStartDateSort, isNull);
      expect(state.selectedDueDateSort, isNull);
      expect(state.selectedTasksSort, isNull);
      expect(state.selectedDateRange, isNull);
      expect(state.searchQuery, isEmpty);
    });

    test('should detect active filters', () {
      expect(state.hasActiveFilters, isFalse);

      state.selectedPriority = 'high';
      expect(state.hasActiveFilters, isTrue);

      state.selectedPriority = null;
      state.searchQuery = 'test';
      expect(state.hasActiveFilters, isTrue);

      state.searchQuery = '';
      state.selectedDateRange = DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(days: 1)),
      );
      expect(state.hasActiveFilters, isTrue);
    });

    test('should manage item lists', () {
      final items = [
        MockItem(
          name: 'Item 1',
          dueDate: DateTime.now(),
          priority: 'high',
          status: 'in progress',
        ),
        MockItem(
          name: 'Item 2',
          dueDate: DateTime.now(),
          priority: 'low',
          status: 'completed',
        ),
      ];

      state.items = items;
      expect(state.items.length, equals(2));

      state.archivedItems = [items[1]];
      expect(state.archivedItems.length, equals(1));

      state.deletedItems = [items[0]];
      expect(state.deletedItems.length, equals(1));
    });

    test('should manage checked states', () {
      state.checkedItems = [true, false, true];
      expect(state.checkedItems.length, equals(3));
      expect(state.checkedItems.where((checked) => checked).length, equals(2));

      state.archivedCheckedItems = [true];
      expect(state.archivedCheckedItems.length, equals(1));

      state.recycleBinCheckedItems = [false, false];
      expect(state.recycleBinCheckedItems.length, equals(2));
      expect(state.recycleBinCheckedItems.every((checked) => !checked), isTrue);
    });

    test('should manage counter states', () {
      state.newlyDeletedCount = 2;
      expect(state.newlyDeletedCount, equals(2));

      state.newlyArchivedCount = 1;
      expect(state.newlyArchivedCount, equals(1));

      state.newlyActiveCount = 3;
      expect(state.newlyActiveCount, equals(3));
    });

    test('should manage visit states', () {
      expect(state.hasVisitedRecycleBin, isFalse);
      expect(state.hasVisitedArchived, isFalse);
      expect(state.hasVisitedActive, isFalse);

      state.hasVisitedRecycleBin = true;
      state.hasVisitedArchived = true;
      state.hasVisitedActive = true;

      expect(state.hasVisitedRecycleBin, isTrue);
      expect(state.hasVisitedArchived, isTrue);
      expect(state.hasVisitedActive, isTrue);
    });
  });
}
