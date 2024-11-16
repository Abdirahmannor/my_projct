import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../../lib/core/base/base_list_screen.dart';
import '../../../lib/core/base/base_item.dart';
import '../../../lib/core/base/base_state.dart';

// Create a mock item for testing
class MockItem extends BaseItem {
  MockItem({
    required String name,
    required DateTime dueDate,
    required String priority,
    required String status,
  }) : super(
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
      name: name ?? this.name,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

// Add this class at the top of the file, after MockItem
class MockState<T extends BaseItem> extends BaseState<T> {
  @override
  void clearAllStates() {
    super.clearAllStates();
  }

  @override
  bool get hasActiveFilters => super.hasActiveFilters;
}

// Create a mock implementation of BaseListScreen
class MockListScreen extends BaseListScreen<MockItem> {
  const MockListScreen({super.key});

  @override
  BaseListScreenState<MockItem> createState() => MockListScreenState();
}

class MockListScreenState extends BaseListScreenState<MockItem> {
  @override
  Widget buildListView(List<MockItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => Text(items[index].name),
    );
  }

  @override
  Widget buildGridView(List<MockItem> items) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => Text(items[index].name),
    );
  }

  @override
  Widget buildHeader() {
    return const Text('Mock Header');
  }

  @override
  Widget buildFilterBar() {
    return const Text('Mock Filter Bar');
  }

  @override
  BaseState<MockItem> createState() {
    return MockState<MockItem>();
  }

  @override
  Future<void> loadItems() async {
    state.items = [
      MockItem(
        name: 'Test Item 1',
        dueDate: DateTime.now(),
        priority: 'high',
        status: 'in progress',
      ),
      MockItem(
        name: 'Test Item 2',
        dueDate: DateTime.now(),
        priority: 'low',
        status: 'completed',
      ),
    ];
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Add any setup needed before each test
  });

  tearDown(() {
    // Add any cleanup needed after each test
  });

  group('BaseListScreen Tests', () {
    testWidgets('should render all components', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MockListScreen(),
        ),
      );
      await tester.pump();

      expect(find.text('Mock Header'), findsOneWidget);
      expect(find.text('Mock Filter Bar'), findsOneWidget);
      expect(find.text('Test Item 1'), findsOneWidget);
      expect(find.text('Test Item 2'), findsOneWidget);
    });

    testWidgets('should filter items correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MockListScreen(),
        ),
      );
      await tester.pump();

      final state =
          tester.state<MockListScreenState>(find.byType(MockListScreen));

      // Test search filter
      state.state.searchQuery = 'Item 1';
      state.setState(() {});
      await tester.pump();

      expect(find.text('Test Item 1'), findsOneWidget);
      expect(find.text('Test Item 2'), findsNothing);

      // Test priority filter
      state.state.searchQuery = '';
      state.state.selectedPriority = 'high';
      state.setState(() {});
      await tester.pump();

      expect(find.text('Test Item 1'), findsOneWidget);
      expect(find.text('Test Item 2'), findsNothing);
    });

    testWidgets('should toggle between list and grid view', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MockListScreen(),
        ),
      );
      await tester.pump();

      final state =
          tester.state<MockListScreenState>(find.byType(MockListScreen));

      // Toggle to grid view
      state.viewManager.toggleView();
      await tester.pump();

      // Verify layout changes (you might need to add specific keys or other identifiers
      // to verify the layout type)
    });

    testWidgets('should handle state transitions correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MockListScreen(),
        ),
      );
      await tester.pump();

      final state =
          tester.state<MockListScreenState>(find.byType(MockListScreen));

      // Test archive transition
      state.state.showArchived = true;
      state.setState(() {});
      await tester.pump();

      // Test recycle bin transition
      state.state.showArchived = false;
      state.state.showRecycleBin = true;
      state.setState(() {});
      await tester.pump();
    });

    testWidgets('should handle multiple filters simultaneously',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MockListScreen(),
        ),
      );
      await tester.pump();

      final state =
          tester.state<MockListScreenState>(find.byType(MockListScreen));

      // Apply multiple filters
      state.state.searchQuery = 'Item';
      state.state.selectedPriority = 'high';
      state.state.selectedStatus = 'in progress';
      state.setState(() {});
      await tester.pump();

      expect(find.text('Test Item 1'), findsOneWidget);
      expect(find.text('Test Item 2'), findsNothing);
    });

    testWidgets('should handle sorting', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MockListScreen(),
        ),
      );
      await tester.pump();

      final state =
          tester.state<MockListScreenState>(find.byType(MockListScreen));

      // Test name sorting
      state.state.selectedNameSort = 'asc';
      state.setState(() {});
      await tester.pump();

      // Test date sorting
      state.state.selectedNameSort = null;
      state.state.selectedStartDateSort = 'desc';
      state.setState(() {});
      await tester.pump();
    });

    testWidgets('should handle view mode changes with data updates',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MockListScreen(),
        ),
      );
      await tester.pump();

      final state =
          tester.state<MockListScreenState>(find.byType(MockListScreen));

      // Toggle view and update data
      state.viewManager.toggleView();
      state.setState(() {
        state.state.items = [
          MockItem(
            name: 'New Item',
            dueDate: DateTime.now(),
            priority: 'medium',
            status: 'not started',
          ),
        ];
      });
      await tester.pump();

      expect(find.text('New Item'), findsOneWidget);
    });

    testWidgets('should maintain state during rebuilds', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MockListScreen(),
        ),
      );
      await tester.pump();

      final state =
          tester.state<MockListScreenState>(find.byType(MockListScreen));

      // Set some state
      state.state.selectedPriority = 'high';
      state.state.searchQuery = 'Test';
      state.setState(() {});

      // Trigger rebuild
      await tester.pumpWidget(
        const MaterialApp(
          home: MockListScreen(),
        ),
      );
      await tester.pump();

      // Verify state is maintained
      expect(state.state.selectedPriority, 'high');
      expect(state.state.searchQuery, 'Test');
    });
  });
}
