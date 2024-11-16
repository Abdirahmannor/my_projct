import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../lib/core/base/base_styles.dart';
import '../../lib/core/constants/app_colors.dart';

void main() {
  group('BaseStyles Tests', () {
    testWidgets('should get correct status colors', (tester) async {
      await tester.pumpWidget(const MaterialApp());

      expect(BaseStyles.getStatusColor('not started'), Colors.grey.shade400);
      expect(BaseStyles.getStatusColor('in progress'), Colors.blue.shade400);
      expect(BaseStyles.getStatusColor('on hold'), Colors.orange.shade400);
      expect(BaseStyles.getStatusColor('completed'), Colors.green.shade400);
      expect(BaseStyles.getStatusColor('unknown'), Colors.grey);
    });

    testWidgets('should get correct priority colors', (tester) async {
      await tester.pumpWidget(const MaterialApp());

      expect(BaseStyles.getPriorityColor('critical'), Colors.red.shade600);
      expect(BaseStyles.getPriorityColor('high'), Colors.red.shade400);
      expect(BaseStyles.getPriorityColor('medium'), Colors.orange.shade400);
      expect(BaseStyles.getPriorityColor('low'), Colors.green.shade400);
      expect(BaseStyles.getPriorityColor('unknown'), Colors.grey);
    });

    testWidgets('should get correct text styles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final titleStyle = BaseStyles.getTitleStyle(context);
              final hoveredTitleStyle =
                  BaseStyles.getTitleStyle(context, isHovered: true);
              final subtitleStyle = BaseStyles.getSubtitleStyle(context);

              expect(titleStyle.fontWeight, FontWeight.w600);
              expect(hoveredTitleStyle.color, AppColors.accent);
              expect(subtitleStyle.color, Theme.of(context).hintColor);

              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should get correct item decorations', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Test normal decoration
              final normalDecoration = BaseStyles.getItemDecoration(context);
              expect(normalDecoration.color, Theme.of(context).cardColor);
              expect(normalDecoration.borderRadius, BorderRadius.circular(8));

              // Test hovered decoration
              final hoveredDecoration = BaseStyles.getItemDecoration(
                context,
                isHovered: true,
              );
              expect(hoveredDecoration.boxShadow, isNotNull);

              // Test selected decoration
              final selectedDecoration = BaseStyles.getItemDecoration(
                context,
                isSelected: true,
              );
              expect(
                  selectedDecoration.color, AppColors.accent.withOpacity(0.1));

              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should get correct header decoration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final decoration = BaseStyles.getHeaderDecoration(context);

              expect(decoration.color, Theme.of(context).cardColor);
              expect(decoration.border?.bottom.color,
                  Theme.of(context).dividerColor);

              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should build progress indicator correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return BaseStyles.buildProgressIndicator(
                context,
                0.5,
                color: Colors.blue,
                size: 60,
              );
            },
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.maxWidth, 60);
      expect(container.constraints?.maxHeight, 60);

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(progressIndicator.value, 0.5);
      expect(progressIndicator.valueColor?.value, Colors.blue.withOpacity(0.9));
      expect(progressIndicator.strokeWidth, 4);
    });

    testWidgets('should handle default progress indicator values',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return BaseStyles.buildProgressIndicator(context, 0.75);
            },
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.maxWidth, 40); // Default size

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(progressIndicator.value, 0.75);
      expect(progressIndicator.valueColor?.value,
          AppColors.accent.withOpacity(0.9));
    });
  });
}
