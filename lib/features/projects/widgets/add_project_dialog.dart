import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddProjectDialog extends StatefulWidget {
  const AddProjectDialog({super.key});

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _priority = 'medium';
  String _status = 'not started';
  String _category = 'development';
  TimeOfDay? _time;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Select Time';
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Create New Project',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      PhosphorIcons.x(PhosphorIconsStyle.bold),
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Project Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Project Name',
                  hintText: 'Enter project name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(
                    PhosphorIcons.folder(PhosphorIconsStyle.bold),
                    size: 20,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a project name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter project description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(
                    PhosphorIcons.textT(PhosphorIconsStyle.bold),
                    size: 20,
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // Priority and Status
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _priority,
                      decoration: InputDecoration(
                        labelText: 'Priority',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(
                          PhosphorIcons.flag(PhosphorIconsStyle.bold),
                          size: 20,
                          color: _getPriorityColor(_priority),
                        ),
                      ),
                      items: ['low', 'medium', 'high']
                          .map((priority) => DropdownMenuItem(
                                value: priority,
                                child: Text(
                                  priority.toUpperCase(),
                                  style: TextStyle(
                                    color: _getPriorityColor(priority),
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _priority = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _status,
                      decoration: InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(
                          PhosphorIcons.clockCountdown(PhosphorIconsStyle.bold),
                          size: 20,
                          color: _getStatusColor(_status),
                        ),
                      ),
                      items:
                          ['not started', 'in progress', 'on hold', 'completed']
                              .map((status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(
                                      status.toUpperCase(),
                                      style: TextStyle(
                                        color: _getStatusColor(status),
                                      ),
                                    ),
                                  ))
                              .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _status = value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Time and Category
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        PhosphorIcons.clock(PhosphorIconsStyle.bold),
                        size: 20,
                      ),
                      title: const Text('Time'),
                      subtitle: Text(_formatTime(_time)),
                      onTap: () => _selectTime(context),
                    ),
                  ),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _category,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(
                          PhosphorIcons.tag(PhosphorIconsStyle.bold),
                          size: 20,
                        ),
                      ),
                      items: [
                        'development',
                        'design',
                        'marketing',
                        'research',
                        'other'
                      ]
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _category = value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(PhosphorIcons.x(PhosphorIconsStyle.bold)),
                    label: const Text('Cancel'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  FilledButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newProject = {
                          'name': _nameController.text,
                          'description': _descriptionController.text,
                          'category': _category,
                          'time': _time != null ? _formatTime(_time) : '09:00',
                          'tasks': 0,
                          'priority': _priority,
                          'status': _status,
                        };
                        Navigator.pop(context, newProject);
                      }
                    },
                    icon: Icon(PhosphorIcons.check(PhosphorIconsStyle.bold)),
                    label: const Text('Create Project'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      case 'low':
        return AppColors.success;
      default:
        return AppColors.info;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.success;
      case 'in progress':
        return AppColors.accent;
      case 'on hold':
        return AppColors.warning;
      default:
        return AppColors.error;
    }
  }
}
