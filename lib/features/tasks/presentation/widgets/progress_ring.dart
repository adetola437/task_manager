import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/core/theme/app_theme.dart';

/// The "% done" ring on the dashboard. Two stacked `CircularProgressIndicator`s
/// (a full-track background + an animated foreground arc) rather than a
/// custom painter — same visual result, far less code to maintain.
class ProgressRing extends StatelessWidget {
  final double percent;
  final int completed;
  final int total;

  const ProgressRing({
    super.key,
    required this.percent,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final size = 128.w;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 10.w,
              strokeCap: StrokeCap.round,
              color: AppColors.track,
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: percent.clamp(0, 1)),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: value == 0 ? 0.001 : value,
                strokeWidth: 10.w,
                strokeCap: StrokeCap.round,
                backgroundColor: Colors.transparent,
                color: AppColors.indigo,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(percent * 100).round()}%',
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              SizedBox(height: 2.h),
              Text(
                total == 0 ? 'No tasks' : '$completed of $total',
                style: TextStyle(fontSize: 11.sp, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
