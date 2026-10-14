import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onChanged,
    required this.onDelete,
  });

  Color _categoryColor(String category) {
    switch (category) {
      case 'DSA':
        return Colors.deepPurple;
      case 'Flutter':
        return Colors.blue;
      case 'College':
        return Colors.orange;
      case 'Personal':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final catColor = _categoryColor(task.category);

    return Card(
      elevation: task.isCompleted ? 0 : 1,
      color: task.isCompleted
          ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
          : colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: onChanged,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          activeColor: colorScheme.primary,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted
                ? colorScheme.onSurface.withValues(alpha: 0.45)
                : colorScheme.onSurface,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: catColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                task.category,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: catColor,
                ),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: colorScheme.error, size: 20),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
