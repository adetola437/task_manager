import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/core/theme/app_theme.dart';
import 'package:task_manager/features/tasks/models/task.dart';

/// The gradient hero card. Surfaces one concrete next action instead of a
/// generic banner — "up next" is real data (oldest pending task), not a
/// decorative streak counter, so it stays honest about what the app
/// actually knows.
class UpNextCard extends StatelessWidget {
  final Task? task;
  final VoidCallback? onTap;

  const UpNextCard({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: InkWell(
        onTap: task == null ? null : onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.indigo, AppColors.indigoDeep],
            ),
          ),
          child: Stack(
            children: [
              // A soft decorative blob — the one intentional flourish on
              // this screen, kept subtle and confined to this card.
              Positioned(
                right: -30.w,
                top: -30.w,
                child: Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bolt_rounded, color: Colors.white.withOpacity(0.85), size: 18.sp),
                      SizedBox(width: 6.w),
                      Text(
                        'UP NEXT',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    task?.title ?? 'All caught up!',
                    style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    task == null
                        ? 'Nothing pending right now — add a task to get moving.'
                        : (task!.description.isEmpty ? 'No extra details added.' : task!.description),
                    style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12.5.sp),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (task != null) ...[
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tap to open',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18.sp),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
