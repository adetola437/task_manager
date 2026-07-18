import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/core/theme/app_theme.dart';
import 'package:task_manager/features/tasks/models/task.dart';
import 'package:task_manager/features/tasks/presentation/providers/task_providers.dart';

/// Handles both "add" and "edit" in a single screen — passing an
/// [existingTask] switches it into edit mode. This avoids duplicating the
/// form UI and validation logic across two near-identical screens.
class AddEditTaskScreen extends ConsumerStatefulWidget {
  final Task? existingTask;

  const AddEditTaskScreen({super.key, this.existingTask});

  bool get isEditing => existingTask != null;

  @override
  ConsumerState<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends ConsumerState<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingTask?.title ?? '');
    _descriptionController = TextEditingController(text: widget.existingTask?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(taskProvider.notifier);
      if (widget.isEditing) {
        await notifier.updateTask(widget.existingTask!.id, _titleController.text, _descriptionController.text);
      } else {
        await notifier.addTask(_titleController.text, _descriptionController.text);
      }

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save the task. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditing ? 'Edit Task' : 'New Task')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20.w),
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(color: AppColors.indigo, borderRadius: BorderRadius.circular(18.r)),
              child: Icon(
                widget.isEditing ? Icons.edit_note_rounded : Icons.add_task_rounded,
                color: Colors.white,
                size: 28.sp,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    autofocus: !widget.isEditing,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(fontSize: 15.sp),
                    decoration: const InputDecoration(labelText: 'Title', hintText: 'e.g. Buy groceries'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _descriptionController,
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 3,
                    maxLines: 6,
                    style: TextStyle(fontSize: 15.sp),
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Add any extra details (optional)',
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            FilledButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? SizedBox(
                      height: 18.w,
                      width: 18.w,
                      child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(widget.isEditing ? 'Save Changes' : 'Add Task', style: TextStyle(fontSize: 15.sp)),
            ),
          ],
        ),
      ),
    );
  }
}
