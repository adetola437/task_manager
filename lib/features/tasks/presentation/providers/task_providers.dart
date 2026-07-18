import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:task_manager/features/tasks/models/task.dart';
import 'package:task_manager/features/tasks/repository/task_repository.dart';
import 'package:task_manager/features/tasks/repository/task_repository_impl.dart';


final taskBoxProvider = Provider<Box<Task>>((ref) {
  throw UnimplementedError('taskBoxProvider must be overridden in main.dart after Hive.openBox is awaited.');
});


final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final box = ref.watch(taskBoxProvider);
  return TaskRepositoryImpl(box);
});

class TaskNotifier extends Notifier<List<Task>> {
  TaskRepository get _repository => ref.read(taskRepositoryProvider);

  @override
  List<Task> build() => _repository.getTasks();

  Future<void> addTask(String title, String description) async {
    await _repository.addTask(title, description);
    state = _repository.getTasks();
  }

  Future<void> updateTask(String id, String title, String description) async {
    await _repository.updateTask(id, title, description);
    state = _repository.getTasks();
  }

  Future<void> toggleCompletion(String id) async {
    await _repository.toggleCompletion(id);
    state = _repository.getTasks();
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    state = _repository.getTasks();
  }
}

final taskProvider = NotifierProvider<TaskNotifier, List<Task>>(TaskNotifier.new);

/// Current text in the search bar — a plain `StateProvider`, kept separate
/// from the task list so typing never touches Hive.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Search-filtered view of the task list. A normal derived `Provider` —
/// no `AsyncValue` needed since `taskProvider`'s state is already a plain
/// `List<Task>`.
final filteredTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  if (query.isEmpty) return tasks;
  return tasks
      .where((t) => t.title.toLowerCase().contains(query) || t.description.toLowerCase().contains(query))
      .toList();
});


class TaskStats {
  final int total;
  final int completed;

  const TaskStats({required this.total, required this.completed});

  int get remaining => total - completed;
  double get percent => total == 0 ? 0 : completed / total;
}

final taskStatsProvider = Provider<TaskStats>((ref) {
  final tasks = ref.watch(taskProvider);
  final completed = tasks.where((t) => t.isCompleted).length;
  return TaskStats(total: tasks.length, completed: completed);
});

/// The task that's been waiting longest without being done — shown on the
/// "Up next" hero card.
final upNextTaskProvider = Provider<Task?>((ref) {
  final tasks = ref.watch(taskProvider);
  final pending = tasks.where((t) => !t.isCompleted).toList()
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  return pending.isEmpty ? null : pending.first;
});
