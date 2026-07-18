import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/core/theme/app_theme.dart';
import 'package:task_manager/features/tasks/presentation/providers/task_providers.dart';

/// Kept as a StatefulWidget (not a plain ConsumerWidget) specifically so the
/// TextEditingController persists across rebuilds — recreating it on every
/// build (as a naive `ConsumerWidget` version would) drops cursor position
/// and focus every time the provider updates.
class TaskSearchBar extends ConsumerStatefulWidget {
  const TaskSearchBar({super.key});

  @override
  ConsumerState<TaskSearchBar> createState() => _TaskSearchBarState();
}

class _TaskSearchBarState extends ConsumerState<TaskSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(searchQueryProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);

    // Only clearing the field externally (the × button) needs to sync the
    // controller back — typing itself already updates the provider via
    // onChanged, so we avoid feedback loops by checking for divergence.
    if (query != _controller.text && query.isEmpty) {
      _controller.clear();
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
        style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search tasks…',
          hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
          prefixIcon: Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20.sp),
          suffixIcon: query.isEmpty
              ? null
              : IconButton(
                  icon: Icon(Icons.close_rounded, color: AppColors.textMuted, size: 18.sp),
                  onPressed: () => ref.read(searchQueryProvider.notifier).state = '',
                ),
          isDense: true,
        ),
      ),
    );
  }
}
