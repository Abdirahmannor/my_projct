import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../../lib/core/base/base_view_manager.dart';

void main() {
  group('BaseViewManager Tests', () {
    late BaseViewManager viewManager;

    setUp(() {
      viewManager = BaseViewManager();
    });

    testWidgets('should toggle between list and grid view', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: viewManager.buildView(
              listView: Container(key: const Key('list_view')),
              gridView: Container(key: const Key('grid_view')),
            ),
          ),
        ),
      );

      // Initially should show list view
      expect(find.byKey(const Key('list_view')), findsOneWidget);
      expect(find.byKey(const Key('grid_view')), findsNothing);

      // Toggle to grid view
      viewManager.toggleView();
      await tester.pump();

      expect(find.byKey(const Key('grid_view')), findsOneWidget);
      expect(find.byKey(const Key('list_view')), findsNothing);
    });

    testWidgets('should persist view preference', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: viewManager.buildView(
              listView: Container(key: const Key('list_view')),
              gridView: Container(key: const Key('grid_view')),
            ),
          ),
        ),
      );

      // Change to grid view
      viewManager.toggleView();
      await tester.pump();

      // Recreate widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: viewManager.buildView(
              listView: Container(key: const Key('list_view')),
              gridView: Container(key: const Key('grid_view')),
            ),
          ),
        ),
      );

      // Should still be in grid view
      expect(find.byKey(const Key('grid_view')), findsOneWidget);
      expect(find.byKey(const Key('list_view')), findsNothing);
    });

    testWidgets('should render list view correctly', (tester) async {
      final listView = ListView(
        children: const [
          Text('Item 1'),
          Text('Item 2'),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: viewManager.buildView(
              listView: listView,
              gridView: Container(),
            ),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('should render grid view correctly', (tester) async {
      final gridView = GridView.count(
        crossAxisCount: 2,
        children: const [
          Text('Grid Item 1'),
          Text('Grid Item 2'),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: viewManager.buildView(
              listView: Container(),
              gridView: gridView,
            ),
          ),
        ),
      );

      viewManager.toggleView(); // Switch to grid view
      await tester.pump();

      expect(find.text('Grid Item 1'), findsOneWidget);
      expect(find.text('Grid Item 2'), findsOneWidget);
    });

    test('should manage view state properly', () {
      expect(viewManager.isListView, true); // Default to list view

      viewManager.toggleView();
      expect(viewManager.isListView, false);

      viewManager.toggleView();
      expect(viewManager.isListView, true);
    });
  });
}
