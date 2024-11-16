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
            body: StatefulBuilder(
              builder: (context, setState) {
                return viewManager.buildView(
                  listView: Container(
                    key: const Key('list_view'),
                    child: const Text('List View'),
                  ),
                  gridView: Container(
                    key: const Key('grid_view'),
                    child: const Text('Grid View'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Initially should show list view
      expect(find.byKey(const Key('list_view')), findsOneWidget);
      expect(find.text('List View'), findsOneWidget);
      expect(find.byKey(const Key('grid_view')), findsNothing);

      // Toggle to grid view
      viewManager.toggleView();
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('grid_view')), findsOneWidget);
      expect(find.text('Grid View'), findsOneWidget);
      expect(find.byKey(const Key('list_view')), findsNothing);
    });

    testWidgets('should animate view transitions', (tester) async {
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

      // Start transition
      viewManager.toggleView();
      await tester.pump();

      // Verify animation is running
      final animation = tester.widget<FadeTransition>(
        find.byType(FadeTransition),
      );
      expect(animation.opacity.value, isNot(1.0));

      // Complete transition
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('grid_view')), findsOneWidget);
    });

    testWidgets('should maintain state during rebuilds', (tester) async {
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

      // Switch to grid view
      viewManager.toggleView();
      await tester.pumpAndSettle();

      // Rebuild widget
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
      await tester.pumpAndSettle();

      // Should still be in grid view
      expect(find.byKey(const Key('grid_view')), findsOneWidget);
    });

    test('should notify listeners of view changes', () {
      bool notified = false;
      viewManager.addListener(() => notified = true);

      viewManager.toggleView();
      expect(notified, isTrue);
    });

    test('should properly dispose listeners', () {
      bool notified = false;
      void listener() => notified = true;

      viewManager.addListener(listener);
      viewManager.removeListener(listener);

      viewManager.toggleView();
      expect(notified, isFalse);
    });
  });
}
