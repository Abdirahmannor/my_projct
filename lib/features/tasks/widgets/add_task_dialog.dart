import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';

class AddTaskDialog extends StatefulWidget {
  final bool isEditing;
  final Map<String, dynamic>? task;

  const AddTaskDialog({
    super.key,
    this.isEditing = false,
    this.task,
  });

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  String _priority = 'medium';
  String _status = 'to do';
  String _project = 'Mathematics'; // Default project

  final List<String> _projects = [
    'Mathematics',
    'Physics',
    'English',
    'Computer Science',
    'History',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.task != null) {
      // Initialize form with existing task data
      _nameController.text = widget.task!['name'];
      _descriptionController.text = widget.task!['description'] ?? '';
      _dueDate = _parseDateTime(widget.task!['dueDate']);
      _dueTime =
          TimeOfDay.fromDateTime(_parseDateTime(widget.task!['dueDate']));
      _priority = widget.task!['priority'];
      _status = widget.task!['status'];
      _project = widget.task!['project'];
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
                        : PhosphorIcons.plusCircle(PhosphorIconsStyle.fill),
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.isEditing ? 'Edit Task' : 'Add New Task',
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
                      // Task Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Task Name',
                          prefixIcon: Icon(
                              PhosphorIcons.textT(PhosphorIconsStyle.bold)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a task name';
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
                      ),
                      const SizedBox(height: 24),

                      // Due Date and Time Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildDatePicker(
                              label: 'Due Date',
                              value: _dueDate,
                              icon: PhosphorIcons.calendar(
                                  PhosphorIconsStyle.regular),
                              onChanged: (date) =>
                                  setState(() => _dueDate = date),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTimePicker(
                              label: 'Due Time',
                              value: _dueTime,
                              icon: PhosphorIcons.clock(
                                  PhosphorIconsStyle.regular),
                              onChanged: (time) =>
                                  setState(() => _dueTime = time),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Project, Priority and Status Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Project Selector
                          Expanded(
                            child: _buildCompactSelector(
                              title: 'Project',
                              options: Map.fromEntries(
                                _projects.map(
                                  (p) => MapEntry(
                                    p,
                                    (
                                      AppColors.accent,
                                      PhosphorIcons.folder(
                                          PhosphorIconsStyle.regular)
                                    ),
                                  ),
                                ),
                              ),
                              value: _project,
                              onChanged: (value) =>
                                  setState(() => _project = value),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Priority and Status Column
                          Expanded(
                            child: Column(
                              children: [
                                _buildCompactSelector(
                                  title: 'Priority',
                                  options: {
                                    'critical': (Colors.red.shade600, null),
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
                                    'to do': (Colors.blue.shade400, null),
                                    'in progress': (
                                      Colors.orange.shade400,
                                      null
                                    ),
                                    'blocked': (Colors.red.shade400, null),
                                    'done': (Colors.green.shade400, null),
                                  },
                                  value: _status,
                                  onChanged: (value) =>
                                      setState(() => _status = value),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
                    child:
                        Text(widget.isEditing ? 'Update Task' : 'Create Task'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add helper methods here (similar to AddProjectDialog)
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
          firstDate: DateTime.now(),
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
            Icon(icon, size: 20, color: hasError ? Colors.red : null),
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

  Widget _buildTimePicker({
    required String label,
    required TimeOfDay? value,
    required IconData icon,
    required ValueChanged<TimeOfDay?> onChanged,
  }) {
    return InkWell(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: value ?? TimeOfDay.now(),
        );
        if (time != null) {
          onChanged(time);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value == null ? 'Select time' : value.format(context),
                    style: Theme.of(context).textTheme.bodyLarge,
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

  void _handleSubmit() {
    if (!_validateForm()) return;

    final DateTime now = DateTime.now();
    final DateTime dueDateTime = DateTime(
      _dueDate?.year ?? now.year,
      _dueDate?.month ?? now.month,
      _dueDate?.day ?? now.day,
      _dueTime?.hour ?? now.hour,
      _dueTime?.minute ?? now.minute,
    );

    final task = {
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'project': _project,
      'dueDate': dueDateTime.toIso8601String(),
      'priority': _priority,
      'status': _status,
    };

    Navigator.pop(context, task);
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) return false;

    if (_dueDate == null) {
      _showError('Please select a due date');
      return false;
    }

    if (_dueTime == null) {
      _showError('Please select a due time');
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

  DateTime _parseDateTime(String date) {
    return DateTime.parse(date);
  }
}
