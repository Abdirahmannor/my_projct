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
  final _notesController = TextEditingController();
  final _estimatedHoursController = TextEditingController();
  String _priority = 'medium';
  String _status = 'not started';
  String _category = 'development';
  DateTime? _startDate;
  DateTime? _dueDate;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _estimatedHoursController.dispose();
    super.dispose();
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: icon != null ? Icon(icon, size: 20) : null,
      ),
      validator: label == 'Project Name'
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a project name';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildPriorityDropdown() {
    return DropdownButtonFormField<String>(
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
      items: ['low', 'medium', 'high'].map((priority) {
        return DropdownMenuItem(
          value: priority,
          child: Text(
            priority.toUpperCase(),
            style: TextStyle(color: _getPriorityColor(priority)),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) setState(() => _priority = value);
      },
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
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
          ['not started', 'in progress', 'on hold', 'completed'].map((status) {
        return DropdownMenuItem(
          value: status,
          child: Text(
            status.toUpperCase(),
            style: TextStyle(color: _getStatusColor(status)),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) setState(() => _status = value);
      },
    );
  }

  Widget _buildDateField(String label, DateTime? date) {
    return InkWell(
      onTap: () => _selectDate(context, label == 'Start Date'),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: Icon(
            PhosphorIcons.calendar(PhosphorIconsStyle.bold),
            size: 20,
          ),
        ),
        child: Text(
          date != null
              ? '${date.day}/${date.month}/${date.year}'
              : 'Select Date',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
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
      items: ['development', 'design', 'marketing', 'research', 'other']
          .map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category.toUpperCase()),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) setState(() => _category = value);
      },
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _dueDate = picked;
        }
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    'Add New Project',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(PhosphorIcons.x(PhosphorIconsStyle.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildInputField(
                'Project Name',
                _nameController,
                icon: PhosphorIcons.folder(PhosphorIconsStyle.bold),
              ),
              const SizedBox(height: 16),
              _buildInputField(
                'Description',
                _descriptionController,
                icon: PhosphorIcons.textT(PhosphorIconsStyle.bold),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildPriorityDropdown()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatusDropdown()),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildDateField('Start Date', _startDate)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDateField('Due Date', _dueDate)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      'Estimated Hours',
                      _estimatedHoursController,
                      icon: PhosphorIcons.clock(PhosphorIconsStyle.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _buildCategoryDropdown()),
                ],
              ),
              const SizedBox(height: 16),
              _buildInputField(
                'Notes',
                _notesController,
                icon: PhosphorIcons.notepad(PhosphorIconsStyle.bold),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newProject = {
                          'name': _nameController.text,
                          'description': _descriptionController.text,
                          'priority': _priority,
                          'status': _status,
                          'startDate': '15 Sep, 2024',
                          'dueDate': '15 Oct, 2024',
                          'estimatedHours': _estimatedHoursController.text,
                          'category': _category,
                          'notes': _notesController.text,
                        };
                        Navigator.pop(context, newProject);
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5722),
                    ),
                    child: const Text('Create Project'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
