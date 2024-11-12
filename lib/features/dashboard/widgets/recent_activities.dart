import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';

class RecentActivities extends StatelessWidget {
  const RecentActivities({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activities',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildActivityItem(
                  context,
                  _demoActivities[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, ActivityItem activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: activity.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              activity.icon(PhosphorIconsStyle.bold),
              color: activity.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  activity.time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityItem {
  final String title;
  final String time;
  final PhosphorIconData Function(PhosphorIconsStyle) icon;
  final Color color;

  const ActivityItem({
    required this.title,
    required this.time,
    required this.icon,
    required this.color,
  });
}

final List<ActivityItem> _demoActivities = [
  ActivityItem(
    title: 'Math homework completed',
    time: '2 hours ago',
    icon: PhosphorIcons.checkCircle,
    color: Colors.green,
  ),
  ActivityItem(
    title: 'New project assigned',
    time: '4 hours ago',
    icon: PhosphorIcons.briefcase,
    color: Colors.blue,
  ),
  ActivityItem(
    title: 'Physics exam scheduled',
    time: '5 hours ago',
    icon: PhosphorIcons.calendar,
    color: Colors.orange,
  ),
  ActivityItem(
    title: 'Study materials added',
    time: '1 day ago',
    icon: PhosphorIcons.books,
    color: Colors.purple,
  ),
  ActivityItem(
    title: 'Weekly report generated',
    time: '1 day ago',
    icon: PhosphorIcons.chartLine,
    color: Colors.teal,
  ),
];
