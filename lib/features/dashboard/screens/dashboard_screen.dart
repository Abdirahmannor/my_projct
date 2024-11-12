import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/activity_chart.dart';
import '../widgets/recent_activities.dart';
import '../widgets/calendar_overview.dart';
import '../../../shared/widgets/animations/animated_entry.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AnimatedEntry(
              child: DashboardHeader(),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                AnimatedEntry(
                  delay: 1,
                  child: StatCard(
                    title: 'Tasks Due Today',
                    value: '5',
                    icon: PhosphorIcons.checkSquare,
                    color: Colors.blue,
                  ),
                ),
                AnimatedEntry(
                  delay: 2,
                  child: StatCard(
                    title: 'Upcoming Exams',
                    value: '2',
                    icon: PhosphorIcons.graduationCap,
                    color: Colors.orange,
                  ),
                ),
                AnimatedEntry(
                  delay: 3,
                  child: StatCard(
                    title: 'Active Projects',
                    value: '3',
                    icon: PhosphorIcons.briefcase,
                    color: Colors.green,
                  ),
                ),
                AnimatedEntry(
                  delay: 4,
                  child: StatCard(
                    title: 'Study Hours',
                    value: '12.5',
                    icon: PhosphorIcons.clock,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: AnimatedEntry(
                    delay: 5,
                    child: ActivityChart(),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: AnimatedEntry(
                    delay: 6,
                    child: CalendarOverview(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AnimatedEntry(
              delay: 7,
              child: RecentActivities(),
            ),
          ],
        ),
      ),
    );
  }
}
