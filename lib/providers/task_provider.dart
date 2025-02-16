import 'package:flutter/material.dart';
import 'package:to_do_app/services/database_service.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final List<Task> _tasks = [];
  String _selectedCategory = 'Все';

  String get selectedCategory => _selectedCategory;

  List<Task> get tasks => List.unmodifiable(_tasks);

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> fetchTasks() async {
    try {
      List<Task> fetchedTasks = await _databaseService.fetchTasks();
      _tasks.clear();
      _tasks.addAll(fetchedTasks);
      notifyListeners();
    } catch (e) {
      print('Ошибка при загрузке задач: $e');
    }
  }

  Future<void> addTask(Task task) async {
    try {
      String id = await _databaseService.addTask(task);

      Task newTask = Task(
        id: id,
        title: task.title,
        category: task.category,
        isCompleted: task.isCompleted,
        reminderTime: task.reminderTime,
      );

      _tasks.add(newTask);

      notifyListeners();
    } catch (e) {
      print('Ошибка при добавлении задачи: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      if (task.id == null) {
        print('Невозможно обновить задачу без ID');
      }

      await _databaseService.updateTask(task);
      int index = _tasks.indexWhere((t) => t.id == task.id);

      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
        print('Задача успешно обновлена в локальном списке');
      } else
        print('Задача с id ${task.id} не найдена в локальном списке');
    } catch (e) {
      print('Ошибка при обновлении задачи: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _databaseService.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      print('Ошибка при удалении задачи: $e');
    }
  }
}
