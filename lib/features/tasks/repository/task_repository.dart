import 'package:task_manager/features/tasks/models/task.dart';


abstract interface class TaskRepository {

  List<Task> getTasks();

  Future<Task> addTask(String title, String description);

  Future<void> updateTask(String id, String title, String description);

  Future<void> toggleCompletion(String id);

  Future<void> deleteTask(String id);
}
