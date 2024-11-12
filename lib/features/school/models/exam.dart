import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Exam {
  final String id;
  final String subject;
  final String date;
  final String time;
  final Color color;

  const Exam({
    required this.id,
    required this.subject,
    required this.date,
    required this.time,
    required this.color,
  });

  DateTime get dateTime {
    final dateFormat = DateFormat('d/M/yyyy');
    final timeFormat = DateFormat('h:mm a');

    final parsedDate = dateFormat.parse(date);
    final parsedTime = timeFormat.parse(time);

    return DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );
  }

  bool get isUpcoming => dateTime.isAfter(DateTime.now());
}
