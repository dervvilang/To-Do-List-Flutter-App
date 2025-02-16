import 'package:to_do_app/providers/task_provider.dart';
import '../models/task.dart';

class TaskViewModel {
  final TaskProvider _taskProvider;

  TaskViewModel(this._taskProvider);

  String get selectedCategory => _taskProvider.selectedCategory;

  void setSelectedCategory(String category) {
    _taskProvider.setSelectedCategory(category);
  }

  Future<void> loadTask() async {
    await _taskProvider.fetchTasks();
  }

  Future<void> createTask(String title, String category, {DateTime? reminderTime}) async {
    Task newTask = Task(
      title: title,
      category: category,
      reminderTime: reminderTime,
    );
    await _taskProvider.addTask(newTask);
  }

  Future<void> editTask(Task task) async {
    await _taskProvider.updateTask(task);
  }

  Future<void> removeTask(String taskId) async {
    await _taskProvider.deleteTask(taskId);
  }

  List<Task> get currentTasks {
    final allCurrent = _taskProvider.tasks.where((task) => !task.isCompleted).toList();
    if (selectedCategory == 'Все') return allCurrent;
    return allCurrent.where((task) => task.category == selectedCategory).toList();
  }

  List<Task> get completedTasks {
    final allCompleted = _taskProvider.tasks.where((task) => task.isCompleted).toList();
    if (selectedCategory == 'Все') return allCompleted;
    return allCompleted.where((task) => task.category == selectedCategory).toList();
  }
}