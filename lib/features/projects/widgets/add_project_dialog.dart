import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../models/project.dart';
import 'package:uuid/uuid.dart';

class AddProjectDialog extends StatefulWidget {
  final Project? project;

  const AddProjectDialog({super.key, this.project});

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late DateTime _startDate;
  late DateTime _dueDate;
  String _priority = 'medium';
  String _category = 'other';
  bool _isPinned = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?.name);
    _descriptionController =
        TextEditingController(text: widget.project?.description);
    _startDate = widget.project?.startDate ?? DateTime.now();
    _dueDate =
        widget.project?.dueDate ?? DateTime.now().add(const Duration(days: 7));
    _priority = widget.project?.priority ?? 'medium';
    _category = widget.project?.category ?? 'other';
    _isPinned = widget.project?.isPinned ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.project == null ? 'New Project' : 'Edit Project',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              _buildNameField(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: _buildDateField('Start Date', _startDate, true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDateField('Due Date', _dueDate, false)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildPriorityDropdown()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildCategoryDropdown()),
                ],
              ),
              const SizedBox(height: 16),
              _buildPinCheckbox(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _saveProject,
                    child: Text(widget.project == null ? 'Create' : 'Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Project Name',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a project name';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime date, bool isStart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(isStart),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(
                  isStart
                      ? PhosphorIcons.calendarBlank(PhosphorIconsStyle.bold)
                      : PhosphorIcons.calendarCheck(PhosphorIconsStyle.bold),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(date),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Priority'),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _priority,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: ['low', 'medium', 'high']
              .map((priority) => DropdownMenuItem(
                    value: priority,
                    child: Text(priority.toUpperCase()),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _priority = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category'),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _category,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: ['school', 'work', 'personal', 'other']
              .map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category.toUpperCase()),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _category = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPinCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _isPinned,
          onChanged: (value) {
            setState(() {
              _isPinned = value!;
            });
          },
        ),
        const SizedBox(width: 8),
        const Text('Pin this project'),
      ],
    );
  }

  Future<void> _selectDate(bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _dueDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  void _saveProject() {
    if (_formKey.currentState!.validate()) {
      final project = Project(
        id: widget.project?.id ?? const Uuid().v4(),
        name: _nameController.text,
        description: _descriptionController.text,
        startDate: _startDate,
        dueDate: _dueDate,
        priority: _priority,
        status: widget.project?.status ?? 'not started',
        category: _category,
        isPinned: _isPinned,
      );
      Navigator.pop(context, project);
    }
  }
}
