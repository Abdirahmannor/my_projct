import 'package:flutter/material.dart';
import '../../../core/base/base_dialog.dart';
import '../../../core/base/base_constants.dart';
import '../models/project.dart';

class ProjectDialog extends BaseDialog {
  final Project? project;

  const ProjectDialog({
    super.key,
    this.project,
  }) : super(isEditing: project != null);

  @override
  ProjectDialogState createState() => ProjectDialogState();
}

class ProjectDialogState extends BaseDialogState<ProjectDialog> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? dueDate;
  String priority = 'medium';
  String status = 'not started';
  String? category;
  bool isPinned = false;

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      // Pre-fill form if editing
      nameController.text = widget.project!.name;
      descriptionController.text = widget.project!.description ?? '';
      dueDate = widget.project!.dueDate;
      priority = widget.project!.priority;
      status = widget.project!.status;
      category = widget.project!.category;
      isPinned = widget.project!.isPinned ?? false;
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
  String get dialogTitle => widget.isEditing ? 'Edit Project' : 'New Project';

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
            labelText: 'Project Name',
            hintText: 'Enter project name',
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
            hintText: 'Enter project description',
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

        // Category Field
        TextFormField(
          initialValue: category,
          decoration: const InputDecoration(
            labelText: 'Category (Optional)',
            hintText: 'Enter project category',
          ),
          onChanged: (value) => setState(() => category = value),
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 16),

        // Pin Checkbox
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Pin Project'),
          value: isPinned,
          onChanged: (value) => setState(() => isPinned = value!),
        ),
      ],
    );
  }

  @override
  Future<void> handleSubmit() async {
    if (dueDate == null) {
      throw Exception('Due date is required');
    }

    final project = Project(
      id: widget.project?.id,
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      dueDate: dueDate!,
      priority: priority,
      status: status,
      category: category?.trim(),
      isPinned: isPinned,
      tasks: widget.project?.tasks ?? 0,
      completedTasks: widget.project?.completedTasks ?? 0,
    );

    Navigator.pop(context, project);
  }
}
