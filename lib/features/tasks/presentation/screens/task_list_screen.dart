import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/core/theme/app_theme.dart';
import 'package:task_manager/features/tasks/presentation/providers/task_providers.dart';
import 'package:task_manager/features/tasks/presentation/screens/add_edit_task_screen.dart';
import 'package:task_manager/features/tasks/presentation/widgets/empty_state.dart';
import 'package:task_manager/features/tasks/presentation/widgets/progress_ring.dart';
import 'package:task_manager/features/tasks/presentation/widgets/task_search_bar.dart';
import 'package:task_manager/features/tasks/presentation/widgets/task_tile.dart';
import 'package:task_manager/features/tasks/presentation/widgets/up_next_card.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Every one of these is a plain, synchronous value — ref.watch just
    // subscribes this widget to rebuild whenever the provider's state
    // changes, same as BlocBuilder would with a Cubit.
    final tasks = ref.watch(filteredTasksProvider);
    final hasQuery = ref.watch(searchQueryProvider).isNotEmpty;
    final stats = ref.watch(taskStatsProvider);
    final upNext = ref.watch(upNextTaskProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TopBar(remaining: stats.remaining),
                    SizedBox(height: 22.h),
                    _ProgressCard(stats: stats),
                    SizedBox(height: 16.h),
                    UpNextCard(
                      task: upNext,
                      onTap: upNext == null
                          ? null
                          : () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => AddEditTaskScreen(existingTask: upNext)),
                              ),
                    ),
                    SizedBox(height: 16.h),
                    const TaskSearchBar(),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Your Tasks', style: Theme.of(context).textTheme.titleMedium),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(color: AppColors.track, borderRadius: BorderRadius.circular(20.r)),
                          child: Text(
                            '${stats.total} total',
                            style: TextStyle(fontSize: 11.sp, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),
            if (tasks.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(
                  icon: hasQuery ? Icons.search_off_rounded : Icons.checklist_rounded,
                  title: hasQuery ? 'No matching tasks' : 'No tasks yet',
                  subtitle: hasQuery ? 'Try a different search term.' : 'Tap the + button to add your first task.',
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 100.h),
                sliver: SliverList.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskTile(
                      task: task,
                      onToggle: () => ref.read(taskProvider.notifier).toggleCompletion(task.id),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => AddEditTaskScreen(existingTask: task)),
                      ),
                      onDelete: () async {
                        try {
                          await ref.read(taskProvider.notifier).deleteTask(task.id);
                        } catch (_) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(content: Text('Could not delete the task.')));
                          }
                        }
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
        ),
        child: Icon(Icons.add_rounded, size: 26.sp),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final int remaining;

  const _TopBar({required this.remaining});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(color: AppColors.indigo, borderRadius: BorderRadius.circular(14.r)),
          child: Icon(Icons.task_alt_rounded, color: Colors.white, size: 22.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello there 👋', style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 2.h),
              Text(
                remaining == 0
                    ? 'All tasks done — nice work!'
                    : 'You have $remaining task${remaining == 1 ? '' : 's'} left today',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final TaskStats stats;

  const _ProgressCard({required this.stats});

  String get _encouragement {
    if (stats.total == 0) return 'Add your first task to get started.';
    if (stats.percent >= 1) return 'Everything is done. Great work today!';
    if (stats.percent >= 0.5) return "You're more than halfway there.";
    if (stats.percent > 0) return 'Good start — keep the momentum going.';
    return "Let's get moving on today's tasks.";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          ProgressRing(percent: stats.percent, completed: stats.completed, total: stats.total),
          SizedBox(height: 14.h),
          Text(_encouragement, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
