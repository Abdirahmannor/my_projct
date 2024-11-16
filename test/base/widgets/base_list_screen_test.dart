import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../../lib/core/base/base_list_screen.dart';
import '../../../lib/core/base/base_item.dart';
import '../../../lib/core/base/base_state.dart';

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

// Create mock state for testing
class MockState extends BaseState<MockItem> {}

// Create mock implementation of BaseListScreen
class MockListScreen extends BaseListScreen<MockItem> {
  const MockListScreen({super.key});

  @override
  MockListScreenState createState() => MockListScreenState();
}

class MockListScreenState extends BaseListScreenState<MockItem> {
  @override
  Widget buildListView(List<MockItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => ListTile(
        key: Key('list_item_${items[index].name}'),
        title: Text(items[index].name),
      ),
    );
  }

  @override
  Widget buildGridView(List<MockItem> items) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => Card(
        key: Key('grid_item_${items[index].name}'),
        child: Center(child: Text(items[index].name)),
      ),
    );
  }

  @override
  Widget buildHeader() {
    return const Text('Mock Header');
  }

  @override
  Widget buildFilterBar() {
    return Row(
      children: [
        TextButton(
          onPressed: () => state.showArchived = !state.showArchived,
          child: const Text('Toggle Archive'),
        ),
        TextButton(
          onPressed: () => state.showRecycleBin = !state.showRecycleBin,
          child: const Text('Toggle Recycle Bin'),
        ),
      ],
    );
  }

  @override
  BaseState<MockItem> createState() {
    return MockState();
  }

  @override
  Future<void> loadItems() async {
    state.items = [
      MockItem(
        id: '1',
        name: 'Active Item',
        dueDate: DateTime.now(),
        priority: 'high',
        status: 'in progress',
      ),
    ];

    state.archivedItems = [
      MockItem(
        id: '2',
        name: 'Archived Item',
        dueDate: DateTime.now(),
        priority: 'low',
        status: 'completed',
      ),
    ];

    state.deletedItems = [
      MockItem(
        id: '3',
        name: 'Deleted Item',
        dueDate: DateTime.now(),
        priority: 'medium',
        status: 'on hold',
      ),
    ];
  }
}

void main() {
  group('BaseListScreen Tests', () {
    testWidgets('should render initial view correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MockListScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mock Header'), findsOneWidget);
      expect(find.text('Active Item'), findsOneWidget);
      expect(find.text('Archived Item'), findsNothing);
      expect(find.text('Deleted Item'), findsNothing);
    });

    testWidgets('should toggle between views', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MockListScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Switch to archived view
      await tester.tap(find.text('Toggle Archive'));
      await tester.pumpAndSettle();

      expect(find.text('Active Item'), findsNothing);
      expect(find.text('Archived Item'), findsOneWidget);

      // Switch to recycle bin view
      await tester.tap(find.text('Toggle Recycle Bin'));
      await tester.pumpAndSettle();

      expect(find.text('Archived Item'), findsNothing);
      expect(find.text('Deleted Item'), findsOneWidget);
    });

    testWidgets('should toggle between list and grid views', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MockListScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final state =
          tester.state<MockListScreenState>(find.byType(MockListScreen));

      // Initially in list view
      expect(find.byKey(const Key('list_item_Active Item')), findsOneWidget);
      expect(find.byKey(const Key('grid_item_Active Item')), findsNothing);

      // Toggle to grid view
      state.viewManager.toggleView();
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('list_item_Active Item')), findsNothing);
      expect(find.byKey(const Key('grid_item_Active Item')), findsOneWidget);
    });

    testWidgets('should filter items', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MockListScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final state =
          tester.state<MockListScreenState>(find.byType(MockListScreen));

      // Apply filter
      state.state.selectedPriority = 'high';
      state.setState(() {});
      await tester.pumpAndSettle();

      expect(find.text('Active Item'), findsOneWidget); // high priority
      expect(find.text('Archived Item'), findsNothing); // low priority
    });

    testWidgets('should handle search', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MockListScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final state =
          tester.state<MockListScreenState>(find.byType(MockListScreen));

      // Search for "Active"
      state.state.searchQuery = 'Active';
      state.setState(() {});
      await tester.pumpAndSettle();

      expect(find.text('Active Item'), findsOneWidget);
      expect(find.text('Archived Item'), findsNothing);
    });

    testWidgets('should maintain state during rebuilds', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MockListScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final state =
          tester.state<MockListScreenState>(find.byType(MockListScreen));

      // Change some state
      state.state.selectedPriority = 'high';
      state.viewManager.toggleView();
      state.setState(() {});
      await tester.pumpAndSettle();

      // Rebuild widget
      await tester.pumpWidget(
        const MaterialApp(
          home: MockListScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify state is maintained
      expect(state.state.selectedPriority, 'high');
      expect(state.viewManager.isListView, false);
    });
  });
}
