import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/weekly_activity_chart.dart';
import '../widgets/upcoming_events.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome Back!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Here\'s your overview for today',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          // Stats Row
          Row(
            children: [
              StatCard(
                title: 'Tasks Due Today',
                value: '5',
                icon: PhosphorIcons.checkSquare(PhosphorIconsStyle.bold),
                iconColor: Colors.blue,
              ),
              const SizedBox(width: 16),
              StatCard(
                title: 'Upcoming Exams',
                value: '2',
                icon: PhosphorIcons.graduationCap(PhosphorIconsStyle.bold),
                iconColor: Colors.orange,
              ),
              const SizedBox(width: 16),
              StatCard(
                title: 'Active Projects',
                value: '3',
                icon: PhosphorIcons.briefcase(PhosphorIconsStyle.bold),
                iconColor: Colors.green,
              ),
              const SizedBox(width: 16),
              StatCard(
                title: 'Study Hours',
                value: '12.5',
                icon: PhosphorIcons.clock(PhosphorIconsStyle.bold),
                iconColor: Colors.purple,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Activity and Events Row
          Expanded(
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: WeeklyActivityChart(),
                ),
                const SizedBox(width: 24),
                const Expanded(
                  child: UpcomingEvents(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
