import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.7),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Schedule',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Row(
                children: [
                  _buildFilterChip(context, 'School', true),
                  const SizedBox(width: 8),
                  _buildFilterChip(context, 'Work', true),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: _buildWeekView(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isActive) {
    return FilterChip(
      selected: isActive,
      label: Text(label),
      onSelected: (bool value) {},
      backgroundColor: Colors.transparent,
      selectedColor: AppColors.accent.withOpacity(0.1),
      labelStyle: TextStyle(
        color: isActive ? AppColors.accent : Colors.grey,
      ),
      side: BorderSide(
        color: isActive ? AppColors.accent : Colors.grey,
      ),
    );
  }

  Widget _buildWeekView(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            SizedBox(width: 60),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Mon'),
                  Text('Tue'),
                  Text('Wed'),
                  Text('Thu'),
                  Text('Fri'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: 12, // 8:00 - 20:00
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
          width: 60,
          child: Text(
            '$hour:00',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Expanded(
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
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
                          color: Colors.grey.withOpacity(0.2),
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
