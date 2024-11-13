import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../widgets/schedule_view.dart';
import '../../dashboard/widgets/stat_card.dart';
import '../../../core/constants/app_colors.dart';

class SchoolScreen extends StatelessWidget {
  const SchoolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Average Grade',
                    value: '2.3',
                    icon: PhosphorIcons.student(PhosphorIconsStyle.bold),
                    iconColor: AppColors.success,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: 'Upcoming Exams',
                    value: '3',
                    icon: PhosphorIcons.exam(PhosphorIconsStyle.bold),
                    iconColor: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: 'Assignments Due',
                    value: '5',
                    icon: PhosphorIcons.notepad(PhosphorIconsStyle.bold),
                    iconColor: AppColors.error,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: 'Study Hours',
                    value: '12.5',
                    icon: PhosphorIcons.clock(PhosphorIconsStyle.bold),
                    iconColor: AppColors.info,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 2,
                    child: ScheduleView(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upcoming Exams',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontSize: 16,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: _ExamsList(),
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

class _ExamsList extends StatelessWidget {
  const _ExamsList();

  @override
  Widget build(BuildContext context) {
    return ListView(
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
        _buildExamItem(
          context,
          subject: 'Computer Science',
          date: 'Next Monday, 2:00 PM',
          topic: 'Data Structures',
        ),
      ],
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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
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
