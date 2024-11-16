import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../../lib/core/base/base_grid_item.dart';
import '../../../lib/core/base/base_item.dart';

// Create a mock item for testing
class MockItem extends BaseItem {
  MockItem({
    required String name,
    required DateTime dueDate,
    required String priority,
    required String status,
    bool? isPinned,
  }) : super(
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

// Create a mock implementation of BaseGridItem
class MockGridItem extends BaseGridItem<MockItem> {
  const MockGridItem({
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

    testWidgets('should apply hover styles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MockGridItem(
              item: mockItem,
              isChecked: false,
              isHovered: true,
              onCheckChanged: mockOnCheckChanged,
              onEdit: mockOnEdit,
              onDelete: mockOnDelete,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.decoration, isNotNull);
    });
  });
}
