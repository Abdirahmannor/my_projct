import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../constants/app_colors.dart';

class BaseConstants {
  // Priority options
  static const Map<String, String> priorities = {
    'critical': 'Critical',
    'high': 'High',
    'medium': 'Medium',
    'low': 'Low',
  };

  // Status options
  static const Map<String, String> statuses = {
    'not started': 'Not Started',
    'in progress': 'In Progress',
    'on hold': 'On Hold',
    'completed': 'Completed',
  };

  // Priority colors and icons
  static final Map<String, (Color, IconData)> priorityInfo = {
    'critical': (
      Colors.red.shade600,
      PhosphorIcons.warning(PhosphorIconsStyle.fill)
    ),
    'high': (
      Colors.red.shade400,
      PhosphorIcons.arrowUp(PhosphorIconsStyle.fill)
    ),
    'medium': (
      Colors.orange.shade400,
      PhosphorIcons.minus(PhosphorIconsStyle.fill)
    ),
    'low': (
      Colors.green.shade400,
      PhosphorIcons.arrowDown(PhosphorIconsStyle.fill)
    ),
  };

  // Status colors and icons
  static final Map<String, (Color, IconData)> statusInfo = {
    'not started': (
      Colors.grey.shade400,
      PhosphorIcons.pause(PhosphorIconsStyle.fill)
    ),
    'in progress': (
      Colors.blue.shade400,
      PhosphorIcons.play(PhosphorIconsStyle.fill)
    ),
    'on hold': (
      Colors.orange.shade400,
      PhosphorIcons.clock(PhosphorIconsStyle.fill)
    ),
    'completed': (
      Colors.green.shade400,
      PhosphorIcons.check(PhosphorIconsStyle.fill)
    ),
  };

  // Category colors and icons
  static final Map<String, (Color, IconData)> categoryInfo = {
    'school': (
      AppColors.accent,
      PhosphorIcons.graduationCap(PhosphorIconsStyle.fill)
    ),
    'personal': (
      Colors.purple.shade400,
      PhosphorIcons.user(PhosphorIconsStyle.fill)
    ),
    'work': (
      Colors.blue.shade400,
      PhosphorIcons.briefcase(PhosphorIconsStyle.fill)
    ),
    'online work': (
      Colors.green.shade400,
      PhosphorIcons.globe(PhosphorIconsStyle.fill)
    ),
    'other': (
      Colors.grey.shade400,
      PhosphorIcons.folder(PhosphorIconsStyle.fill)
    ),
  };

  // Sort options
  static const Map<String, String> sortOptions = {
    'name_asc': 'Name (A-Z)',
    'name_desc': 'Name (Z-A)',
    'date_asc': 'Date (Oldest)',
    'date_desc': 'Date (Newest)',
    'priority_asc': 'Priority (Low-High)',
    'priority_desc': 'Priority (High-Low)',
  };

  // Filter options
  static const Map<String, String> filterOptions = {
    'all': 'All Items',
    'active': 'Active',
    'archived': 'Archived',
    'deleted': 'Recycle Bin',
  };
}
