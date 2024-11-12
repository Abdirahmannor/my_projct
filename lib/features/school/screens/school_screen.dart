import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../widgets/schedule_view.dart';
import '../../dashboard/widgets/stat_card.dart';

class SchoolScreen extends StatelessWidget {
  const SchoolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.7),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'School Overview',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Manage your academic activities',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Stats Row
            Row(
              children: [
                StatCard(
                  title: 'Current GPA',
                  value: '3.8',
                  icon: PhosphorIcons.chartLineUp(PhosphorIconsStyle.bold),
                  iconColor: Colors.green,
                ),
                const SizedBox(width: 16),
                StatCard(
                  title: 'Assignments Due',
                  value: '4',
                  icon: PhosphorIcons.fileText(PhosphorIconsStyle.bold),
                  iconColor: Colors.orange,
                ),
                const SizedBox(width: 16),
                StatCard(
                  title: 'Study Hours',
                  value: '12.5',
                  icon: PhosphorIcons.clock(PhosphorIconsStyle.bold),
                  iconColor: Colors.blue,
                ),
                const SizedBox(width: 16),
                StatCard(
                  title: 'Courses',
                  value: '6',
                  icon: PhosphorIcons.books(PhosphorIconsStyle.bold),
                  iconColor: Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Schedule and Activity Row
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.7),
                    width: 2,
                  ),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ScheduleView(),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: _ExamsList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExamsList extends StatelessWidget {
  const _ExamsList();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Exams',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildExamItem(
                  context,
                  subject: 'Mathematics',
                  date: 'Tomorrow, 9:00 AM',
                  topic: 'Calculus II',
                ),
                _buildExamItem(
                  context,
                  subject: 'Physics',
                  date: 'Friday, 11:00 AM',
                  topic: 'Quantum Mechanics',
                ),
                // Add more exam items
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamItem(
    BuildContext context, {
    required String subject,
    required String date,
    required String topic,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            topic,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                PhosphorIcons.clock(PhosphorIconsStyle.bold),
                size: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              const SizedBox(width: 8),
              Text(
                date,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
