import 'package:flutter/material.dart';

class BaseViewManager extends ChangeNotifier {
  bool _isListView = true;
  bool get isListView => _isListView;

  void toggleView() {
    _isListView = !_isListView;
    notifyListeners();
  }

  Widget buildView({
    required Widget listView,
    required Widget gridView,
  }) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _isListView ? listView : gridView,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
