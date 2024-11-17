import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../constants/app_colors.dart';

class BaseConstants {
  // Priority levels with their display colors
  static const Map<String, String> priorities = {
    'high': 'red',
    'medium': 'orange',
    'low': 'green',
  };

  // Status options with their display colors
  static const Map<String, String> statuses = {
    'not started': 'grey',
    'in progress': 'blue',
    'on hold': 'orange',
    'completed': 'green',
  };

  // View modes
  static const String listView = 'list';
  static const String gridView = 'grid';

  // Filter constants
  static const String allFilter = 'all';
  static const String activeFilter = 'active';
  static const String archivedFilter = 'archived';
  static const String recycleBinFilter = 'recycle_bin';

  // Sort directions
  static const String ascending = 'asc';
  static const String descending = 'desc';

  // Sort types
  static const String nameSort = 'name';
  static const String dateSort = 'date';
  static const String prioritySort = 'priority';
  static const String statusSort = 'status';

  // Layout constants
  static const double defaultPadding = 16.0;
  static const double defaultSpacing = 8.0;
  static const double defaultBorderRadius = 8.0;
  static const double defaultIconSize = 24.0;
}
