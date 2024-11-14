import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/weekly_activity_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Here\'s your overview for today',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tasks Due Today',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Icon(
                                PhosphorIcons.checkSquare(
                                    PhosphorIconsStyle.bold),
                                color: AppColors.accent,
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '5',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Upcoming Exams',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Icon(
                                PhosphorIcons.graduationCap(
                                    PhosphorIconsStyle.bold),
                                color: AppColors.warning,
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '2',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Active Projects',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Icon(
                                PhosphorIcons.briefcase(
                                    PhosphorIconsStyle.bold),
                                color: AppColors.success,
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '3',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Study Hours',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Icon(
                                PhosphorIcons.clock(PhosphorIconsStyle.bold),
                                color: AppColors.info,
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '12.5',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Activity and Events Row
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: const WeeklyActivityChart(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upcoming Events',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 20),
                            _EventItem(
                              title: 'Math Exam',
                              time: 'Tomorrow, 9:00 AM',
                              color: AppColors.error,
                              icon: PhosphorIcons.exam(PhosphorIconsStyle.bold),
                            ),
                            const SizedBox(height: 16),
                            _EventItem(
                              title: 'Project Meeting',
                              time: 'Thursday, 2:30 PM',
                              color: AppColors.accent,
                              icon:
                                  PhosphorIcons.users(PhosphorIconsStyle.bold),
                            ),
                            const SizedBox(height: 16),
                            _EventItem(
                              title: 'Physics Lab',
                              time: 'Friday, 11:00 AM',
                              color: AppColors.warning,
                              icon: PhosphorIcons.atom(PhosphorIconsStyle.bold),
                            ),
                          ],
                        ),
                      ),
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
}

class _EventItem extends StatelessWidget {
  final String title;
  final String time;
  final Color color;
  final IconData icon;

  const _EventItem({
    required this.title,
    required this.time,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                time,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Icon(
          icon,
          color: color,
          size: 20,
        ),
      ],
    );
  }
}
