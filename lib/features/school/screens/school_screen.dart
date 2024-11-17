import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../shared/widgets/animations/animated_entry.dart';
import '../widgets/schedule_view.dart';
import '../widgets/subject_list.dart';
import '../widgets/exam_timeline.dart';

class SchoolScreen extends StatelessWidget {
  const SchoolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedEntry(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'School & Work',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Manage your dual education schedule',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      PhosphorIcons.plus(PhosphorIconsStyle.bold),
                      size: 20,
                    ),
                    label: const Text('Add Entry'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: AnimatedEntry(
                    delay: 1,
                    child: ScheduleView(),
                  ),
                ),
                SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      AnimatedEntry(
                        delay: 2,
                        child: SubjectList(),
                      ),
                      SizedBox(height: 24),
                      AnimatedEntry(
                        delay: 3,
                        child: ExamTimeline(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
