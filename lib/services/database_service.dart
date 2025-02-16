import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class DatabaseService {
  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  Map<String, dynamic> taskToMap(Task task) {
    return {
      'title': task.title,
      'category': task.category,
      'isCompleted': task.isCompleted,
      'reminderTime': task.reminderTime != null
          ? task.reminderTime!.toIso8601String()
          : null,
    };
  }

  Future<String> addTask(Task task) async {
    try {
      DocumentReference docRef = await tasksCollection.add(taskToMap(task));
      print("Задача добавлена с id: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      print('Ошибка при добавлении задания: $e');
      rethrow;
    }
  }

  Future<List<Task>> fetchTasks() async {
    try {
      QuerySnapshot snapshot = await tasksCollection.get();
      List<Task> tasks = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Task(
          id: doc.id,
          title: data['title'] ?? '',
          category: data['category'] ?? '',
          isCompleted: data['isCompleted'] ?? false,
          reminderTime: data['reminderTime'] != null
              ? DateTime.parse(data['reminderTime'])
              : null,
        );
      }).toList();
      return tasks;
    } catch (e) {
      print('Ошибка при получении задачи: $e');
      return [];
    }
  }

  Future<void> updateTask(Task task) async {
    if (task.id == null) {
      print('Невозможно обновить задачу без идентификатора');
      return;
    }
    try {
      await tasksCollection.doc(task.id).update(taskToMap(task));
      print('Задача обновлена успешно');
    } catch (e) {
      print('Ошибка при обновлении задачи: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await tasksCollection.doc(taskId).delete();
      print('Задача удалена успешно');
    } catch (e) {
      print('Ошибка при удалении задачи: $e');
    }
  }
}