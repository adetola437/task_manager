/// Central place for constant values used across the app.
///
/// Keeping box names / typeIds here avoids "magic string" typos scattered
/// across the app, and makes it obvious where to look when adding a new
/// Hive box in the future.
class AppConstants {
  AppConstants._();

  /// Name of the Hive box that stores [Task] objects.
  static const String tasksBoxName = 'tasks_box';

  /// Hive typeId for the Task adapter. Must be unique per app and must
  /// never be reused for a different model once shipped, otherwise
  /// existing user data on disk will be misread after an update.
  static const int taskTypeId = 0;
}
