import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/providers/task_provider.dart';
import 'package:to_do_app/view/edit_task_screen.dart';
import 'package:to_do_app/viewmodels/task_viewmodel.dart';
import 'new_task_add_screen.dart';

class TasksListScreen extends StatefulWidget {
  const TasksListScreen({super.key});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  late TaskViewModel taskViewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskViewModel = TaskViewModel(taskProvider);
    taskViewModel.loadTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your To-Do List',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          CategoriesList(),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, _) {
                final currentTasks = taskViewModel.currentTasks;
                final completedTasks = taskViewModel.completedTasks;
                return ListView(
                  children: [
                    CurrentTasks(tasks: currentTasks),
                    CompletedTasks(tasks: completedTasks),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewTaskAddScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CompletedTasks extends StatelessWidget {
  final List<Task> tasks;

  const CompletedTasks({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Завершенные задачи'),
      children: tasks.isNotEmpty
          ? tasks.map((task) {
              return Dismissible(
                key: ValueKey(task.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) async {
                  await Provider.of<TaskProvider>(context, listen: false)
                      .deleteTask(task.id!);
                },
                child: ListTile(
                  title: Text(
                    task.title,
                    style:
                        const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.black87),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Категория: ${task.category}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black45),
                      ),
                      if (task.reminderTime != null)
                        Text(
                          "Время напоминания: ${task.reminderTime!.hour}:${task.reminderTime!.minute.toString().padLeft(2, '0')}",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (bool? newValue) {
                      final updatedTask = Task(
                        id: task.id,
                        title: task.title,
                        category: task.category,
                        isCompleted: newValue ?? false,
                        reminderTime: task.reminderTime,
                      );
                      Provider.of<TaskProvider>(context, listen: false)
                          .updateTask(updatedTask);
                    },
                  ),
                ),
              );
            }).toList()
          : [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Center(child: Text('Нет завершенных задач')),
              )
            ],
    );
  }
}

class CurrentTasks extends StatelessWidget {
  final List<Task> tasks;

  const CurrentTasks({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: const Text('Текущие задачи'),
      children: tasks.isNotEmpty
          ? tasks.map((task) {
              return Dismissible(
                key: ValueKey(task.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) async {
                  await Provider.of<TaskProvider>(context, listen: false)
                      .deleteTask(task.id!);
                },
                child: ListTile(
                  title: Text(task.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Категория: ${task.category}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black45),
                      ),
                      if (task.reminderTime != null)
                        Text(
                          "Время напоминания: ${task.reminderTime!.hour}:${task.reminderTime!.minute.toString().padLeft(2, '0')}",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (bool? newValue) {
                      final updatedTask = Task(
                        id: task.id,
                        title: task.title,
                        category: task.category,
                        isCompleted: newValue ?? false,
                        reminderTime: task.reminderTime,
                      );
                      Provider.of<TaskProvider>(context, listen: false)
                          .updateTask(updatedTask);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTaskScreen(task: task),
                      ),
                    );
                  },
                ),
              );
            }).toList()
          : [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Center(child: Text('Нет текущих задач')),
              )
            ],
    );
  }
}

class CategoriesList extends StatelessWidget {
  const CategoriesList({Key? key}) : super(key: key);

  final List<String> categories = const ['Все', 'Работа', 'Учёба', 'Личное'];

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              taskProvider.setSelectedCategory(category);
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: taskProvider.selectedCategory == category
                    ? Colors.pink[200]
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: taskProvider.selectedCategory == category
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
