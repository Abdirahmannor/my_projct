import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';

class ProjectFilterDialog extends StatefulWidget {
  final Map<String, bool> selectedCategories;
  final Map<String, bool> selectedPriorities;
  final Map<String, bool> selectedStatuses;
  final DateTimeRange? dateRange;

  const ProjectFilterDialog({
    super.key,
    required this.selectedCategories,
    required this.selectedPriorities,
    required this.selectedStatuses,
    this.dateRange,
  });

  @override
  State<ProjectFilterDialog> createState() => _ProjectFilterDialogState();
}

class _ProjectFilterDialogState extends State<ProjectFilterDialog> {
  late Map<String, bool> _categories;
  late Map<String, bool> _priorities;
  late Map<String, bool> _statuses;
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    _categories = Map.from(widget.selectedCategories);
    _priorities = Map.from(widget.selectedPriorities);
    _statuses = Map.from(widget.selectedStatuses);
    _dateRange = widget.dateRange;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Projects',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _categories.updateAll((key, value) => false);
                      _priorities.updateAll((key, value) => false);
                      _statuses.updateAll((key, value) => false);
                      _dateRange = null;
                    });
                  },
                  icon: Icon(
                    PhosphorIcons.trash(PhosphorIconsStyle.bold),
                    size: 20,
                    color: Theme.of(context).hintColor,
                  ),
                  tooltip: 'Clear filters',
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Categories',
              items: _categories,
              onChanged: (key, value) {
                setState(() {
                  _categories[key] = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Priorities',
              items: _priorities,
              onChanged: (key, value) {
                setState(() {
                  _priorities[key] = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Status',
              items: _statuses,
              onChanged: (key, value) {
                setState(() {
                  _statuses[key] = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildDateRangeSection(),
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
                  onPressed: () => Navigator.pop(context, {
                    'categories': _categories,
                    'priorities': _priorities,
                    'statuses': _statuses,
                    'dateRange': _dateRange,
                  }),
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Map<String, bool> items,
    required Function(String, bool) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.entries.map((entry) {
            return FilterChip(
              label: Text(entry.key.toUpperCase()),
              selected: entry.value,
              onSelected: (value) => onChanged(entry.key, value),
              backgroundColor: Theme.of(context).cardColor,
              selectedColor: AppColors.accent.withOpacity(0.2),
              checkmarkColor: AppColors.accent,
              side: BorderSide(
                color: entry.value
                    ? AppColors.accent
                    : Theme.of(context).dividerColor,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDateRange,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  PhosphorIcons.calendar(PhosphorIconsStyle.bold),
                  size: 20,
                  color: Theme.of(context).hintColor,
                ),
                const SizedBox(width: 8),
                Text(
                  _dateRange == null
                      ? 'Select date range'
                      : '${_formatDate(_dateRange!.start)} - ${_formatDate(_dateRange!.end)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (_dateRange != null) ...[
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _dateRange = null;
                      });
                    },
                    icon: Icon(
                      PhosphorIcons.x(PhosphorIconsStyle.bold),
                      size: 16,
                      color: Theme.of(context).hintColor,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: _dateRange,
    );

    if (picked != null) {
      setState(() {
        _dateRange = picked;
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
}
