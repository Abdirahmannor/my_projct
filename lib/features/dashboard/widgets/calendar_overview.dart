import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CalendarOverview extends StatelessWidget {
  const CalendarOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Events',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    PhosphorIcons.calendar(PhosphorIconsStyle.bold),
                    size: 20,
                  ),
                  label: const Text('View Calendar'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _upcomingEvents.length,
              itemBuilder: (context, index) {
                final event = _upcomingEvents[index];
                return _buildEventItem(context, event);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventItem(BuildContext context, CalendarEvent event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: event.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  event.time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          ),
          Icon(
            event.icon(PhosphorIconsStyle.bold),
            color: event.color,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class CalendarEvent {
  final String title;
  final String time;
  final PhosphorIconData Function(PhosphorIconsStyle) icon;
  final Color color;

  const CalendarEvent({
    required this.title,
    required this.time,
    required this.icon,
    required this.color,
  });
}

final List<CalendarEvent> _upcomingEvents = [
  CalendarEvent(
    title: 'Math Exam',
    time: 'Tomorrow, 9:00 AM',
    icon: PhosphorIcons.exam,
    color: Colors.red,
  ),
  CalendarEvent(
    title: 'Project Meeting',
    time: 'Thursday, 2:30 PM',
    icon: PhosphorIcons.users,
    color: Colors.blue,
  ),
  CalendarEvent(
    title: 'Physics Lab',
    time: 'Friday, 11:00 AM',
    icon: PhosphorIcons.atom,
    color: Colors.purple,
  ),
];
