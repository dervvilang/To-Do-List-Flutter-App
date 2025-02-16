import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/task_provider.dart';
import 'package:to_do_app/themes/light_theme.dart';
import 'package:to_do_app/view/tasks_list_screen.dart'; 

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) { 
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ToDoApp', 
        theme: lightTheme, // Убедитесь, что lightTheme определен
        home: const TasksListScreen(), // Убедитесь, что TasksListScreen существует
      ),
    );
  }
}