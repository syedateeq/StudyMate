import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';

class TasksScreen extends StatefulWidget {
  final List<Task> tasks;
  final VoidCallback onTasksChanged;

  const TasksScreen({
    super.key,
    required this.tasks,
    required this.onTasksChanged,
  });

  @override
  State<TasksScreen> createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen> {
  final List<String> _categories = ['DSA', 'Flutter', 'College', 'Personal'];

  void showAddTaskDialog() {
    final nameController = TextEditingController();
    String selectedCategory = _categories.first;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              title: const Text('Add New Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Task Name',
                      hintText: 'Enter task name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.task_alt),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.category),
                    ),
                    items: _categories
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setDialogState(() {
                        selectedCategory = val!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Task name cannot be empty'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                    setState(() {
                      widget.tasks.add(Task(
                        title: name,
                        category: selectedCategory,
                      ));
                    });
                    widget.onTasksChanged();
                    Navigator.pop(ctx);
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final completed = widget.tasks.where((t) => t.isCompleted).length;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Tasks',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Stay organized and get things done.',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _miniStat('Total', '${widget.tasks.length}',
                          Icons.assignment, Colors.blue),
                      _miniStat('Done', '$completed', Icons.check_circle,
                          Colors.green),
                      _miniStat(
                          'Pending',
                          '${widget.tasks.length - completed}',
                          Icons.access_time,
                          Colors.orange),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Expanded(
            child: widget.tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.task_alt,
                            size: 64,
                            color:
                                colorScheme.onSurface.withValues(alpha: 0.2)),
                        const SizedBox(height: 12),
                        Text(
                          'No tasks yet.\nTap + to add one!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: widget.tasks.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        task: widget.tasks[index],
                        onChanged: (val) {
                          setState(() {
                            widget.tasks[index].isCompleted = val ?? false;
                          });
                          widget.onTasksChanged();
                        },
                        onDelete: () {
                          setState(() {
                            widget.tasks.removeAt(index);
                          });
                          widget.onTasksChanged();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: color),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: color.withValues(alpha: 0.7)),
        ),
      ],
    );
  }
}
