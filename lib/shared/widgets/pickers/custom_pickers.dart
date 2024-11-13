import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomDateTimePicker extends StatelessWidget {
  final bool isTimePicker;
  final DateTime? initialDate;
  final TimeOfDay? initialTime;
  final Function(DateTime?) onDateSelected;
  final Function(TimeOfDay?)? onTimeSelected;

  const CustomDateTimePicker({
    super.key,
    this.isTimePicker = false,
    this.initialDate,
    this.initialTime,
    required this.onDateSelected,
    this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        datePickerTheme: DatePickerThemeData(
          backgroundColor: Theme.of(context).cardColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        timePickerTheme: TimePickerThemeData(
          backgroundColor: Theme.of(context).cardColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          hourMinuteShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      child: Builder(
        builder: (context) {
          if (isTimePicker) {
            return TimePickerDialog(
              initialTime: initialTime ?? TimeOfDay.now(),
              cancelText: 'Cancel',
              confirmText: 'OK',
              helpText: 'Select time',
              initialEntryMode: TimePickerEntryMode.dial,
            );
          }
          return DatePickerDialog(
            initialDate: initialDate ?? DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            cancelText: 'Cancel',
            confirmText: 'OK',
            helpText: 'Select date',
          );
        },
      ),
    );
  }
}
