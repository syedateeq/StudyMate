class Task {
  String title;
  String category;
  bool isCompleted;

  Task({
    required this.title,
    required this.category,
    this.isCompleted = false,
  });
}
