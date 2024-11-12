import 'package:flutter/material.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String category; // 'school', 'work', 'personal'
  final Color color;
  final bool isAllDay;
  final bool isRecurring;
  final String? recurrenceRule;
  final String? location;
  final List<String>? attachments;
  final List<String>? reminders;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.category,
    required this.color,
    this.isAllDay = false,
    this.isRecurring = false,
    this.recurrenceRule,
    this.location,
    this.attachments,
    this.reminders,
  });

  // Convert to/from JSON methods
}
