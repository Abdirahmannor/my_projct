import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../constants/app_colors.dart';

class BaseFormFields {
  static Widget buildDatePicker({
    required BuildContext context,
    required String label,
    required DateTime? value,
    required IconData icon,
    required ValueChanged<DateTime?> onChanged,
    required GlobalKey<FormState> formKey,
  }) {
    final bool hasError =
        formKey.currentState?.validate() == false && value == null;

    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          onChanged(date);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: hasError ? Colors.red : Theme.of(context).dividerColor,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: hasError ? Colors.red : null),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: hasError ? Colors.red : null,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value == null ? 'Select date' : _formatDate(value),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: hasError ? Colors.red : null,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildCompactSelector<T>({
    required BuildContext context,
    required String title,
    required Map<T, (Color, IconData?)> options,
    required T value,
    required ValueChanged<T> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: options.entries.map((entry) {
              final isSelected = value == entry.key;
              final (color, icon) = entry.value;

              return InkWell(
                onTap: () => onChanged(entry.key),
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.1) : null,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 14, color: isSelected ? color : null),
                        const SizedBox(width: 8),
                      ] else ...[
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        entry.key.toString().toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected ? color : null,
                          fontWeight: isSelected ? FontWeight.w600 : null,
                        ),
                      ),
                      const Spacer(),
                      if (isSelected)
                        Icon(
                          PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                          size: 14,
                          color: color,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  static String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}
