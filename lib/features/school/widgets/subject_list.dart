import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';

class SubjectList extends StatelessWidget {
  const SubjectList({super.key});

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
                  'Subjects',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    PhosphorIcons.plus(PhosphorIconsStyle.bold),
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _demoSubjects.length,
              itemBuilder: (context, index) {
                final subject = _demoSubjects[index];
                return _buildSubjectItem(context, subject);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectItem(BuildContext context, Subject subject) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: subject.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            subject.icon(PhosphorIconsStyle.bold),
            color: subject.color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  'Grade: ${subject.grade}',
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

class Subject {
  final String name;
  final String grade;
  final PhosphorIconData Function(PhosphorIconsStyle) icon;
  final Color color;

  const Subject({
    required this.name,
    required this.grade,
    required this.icon,
    required this.color,
  });
}

final List<Subject> _demoSubjects = [
  const Subject(
    name: 'Mathematics',
    grade: '2.0',
    icon: PhosphorIcons.function,
    color: Colors.blue,
  ),
  const Subject(
    name: 'Physics',
    grade: '1.7',
    icon: PhosphorIcons.atom,
    color: Colors.purple,
  ),
  const Subject(
    name: 'Programming',
    grade: '1.3',
    icon: PhosphorIcons.code,
    color: Colors.green,
  ),
  const Subject(
    name: 'English',
    grade: '2.3',
    icon: PhosphorIcons.translate,
    color: Colors.orange,
  ),
];
