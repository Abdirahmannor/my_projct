import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../models/exam.dart';
import '../providers/exam_provider.dart';
import 'exam_form_dialog.dart';

class ExamTimeline extends StatefulWidget {
  const ExamTimeline({super.key});

  @override
  State<ExamTimeline> createState() => _ExamTimelineState();
}

class _ExamTimelineState extends State<ExamTimeline> {
  @override
  void initState() {
    super.initState();
    // Load exams when widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExamProvider>().loadExams();
    });
  }

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
                  'Upcoming Exams',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () => _showAddExamDialog(context),
                  icon: Icon(
                    PhosphorIcons.plus(PhosphorIconsStyle.bold),
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Consumer<ExamProvider>(
              builder: (context, examProvider, child) {
                if (examProvider.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final exams = examProvider.upcomingExams;
                if (exams.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'No upcoming exams',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: exams.length,
                  itemBuilder: (context, index) {
                    final exam = exams[index];
                    return Dismissible(
                      key: Key(exam.subject + exam.date + exam.time),
                      background: Container(
                        color: Colors.red.withOpacity(0.2),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(
                          PhosphorIcons.trash(PhosphorIconsStyle.bold),
                          color: Colors.red,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        examProvider.removeExam(exam);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${exam.subject} exam removed'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                examProvider.addExam(exam);
                              },
                            ),
                          ),
                        );
                      },
                      child: InkWell(
                        onTap: () => _showEditExamDialog(context, exam),
                        child: _buildExamItem(
                            context, exam, index == exams.length - 1),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddExamDialog(BuildContext context) async {
    final result = await showDialog<Exam>(
      context: context,
      builder: (context) => const ExamFormDialog(),
    );

    if (result != null) {
      context.read<ExamProvider>().addExam(result);
    }
  }

  Future<void> _showEditExamDialog(BuildContext context, Exam exam) async {
    final result = await showDialog<Exam>(
      context: context,
      builder: (context) => ExamFormDialog(exam: exam),
    );

    if (result != null) {
      context.read<ExamProvider>().updateExam(exam, result);
    }
  }

  Widget _buildExamItem(BuildContext context, Exam exam, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: exam.color,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam.subject,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        PhosphorIcons.calendar(PhosphorIconsStyle.bold),
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        exam.date,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        PhosphorIcons.clock(PhosphorIconsStyle.bold),
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        exam.time,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
