import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/task_provider.dart';
import 'package:to_do_app/viewmodels/task_viewmodel.dart';
import 'tasks_list_screen.dart';

class NewTaskAddScreen extends StatefulWidget {
  @override
  _NewTaskAddScreenState createState() => _NewTaskAddScreenState();
}

class _NewTaskAddScreenState extends State<NewTaskAddScreen> {
  // Добавляем состояние для выбранной категории
  String? _selectedCategory;
  final TextEditingController _nameController = TextEditingController();
  DateTime? _selectedTime;


  Future<void> _pickTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _selectedTime != null
          ? TimeOfDay.fromDateTime(_selectedTime!)
          : TimeOfDay.now(),
    );
    if (time != null) {
      final now = DateTime.now();
      setState(() {
        // Формируем DateTime с выбранным временем, оставляя текущую дату
        _selectedTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final taskViewModel = TaskViewModel(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить задачу'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15,),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Название задачи',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: ['Работа', 'Учёба', 'Личное']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Категория',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedTime != null
                          ? 'Время напоминания: ${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                          : 'Время напоминания не выбрано',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: _pickTime,
                  ),
                ],
              ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_nameController.text.isNotEmpty &&
                      _selectedCategory != null) {
                    await taskViewModel.createTask(
                      _nameController.text,
                      _selectedCategory!,
                      reminderTime: _selectedTime,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Сохранить'))

            /*
            NameOfTask(),
            SizedBox(height: 15,),
            ListOfCategories(
              selectedCategory: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            SizedBox(height: 15,),
            SelectTime(),
            SizedBox(height: 15,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TasksListScreen()),
                );
              },
              child: const Text('Сохранить'),
            ),*/
          ],
        ),
      ),
    );
  }
}

class SelectTime extends StatelessWidget {
  const SelectTime({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Выберите время напоминания'), // Добавляем текст для отображения
      ],
    );
  }
}

class ListOfCategories extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onChanged;

  const ListOfCategories({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedCategory, // Указываем текущее значение
      items: ['Category 1', 'Category 2', 'Category 3']
          .map((category) => DropdownMenuItem(
                value: category, // Задаем значение для каждого элемента
                child: Text(category),
              ))
          .toList(),
      onChanged: onChanged, // Обновляем состояние при выборе
    );
  }
}

class NameOfTask extends StatelessWidget {
  const NameOfTask({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Название задачи', // Добавляем подпись для поля ввода
        border: OutlineInputBorder(),
      ),
    );
  }
}
