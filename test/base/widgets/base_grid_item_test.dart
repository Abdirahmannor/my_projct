import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../../lib/core/base/base_grid_item.dart';
import '../../../lib/core/base/base_item.dart';

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

// Create mock implementation of BaseGridItem
class MockGridItem extends BaseGridItem<MockItem> {
  const MockGridItem({
    super.key,
    required super.item,
    required super.isChecked,
    required super.isHovered,
    required super.onCheckChanged,
    required super.onEdit,
    required super.onDelete,
    super.onRestore,
  });

  @override
  Widget buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.name),
        buildPriorityIndicator(),
        buildStatusIndicator(),
      ],
    );
  }

  @override
  Widget buildFooter(BuildContext context) {
    return buildActions(context);
  }
}

void main() {
  group('BaseGridItem Tests', () {
    late MockItem mockItem;
    late VoidCallback mockOnEdit;
    late VoidCallback mockOnDelete;
    late Function(bool?) mockOnCheckChanged;

    setUp(() {
      mockItem = MockItem(
        id: '1',
        name: 'Test Item',
        dueDate: DateTime.now(),
        priority: 'high',
        status: 'in progress',
        isPinned: false,
      );
      mockOnEdit = () {};
      mockOnDelete = () {};
      mockOnCheckChanged = (_) {};
    });

    testWidgets('should render basic item content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MockGridItem(
              item: mockItem,
              isChecked: false,
              isHovered: false,
              onCheckChanged: mockOnCheckChanged,
              onEdit: mockOnEdit,
              onDelete: mockOnDelete,
            ),
          ),
        ),
      );

      expect(find.text('Test Item'), findsOneWidget);
      expect(find.text('High'), findsOneWidget);
      expect(find.text('In Progress'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('should show pin indicator when item is pinned',
        (tester) async {
      final pinnedItem = mockItem.copyWith(isPinned: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MockGridItem(
              item: pinnedItem,
              isChecked: false,
              isHovered: false,
              onCheckChanged: mockOnCheckChanged,
              onEdit: mockOnEdit,
              onDelete: mockOnDelete,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.push_pin), findsOneWidget);
    });

    testWidgets('should handle checkbox changes', (tester) async {
      bool? checkValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MockGridItem(
              item: mockItem,
              isChecked: false,
              isHovered: false,
              onCheckChanged: (value) => checkValue = value,
              onEdit: mockOnEdit,
              onDelete: mockOnDelete,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      expect(checkValue, isTrue);
    });

    testWidgets(
        'should show restore button instead of edit/delete when provided',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MockGridItem(
              item: mockItem,
              isChecked: false,
              isHovered: false,
              onCheckChanged: mockOnCheckChanged,
              onEdit: mockOnEdit,
              onDelete: mockOnDelete,
              onRestore: () {},
            ),
          ),
        ),
      );

      expect(find.byTooltip('Restore'), findsOneWidget);
      expect(find.byTooltip('Edit'), findsNothing);
      expect(find.byTooltip('Delete'), findsNothing);
    });

    testWidgets('should apply hover styles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MouseRegion(
              child: MockGridItem(
                item: mockItem,
                isChecked: false,
                isHovered: true,
                onCheckChanged: mockOnCheckChanged,
                onEdit: mockOnEdit,
                onDelete: mockOnDelete,
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.decoration, isNotNull);
    });

    testWidgets('should handle edit action', (tester) async {
      bool editCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MockGridItem(
              item: mockItem,
              isChecked: false,
              isHovered: false,
              onCheckChanged: mockOnCheckChanged,
              onEdit: () => editCalled = true,
              onDelete: mockOnDelete,
            ),
          ),
        ),
      );

      await tester.tap(find.byTooltip('Edit'));
      expect(editCalled, isTrue);
    });

    testWidgets('should handle delete action', (tester) async {
      bool deleteCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MockGridItem(
              item: mockItem,
              isChecked: false,
              isHovered: false,
              onCheckChanged: mockOnCheckChanged,
              onEdit: mockOnEdit,
              onDelete: () => deleteCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byTooltip('Delete'));
      expect(deleteCalled, isTrue);
    });
  });
}
