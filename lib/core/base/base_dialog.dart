import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../constants/app_colors.dart';
import 'base_validators.dart';

abstract class BaseDialog extends StatefulWidget {
  final bool isEditing;

  const BaseDialog({
    super.key,
    this.isEditing = false,
  });

  @override
  BaseDialogState createState();
}

abstract class BaseDialogState<T extends BaseDialog> extends State<T> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Abstract methods to be implemented by subclasses
  Widget buildForm();
  Future<void> handleSubmit();
  String get dialogTitle;
  String get submitButtonText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            widget.isEditing
                ? PhosphorIcons.pencilSimple(PhosphorIconsStyle.fill)
                : PhosphorIcons.plus(PhosphorIconsStyle.fill),
            color: AppColors.accent,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(dialogTitle),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: buildForm(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
        FilledButton(
          onPressed: _isLoading
              ? null
              : () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    setState(() => _isLoading = true);
                    try {
                      await handleSubmit();
                      if (mounted) Navigator.pop(context);
                    } catch (e) {
                      if (mounted) {
                        await BaseValidators.showErrorDialog(
                          context: context,
                          message: 'Failed to save: $e',
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() => _isLoading = false);
                      }
                    }
                  }
                },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.accent,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(submitButtonText),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      actionsPadding: const EdgeInsets.all(16),
    );
  }
}
