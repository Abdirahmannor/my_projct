import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../constants/app_colors.dart';
import 'base_item.dart';

abstract class BaseDialog<T extends BaseItem> extends StatefulWidget {
  final bool isEditing;
  final T? item;

  const BaseDialog({
    super.key,
    this.isEditing = false,
    this.item,
  });

  @override
  BaseDialogState<T, BaseDialog<T>> createState();
}

abstract class BaseDialogState<T extends BaseItem, S extends BaseDialog<T>>
    extends State<S> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _dueDate;
  String _priority = 'medium';
  String _status = 'not started';

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.item != null) {
      _initializeWithItem(widget.item!);
    } else {
      _initializeDefaults();
    }
  }

  // Methods to be implemented by subclasses
  void _initializeWithItem(T item);
  void _initializeDefaults();
  T createItem();

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
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: buildForm(context),
                ),
              ),
            ),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  // Template method to be implemented by subclasses
  Widget buildForm(BuildContext context);

  Widget _buildHeader(BuildContext context) {
    return Container(
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
            widget.isEditing ? 'Edit Item' : 'Add New Item',
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
    );
  }

  Widget _buildActions(BuildContext context) {
    return Container(
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
            child: Text(widget.isEditing ? 'Update' : 'Create'),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (_validateForm()) {
      Navigator.pop(context, createItem());
    }
  }

  bool _validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
