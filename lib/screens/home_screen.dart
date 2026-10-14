import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/stat_card.dart';
import '../widgets/quick_action_card.dart';

class HomeScreen extends StatelessWidget {
  final List<Task> tasks;
  final Function(int) onNavigate;

  const HomeScreen({
    super.key,
    required this.tasks,
    required this.onNavigate,
  });

  static const _weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  static const _months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _formattedDate() {
    final now = DateTime.now();
    return '${_weekdays[now.weekday - 1]}, ${_months[now.month - 1]} ${now.day}, ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final completed = tasks.where((t) => t.isCompleted).length;
    final total = tasks.length;
    final pending = total - completed;
    final progress = total > 0 ? completed / total : 0.0;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(
              '${_greeting()}, Ateeq 👋',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Ready to make progress today?',
              style: TextStyle(
                fontSize: 15,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formattedDate(),
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurface.withValues(alpha: 0.45),
              ),
            ),

            const SizedBox(height: 24),

            // Progress Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withValues(alpha: 0.75),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today's Progress",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.white24,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _progressStat('$total Tasks', Icons.list_alt),
                        const SizedBox(width: 16),
                        _progressStat(
                            '$completed Completed', Icons.check_circle_outline),
                        const SizedBox(width: 16),
                        _progressStat('$pending Pending', Icons.pending_actions),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Today's Tasks Stats
            Row(
              children: [
                StatCard(
                  label: 'Total',
                  value: '$total',
                  icon: Icons.assignment,
                  color: Colors.blue,
                ),
                const SizedBox(width: 10),
                StatCard(
                  label: 'Done',
                  value: '$completed',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
                const SizedBox(width: 10),
                StatCard(
                  label: 'Pending',
                  value: '$pending',
                  icon: Icons.access_time_filled,
                  color: Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Today's Tasks
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Tasks",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => onNavigate(1),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...tasks.take(4).map((task) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        task.isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: task.isCompleted
                            ? Colors.green
                            : colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted
                              ? colorScheme.onSurface.withValues(alpha: 0.45)
                              : null,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          task.category,
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  ),
                )),

            const SizedBox(height: 28),

            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                QuickActionCard(
                  icon: Icons.add_task,
                  label: 'Add Task',
                  color: Colors.blue,
                  onTap: () => onNavigate(1),
                ),
                const SizedBox(width: 12),
                QuickActionCard(
                  icon: Icons.timer,
                  label: 'Start Timer',
                  color: Colors.deepPurple,
                  onTap: () => onNavigate(2),
                ),
                const SizedBox(width: 12),
                QuickActionCard(
                  icon: Icons.note_add,
                  label: 'Add Note',
                  color: Colors.teal,
                  onTap: () => onNavigate(3),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Motivational Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    colorScheme.tertiaryContainer,
                    colorScheme.secondaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      '"Small progress every day leads to big results."',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _progressStat(String text, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white70),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }
}
