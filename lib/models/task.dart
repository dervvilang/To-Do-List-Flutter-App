class Task {
  final String? id;
  final String title;
  final String category;
  final bool isCompleted;
  final DateTime? reminderTime;

  Task({
    this.id,
    required this.title,
    required this.category,
    this.isCompleted = false,
    this.reminderTime,
  });

}
