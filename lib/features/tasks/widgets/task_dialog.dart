import 'package:flutter/material.dart';
import '../../../core/base/base_dialog.dart';
import '../../../core/base/base_constants.dart';
import '../models/task.dart';

class TaskDialog extends BaseDialog {
  final Task? task;
  final String projectId;

  const TaskDialog({
    super.key,
    this.task,
    required this.projectId,
  }) : super(isEditing: task != null);

  @override
  TaskDialogState createState() => TaskDialogState();
}

class TaskDialogState extends BaseDialogState<TaskDialog> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? dueDate;
  String priority = 'medium';
  String status = 'not started';
  bool isCompleted = false;
  DateTime? startDate;
  List<String> assignees = [];
  List<String> labels = [];
  String? parentTaskId;
  int? estimatedHours;
  int? actualHours;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      // Pre-fill form if editing
      nameController.text = widget.task!.name;
      descriptionController.text = widget.task!.description ?? '';
      dueDate = widget.task!.dueDate;
      priority = widget.task!.priority;
      status = widget.task!.status;
      isCompleted = widget.task!.isCompleted;
      startDate = widget.task!.startDate;
      assignees = widget.task!.assignees ?? [];
      labels = widget.task!.labels ?? [];
      parentTaskId = widget.task!.parentTaskId;
      estimatedHours = widget.task!.estimatedHours;
      actualHours = widget.task!.actualHours;
    } else {
      // Set default due date to tomorrow
      dueDate = DateTime.now().add(const Duration(days: 1));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  String get dialogTitle => widget.isEditing ? 'Edit Task' : 'New Task';

  @override
  String get submitButtonText => widget.isEditing ? 'Update' : 'Create';

  @override
  Widget buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name Field
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Task Name',
            hintText: 'Enter task name',
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Name is required' : null,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),

        // Description Field
        TextFormField(
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            hintText: 'Enter task description',
          ),
          maxLines: 3,
          textInputAction: TextInputAction.newline,
        ),
        const SizedBox(height: 16),

        // Due Date Picker
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Due Date'),
          subtitle: Text(
            dueDate != null
                ? '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}'
                : 'Select due date',
          ),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate:
                  dueDate ?? DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) {
              setState(() => dueDate = picked);
            }
          },
        ),

        // Priority Dropdown
        DropdownButtonFormField<String>(
          value: priority,
          decoration: const InputDecoration(labelText: 'Priority'),
          items: ['low', 'medium', 'high', 'critical']
              .map((p) => DropdownMenuItem(
                    value: p,
                    child: Text(p[0].toUpperCase() + p.substring(1)),
                  ))
              .toList(),
          onChanged: (value) => setState(() => priority = value!),
        ),
        const SizedBox(height: 16),

        // Status Dropdown
        DropdownButtonFormField<String>(
          value: status,
          decoration: const InputDecoration(labelText: 'Status'),
          items: ['not started', 'in progress', 'on hold', 'completed']
              .map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(s[0].toUpperCase() + s.substring(1)),
                  ))
              .toList(),
          onChanged: (value) => setState(() => status = value!),
        ),
        const SizedBox(height: 16),

        // Completion Status
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Mark as Completed'),
          value: isCompleted,
          onChanged: (value) => setState(() => isCompleted = value!),
        ),

        // Time Tracking
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: estimatedHours?.toString(),
                decoration: const InputDecoration(
                  labelText: 'Estimated Hours',
                  hintText: 'Enter estimated hours',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    setState(() => estimatedHours = int.tryParse(value)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                initialValue: actualHours?.toString(),
                decoration: const InputDecoration(
                  labelText: 'Actual Hours',
                  hintText: 'Enter actual hours',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    setState(() => actualHours = int.tryParse(value)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Assignees
        Wrap(
          spacing: 8,
          children: [
            ...assignees.map((assignee) => Chip(
                  label: Text(assignee),
                  onDeleted: () => setState(() => assignees.remove(assignee)),
                )),
            ActionChip(
              label: const Text('Add Assignee'),
              onPressed: () async {
                final result = await showDialog<String>(
                  context: context,
                  builder: (context) => const AssigneeDialog(),
                );
                if (result != null) {
                  setState(() => assignees.add(result));
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Labels
        Wrap(
          spacing: 8,
          children: [
            ...labels.map((label) => Chip(
                  label: Text(label),
                  onDeleted: () => setState(() => labels.remove(label)),
                )),
            ActionChip(
              label: const Text('Add Label'),
              onPressed: () async {
                final result = await showDialog<String>(
                  context: context,
                  builder: (context) => const LabelDialog(),
                );
                if (result != null) {
                  setState(() => labels.add(result));
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Future<void> handleSubmit() async {
    if (dueDate == null) {
      throw Exception('Due date is required');
    }

    final task = Task(
      id: widget.task?.id,
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      dueDate: dueDate!,
      priority: priority,
      status: status,
      projectId: widget.projectId,
      isCompleted: isCompleted,
      startDate: startDate,
      assignees: assignees,
      labels: labels,
      parentTaskId: parentTaskId,
      estimatedHours: estimatedHours,
      actualHours: actualHours,
    );

    Navigator.pop(context, task);
  }
}

// Helper dialogs for assignees and labels
class AssigneeDialog extends StatelessWidget {
  const AssigneeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return AlertDialog(
      title: const Text('Add Assignee'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Assignee Name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class LabelDialog extends StatelessWidget {
  const LabelDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return AlertDialog(
      title: const Text('Add Label'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Label Name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
