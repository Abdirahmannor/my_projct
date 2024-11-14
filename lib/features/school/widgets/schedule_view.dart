import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Schedule',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                      ),
                ),
                Row(
                  children: [
                    _buildFilterChip(context, 'School', true),
                    const SizedBox(width: 4),
                    _buildFilterChip(context, 'Work', true),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: _buildWeekView(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color:
            isActive ? AppColors.accent.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? AppColors.accent : Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: isActive ? AppColors.accent : Theme.of(context).hintColor,
        ),
      ),
    );
  }

  Widget _buildWeekView(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 40),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Mon',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 12)),
                  Text('Tue',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 12)),
                  Text('Wed',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 12)),
                  Text('Thu',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 12)),
                  Text('Fri',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: 12,
            itemBuilder: (context, index) {
              final hour = index + 8;
              return _buildTimeSlot(context, hour);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlot(BuildContext context, int hour) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(
            '$hour:00',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                ),
          ),
        ),
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: List.generate(
                5,
                (index) => Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
