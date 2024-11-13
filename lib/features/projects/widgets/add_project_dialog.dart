import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:iconsax/iconsax.dart';
import '../../../shared/widgets/pickers/custom_pickers.dart';
import 'package:intl/intl.dart';

class AddProjectDialog extends StatefulWidget {
  const AddProjectDialog({super.key});

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime? startDate;
  DateTime? dueDate;
  String? selectedPriority;
  String? selectedStatus;
  String? selectedCategory;
  TimeOfDay? selectedTime;
  final _projectNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
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
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      icon: Icon(PhosphorIcons.x()),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _projectNameController,
                  decoration: InputDecoration(
                    labelText: 'Project Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Project name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedPriority,
                        decoration: InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: Icon(PhosphorIcons.flag(), size: 18),
                        ),
                        icon: const SizedBox.shrink(),
                        items: [
                          DropdownMenuItem(
                            value: 'high',
                            child: Row(
                              children: [
                                Icon(
                                  PhosphorIcons.flag(),
                                  size: 16,
                                  color: Colors.red[400],
                                ),
                                const SizedBox(width: 8),
                                const Text('High'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'medium',
                            child: Row(
                              children: [
                                Icon(
                                  PhosphorIcons.flag(),
                                  size: 16,
                                  color: Colors.orange[400],
                                ),
                                const SizedBox(width: 8),
                                const Text('Medium'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'low',
                            child: Row(
                              children: [
                                Icon(
                                  PhosphorIcons.flag(),
                                  size: 16,
                                  color: Colors.green[400],
                                ),
                                const SizedBox(width: 8),
                                const Text('Low'),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedPriority = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Priority is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedStatus,
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: Icon(
                              PhosphorIcons.clockCounterClockwise(),
                              size: 18),
                        ),
                        icon: const SizedBox.shrink(),
                        items: [
                          'Not Started',
                          'In Progress',
                          'On Hold',
                        ]
                            .map((e) => DropdownMenuItem(
                                  value: e.toLowerCase(),
                                  child: Row(
                                    children: [
                                      Icon(
                                        e == 'Not Started'
                                            ? PhosphorIcons.pause()
                                            : e == 'In Progress'
                                                ? PhosphorIcons.playCircle()
                                                : PhosphorIcons.stopCircle(),
                                        size: 16,
                                        color: e == 'In Progress'
                                            ? Colors.blue[400]
                                            : e == 'On Hold'
                                                ? Colors.orange[400]
                                                : Colors.grey[400],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(e),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Status is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Start Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: Icon(PhosphorIcons.calendar(), size: 18),
                        ),
                        controller: TextEditingController(
                          text: startDate != null
                              ? DateFormat('MMM dd, yyyy').format(startDate!)
                              : '',
                        ),
                        onTap: () async {
                          final date = await showDialog<DateTime>(
                            context: context,
                            builder: (context) => CustomDateTimePicker(
                              initialDate: startDate,
                              onDateSelected: (date) {
                                Navigator.pop(context, date);
                              },
                            ),
                          );
                          if (date != null) {
                            setState(() {
                              startDate = date;
                            });
                          }
                        },
                        validator: (value) {
                          if (startDate == null) {
                            return 'Start date is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Due Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: Icon(PhosphorIcons.calendar(), size: 18),
                        ),
                        controller: TextEditingController(
                          text: dueDate != null
                              ? DateFormat('MMM dd, yyyy').format(dueDate!)
                              : '',
                        ),
                        onTap: () async {
                          final date = await showDialog<DateTime>(
                            context: context,
                            builder: (context) => CustomDateTimePicker(
                              initialDate: dueDate,
                              onDateSelected: (date) {
                                Navigator.pop(context, date);
                              },
                            ),
                          );
                          if (date != null) {
                            setState(() {
                              dueDate = date;
                            });
                          }
                        },
                        validator: (value) {
                          if (dueDate == null) {
                            return 'Due date is required';
                          }
                          if (startDate != null &&
                              dueDate!.isBefore(startDate!)) {
                            return 'Due date must be after start date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Estimated Hours',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: Icon(PhosphorIcons.clock(), size: 18),
                        ),
                        controller: TextEditingController(
                          text: selectedTime != null
                              ? '${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                              : '',
                        ),
                        readOnly: true,
                        onTap: () async {
                          final time = await showDialog<TimeOfDay>(
                            context: context,
                            builder: (context) => CustomDateTimePicker(
                              isTimePicker: true,
                              initialTime: selectedTime,
                              onTimeSelected: (time) {
                                Navigator.pop(context, time);
                              },
                              onDateSelected: (_) {},
                            ),
                          );
                          if (time != null) {
                            setState(() {
                              selectedTime = time;
                            });
                          }
                        },
                        validator: (value) {
                          if (selectedTime == null) {
                            return 'Estimated hours is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: Icon(PhosphorIcons.folders(), size: 18),
                        ),
                        icon: const SizedBox.shrink(),
                        items: ['Personal', 'School', 'Hobby']
                            .map((e) => DropdownMenuItem(
                                  value: e.toLowerCase(),
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Category is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notes (Optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
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
                          final project = {
                            'name': _projectNameController.text,
                            'description': _descriptionController.text,
                            'priority': selectedPriority,
                            'status': selectedStatus,
                            'startDate': startDate,
                            'dueDate': dueDate,
                            'estimatedHours': selectedTime,
                            'category': selectedCategory,
                            'notes': _notesController.text,
                          };

                          // Close dialog and return project data
                          Navigator.pop(context, project);
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5722),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('Create Project'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
