import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';
import 'package:flutter/gestures.dart';
import '../models/project.dart';
import '../services/project_database_service.dart';

class AddProjectDialog extends StatefulWidget {
  final bool isEditing;
  final Project? project;

  const AddProjectDialog({
    super.key,
    this.isEditing = false,
    this.project,
  });

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _dueDate;
  String _priority = 'medium';
  String _status = 'not started';
  int _tasks = 0;
  String _category = 'personal';
  final _projectDatabaseService = ProjectDatabaseService();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.project != null) {
      // Initialize form with existing project data
      _nameController.text = widget.project!.name;
      _descriptionController.text = widget.project!.description ?? '';
      _startDate = widget.project!.startDate;
      _dueDate = widget.project!.dueDate;
      _priority = widget.project!.priority;
      _status = widget.project!.status;
      _tasks = widget.project!.tasks;
      _category = widget.project!.category;
    } else {
      // Set default values for new projects
      _startDate = DateTime.now();
      _dueDate = DateTime.now();
      _tasks = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent,
                    Color.lerp(AppColors.accent, Colors.purple, 0.6) ??
                        AppColors.accent,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.isEditing
                        ? PhosphorIcons.pencilSimple(PhosphorIconsStyle.fill)
                        : PhosphorIcons.folderPlus(PhosphorIconsStyle.fill),
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.isEditing ? 'Edit Project' : 'Add New Project',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      PhosphorIcons.x(PhosphorIconsStyle.bold),
                      color: Colors.white,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
            ),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Project Name',
                          prefixIcon: Icon(
                              PhosphorIcons.textT(PhosphorIconsStyle.bold)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a project name';
                          }
                          if (value.trim().length < 3) {
                            return 'Project name must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          prefixIcon: Icon(
                              PhosphorIcons.article(PhosphorIconsStyle.bold)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a project description';
                          }
                          if (value.trim().length < 10) {
                            return 'Description must be at least 10 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Dates Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildDatePicker(
                              label: 'Start Date',
                              value: _startDate,
                              icon: PhosphorIcons.calendar(
                                  PhosphorIconsStyle.regular),
                              onChanged: (date) =>
                                  setState(() => _startDate = date),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDatePicker(
                              label: 'Due Date',
                              value: _dueDate,
                              icon: PhosphorIcons.calendarCheck(
                                  PhosphorIconsStyle.regular),
                              onChanged: (date) =>
                                  setState(() => _dueDate = date),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Priority and Status Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                _buildCompactSelector(
                                  title: 'Priority',
                                  options: {
                                    'high': (Colors.red.shade400, null),
                                    'medium': (Colors.orange.shade400, null),
                                    'low': (Colors.green.shade400, null),
                                  },
                                  value: _priority,
                                  onChanged: (value) =>
                                      setState(() => _priority = value),
                                ),
                                const SizedBox(height: 16),
                                _buildCompactSelector(
                                  title: 'Status',
                                  options: {
                                    'not started': (Colors.grey.shade400, null),
                                    'in progress': (Colors.blue.shade400, null),
                                    'on hold': (Colors.orange.shade400, null),
                                    'completed': (Colors.green.shade400, null),
                                  },
                                  value: _status,
                                  onChanged: (value) =>
                                      setState(() => _status = value),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              children: [
                                _buildCompactSelector(
                                  title: 'Category',
                                  options: {
                                    'school': (
                                      AppColors.accent,
                                      PhosphorIcons.graduationCap(
                                          PhosphorIconsStyle.regular)
                                    ),
                                    'personal': (
                                      Colors.purple.shade400,
                                      PhosphorIcons.user(
                                          PhosphorIconsStyle.regular)
                                    ),
                                    'work': (
                                      Colors.blue.shade400,
                                      PhosphorIcons.suitcase(
                                          PhosphorIconsStyle.regular)
                                    ),
                                    'online work': (
                                      Colors.green.shade400,
                                      PhosphorIcons.globe(
                                          PhosphorIconsStyle.regular)
                                    ),
                                    'other': (
                                      Colors.grey.shade400,
                                      PhosphorIcons.folder(
                                          PhosphorIconsStyle.regular)
                                    ),
                                  },
                                  value: _category,
                                  onChanged: (value) =>
                                      setState(() => _category = value),
                                ),
                                const SizedBox(height: 16),
                                _buildCompactTaskCounter(),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Actions
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border(
                            top: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 16),
                            FilledButton(
                              onPressed: _handleSubmit,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                              ),
                              child: Text(widget.isEditing
                                  ? 'Update Project'
                                  : 'Create Project'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? value,
    required IconData icon,
    required ValueChanged<DateTime?> onChanged,
  }) {
    final bool hasError =
        _formKey.currentState?.validate() == false && value == null;

    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          onChanged(date);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: hasError ? Colors.red : Theme.of(context).dividerColor,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
                label == 'Start Date'
                    ? PhosphorIcons.calendar(PhosphorIconsStyle.regular)
                    : PhosphorIcons.calendarCheck(PhosphorIconsStyle.regular),
                size: 20,
                color: hasError ? Colors.red : null),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: hasError ? Colors.red : null,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value == null
                        ? 'Select date'
                        : '${value.day} ${_getMonthName(value.month)}, ${value.year}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: hasError ? Colors.red : null,
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

  Widget _buildCompactSelector({
    required String title,
    required Map<String, (Color, IconData?)> options,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: options.entries.map((entry) {
              final isSelected = value == entry.key;
              final (color, icon) = entry.value;

              return InkWell(
                onTap: () => onChanged(entry.key),
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.1) : null,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 14, color: isSelected ? color : null),
                        const SizedBox(width: 8),
                      ] else ...[
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        entry.key.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected ? color : null,
                          fontWeight: isSelected ? FontWeight.w600 : null,
                        ),
                      ),
                      const Spacer(),
                      if (isSelected)
                        Icon(
                          PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                          size: 14,
                          color: color,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactTaskCounter() {
    final bool hasError =
        _formKey.currentState?.validate() == false && _tasks <= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Tasks',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Required',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: hasError ? Colors.red : Theme.of(context).dividerColor,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _buildCompactTaskButton(
                icon: PhosphorIcons.minus(PhosphorIconsStyle.bold),
                onPressed: () {
                  if (_tasks > 0) setState(() => _tasks--);
                },
                isEnabled: _tasks > 0,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    _tasks.toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
              _buildCompactTaskButton(
                icon: PhosphorIcons.plus(PhosphorIconsStyle.bold),
                onPressed: () => setState(() => _tasks++),
                isEnabled: true,
              ),
            ],
          ),
        ),
        if (hasError)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'At least one task is required',
              style: TextStyle(
                color: Colors.red,
                fontSize: 10,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCompactTaskButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isEnabled,
  }) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          child: Icon(
            icon,
            size: 16,
            color: isEnabled ? null : Theme.of(context).disabledColor,
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
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
    return months[month - 1];
  }

  void _handleSubmit() async {
    if (!_validateForm()) return;

    final project = Project(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      startDate: _startDate!,
      dueDate: _dueDate!,
      tasks: _tasks,
      completedTasks: 0,
      priority: _priority,
      status: _status,
      category: _category,
    );

    // Just return the project, let the screen handle database operations
    Navigator.pop(context, project);
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) return false;

    if (_startDate == null) {
      _showError('Please select a start date');
      return false;
    }

    if (_dueDate == null) {
      _showError('Please select a due date');
      return false;
    }

    if (_dueDate!.isBefore(_startDate!)) {
      _showError('Due date cannot be before start date');
      return false;
    }

    if (_tasks <= 0) {
      _showError('Project must have at least one task');
      return false;
    }

    return true;
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              PhosphorIcons.warning(PhosphorIconsStyle.fill),
              color: Colors.red.shade400,
              size: 24,
            ),
            const SizedBox(width: 12),
            const Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.accent),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
        actionsPadding: const EdgeInsets.all(16),
      ),
    );
  }

  DateTime _parseDate(String date) {
    final parts = date.split(' ');
    final day = int.parse(parts[0]);
    final month = _getMonth(parts[1].replaceAll(',', ''));
    final year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  int _getMonth(String monthName) {
    const months = [
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
    return months.indexOf(monthName) + 1;
  }
}
