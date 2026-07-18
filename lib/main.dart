import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/core/constants/app_constants.dart';
import 'package:task_manager/core/theme/app_theme.dart';
import 'package:task_manager/features/splash/presentation/splash_screen.dart';
import 'package:task_manager/features/tasks/models/task.dart';
import 'package:task_manager/features/tasks/presentation/providers/task_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive setup happens once, here, before runApp.
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  final taskBox = await Hive.openBox<Task>(AppConstants.tasksBoxName);

  runApp(
    ProviderScope(
      overrides: [
        // The only override the app needs — taskProvider reads the box
        // through this, so everything downstream just works.
        taskBoxProvider.overrideWithValue(taskBox),
      ],
      child: const TaskManagerApp(),
    ),
  );
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Design size matches a standard mid-size phone (390x844, iPhone 12/13
    // class). ScreenUtilInit scales every `.w`/`.h`/`.sp`/`.r` call relative
    // to this, so spacing and text stay proportionally consistent across
    // small and large screens instead of hardcoded pixel values.
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Task Manager',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          home: const SplashScreen(),
        );
      },
    );
  }
}
