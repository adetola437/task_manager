import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/theme/app_theme.dart';
import 'package:task_manager/features/tasks/models/task.dart';

/// A single task, rendered as a rounded card rather than a bare `ListTile`
/// row — a colored accent bar on the left (indigo = pending, green = done)
/// stands in for the category-color-coding pattern, but tied to actual
/// task state instead of an unused category field.
class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final accent = task.isCompleted ? AppColors.green : AppColors.indigo;

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      // Confirmation dialog is required by the spec, so the swipe itself
      // must not delete — it only *proposes* a delete via confirmDismiss.
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: AppColors.rose,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22.sp),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 4.w,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(18.r)),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(18.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    child: Row(
                      children: [
                        _CircleCheckbox(checked: task.isCompleted, accent: accent, onTap: onToggle),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: task.isCompleted ? AppColors.textMuted : AppColors.textPrimary,
                                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              if (task.description.isNotEmpty) ...[
                                SizedBox(height: 3.h),
                                Text(
                                  task.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.5.sp,
                                    color: AppColors.textMuted,
                                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                              ],
                              SizedBox(height: 4.h),
                              Text(
                                DateFormat('MMM d, h:mm a').format(task.createdAt),
                                style: TextStyle(fontSize: 10.5.sp, color: AppColors.textMuted.withOpacity(0.8)),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline_rounded, size: 20.sp, color: AppColors.textMuted),
                          tooltip: 'Delete task',
                          onPressed: () async {
                            final confirmed = await _confirmDelete(context);
                            if (confirmed == true) onDelete();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: const Text('Delete task?'),
        content: Text('"${task.title}" will be permanently removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.rose),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _CircleCheckbox extends StatelessWidget {
  final bool checked;
  final Color accent;
  final VoidCallback onTap;

  const _CircleCheckbox({required this.checked, required this.accent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 26.w,
        height: 26.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: checked ? accent : Colors.transparent,
          border: Border.all(color: checked ? accent : AppColors.track, width: 2),
        ),
        child: checked ? Icon(Icons.check_rounded, size: 16.sp, color: Colors.white) : null,
      ),
    );
  }
}
