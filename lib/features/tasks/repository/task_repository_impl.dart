import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:task_manager/features/tasks/models/task.dart';
import 'package:task_manager/features/tasks/repository/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final Box<Task> _box;
  final Uuid _uuid;

  TaskRepositoryImpl(this._box, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  @override
  List<Task> getTasks() {
    final tasks = _box.values.toList();
    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return tasks;
  }

  @override
  Future<Task> addTask(String title, String description) async {
    final task = Task(
      id: _uuid.v4(),
      title: title.trim(),
      description: description.trim(),
      isCompleted: false,
      createdAt: DateTime.now(),
    );
    await _box.put(task.id, task);
    return task;
  }

  @override
  Future<void> updateTask(String id, String title, String description) async {
    final task = _box.get(id);
    if (task == null) return;
    task.title = title.trim();
    task.description = description.trim();
    await task.save(); // HiveObject knows which box it came from
  }

  @override
  Future<void> toggleCompletion(String id) async {
    final task = _box.get(id);
    if (task == null) return;
    task.isCompleted = !task.isCompleted;
    await task.save();
  }

  @override
  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }
}
