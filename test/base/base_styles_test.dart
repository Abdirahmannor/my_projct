import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../lib/core/base/base_styles.dart';
import '../../lib/core/constants/app_colors.dart';

void main() {
  group('BaseStyles Tests', () {
    group('Status Colors', () {
      test('should return correct colors for different statuses', () {
        expect(BaseStyles.getStatusColor('not started'), Colors.grey.shade400);
        expect(BaseStyles.getStatusColor('in progress'), Colors.blue.shade400);
        expect(BaseStyles.getStatusColor('on hold'), Colors.orange.shade400);
        expect(BaseStyles.getStatusColor('completed'), Colors.green.shade400);
      });

      test('should return default color for unknown status', () {
        expect(BaseStyles.getStatusColor('unknown'), Colors.grey);
      });
    });

    group('Priority Colors', () {
      test('should return correct colors for different priorities', () {
        expect(BaseStyles.getPriorityColor('critical'), Colors.red.shade600);
        expect(BaseStyles.getPriorityColor('high'), Colors.red.shade400);
        expect(BaseStyles.getPriorityColor('medium'), Colors.orange.shade400);
        expect(BaseStyles.getPriorityColor('low'), Colors.green.shade400);
      });

      test('should return default color for unknown priority', () {
        expect(BaseStyles.getPriorityColor('unknown'), Colors.grey);
      });
    });

    testWidgets('Text Styles', (tester) async {
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

    testWidgets('Item Decoration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final normalDecoration = BaseStyles.getItemDecoration(context);
              final hoveredDecoration =
                  BaseStyles.getItemDecoration(context, isHovered: true);
              final selectedDecoration =
                  BaseStyles.getItemDecoration(context, isSelected: true);

              expect(normalDecoration.color, Theme.of(context).cardColor);
              expect(hoveredDecoration.boxShadow, isNotNull);
              expect(
                  selectedDecoration.color, AppColors.accent.withOpacity(0.1));
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('Header Decoration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final headerDecoration = BaseStyles.getHeaderDecoration(context);

              expect(headerDecoration.color, Theme.of(context).cardColor);
              expect(headerDecoration.border, isNotNull);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('Progress Indicator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return BaseStyles.buildProgressIndicator(context, 0.5);
            },
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      expect(progressIndicator.value, 0.5);
      expect(progressIndicator.valueColor?.value,
          AppColors.accent.withOpacity(0.9));
    });
  });
}
