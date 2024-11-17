import 'package:flutter/material.dart';

class BaseLayout {
  // Common layout constants
  static const double checkboxWidth = 24.0;
  static const double iconSpacing = 16.0;
  static const int nameColumnFlex = 3;
  static const int dateColumnFlex = 2;
  static const double tasksWidth = 100.0;
  static const double priorityWidth = 100.0;
  static const double statusWidth = 100.0;
  static const double actionsWidth = 100.0;
  static const double columnPadding = 12.0;
  static const double rowHorizontalPadding = 16.0;
  static const double rowVerticalPadding = 12.0;

  // Common margins and paddings
  static const EdgeInsets contentPadding = EdgeInsets.all(24.0);
  static const EdgeInsets headerPadding = EdgeInsets.fromLTRB(24, 16, 24, 12);
  static const EdgeInsets itemPadding = EdgeInsets.all(12.0);

  // Common border radius values
  static final BorderRadius containerRadius = BorderRadius.circular(12.0);
  static final BorderRadius itemRadius = BorderRadius.circular(8.0);

  // Common decoration builders
  static BoxDecoration buildContainerDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: containerRadius,
      border: Border.all(
        color: Theme.of(context).dividerColor,
        width: 1,
      ),
    );
  }

  static BoxDecoration buildHoverDecoration(
      BuildContext context, bool isHovered) {
    return BoxDecoration(
      color: isHovered
          ? Theme.of(context).hoverColor
          : Theme.of(context).cardColor,
      borderRadius: itemRadius,
      border: Border.all(
        color: Theme.of(context).dividerColor,
        width: 1,
      ),
      boxShadow: isHovered
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    );
  }
}
