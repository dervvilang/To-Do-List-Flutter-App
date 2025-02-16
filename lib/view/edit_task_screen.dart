import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/providers/task_provider.dart';
import 'package:to_do_app/viewmodels/task_viewmodel.dart';
import 'tasks_list_screen.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _nameController;
  String? _selectedCategory;
  DateTime? _selectedTime;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task.title);
    _selectedCategory = widget.task.category;
    _selectedTime = widget.task.reminderTime;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

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
        _selectedTime =
            DateTime(now.year, now.month, now.day, time.hour, time.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final taskViewModel = TaskViewModel(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать задачу'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Название задачи',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  if (_nameController.text.isNotEmpty &&
                      _selectedCategory != null) {
                    Task updatedTask = Task(
                      id: widget.task.id,
                      title: _nameController.text,
                      category: _selectedCategory!,
                      isCompleted: widget.task.isCompleted,
                      reminderTime: _selectedTime,
                    );
                    await taskViewModel.editTask(updatedTask);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Сохранить изменения'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
