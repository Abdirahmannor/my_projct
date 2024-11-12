import 'package:flutter/material.dart';

class ResourceCategory {
  final String id;
  final String name;
  final String? description;
  final IconData icon;
  final Color color;
  final List<String> resourceIds;

  ResourceCategory({
    required this.id,
    required this.name,
    this.description,
    required this.icon,
    required this.color,
    this.resourceIds = const [],
  });
}
