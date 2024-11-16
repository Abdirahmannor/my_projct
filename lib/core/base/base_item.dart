import 'package:flutter/material.dart';

abstract class BaseItem {
  final String? id;
  final String name;
  final String? description;
  final DateTime dueDate;
  final String priority;
  final String status;
  final bool? isPinned;
  final DateTime? deletedAt;
  final DateTime? lastRestoredDate;

  BaseItem({
    this.id,
    required this.name,
    this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    this.isPinned,
    this.deletedAt,
    this.lastRestoredDate,
  });

  // Abstract method that must be implemented by subclasses
  BaseItem copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? dueDate,
    String? priority,
    String? status,
    bool? isPinned,
    DateTime? deletedAt,
    DateTime? lastRestoredDate,
  });

  Map<String, dynamic> toMap();
}
