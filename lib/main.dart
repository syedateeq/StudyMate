import 'package:flutter/material.dart';
import 'models/task.dart';
import 'models/note.dart';
import 'screens/home_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/timer_screen.dart';
import 'screens/notes_screen.dart';

void main() {
  runApp(const StudyMateApp());
}

class StudyMateApp extends StatelessWidget {
  const StudyMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6750A4),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6750A4),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final GlobalKey<TasksScreenState> _tasksKey = GlobalKey<TasksScreenState>();
  final GlobalKey<NotesScreenState> _notesKey = GlobalKey<NotesScreenState>();

  final List<Task> _tasks = [
    Task(title: 'Complete DSA Assignment', category: 'DSA'),
    Task(title: 'Study Flutter Widgets', category: 'Flutter', isCompleted: true),
    Task(title: 'Revise Computer Networks', category: 'College'),
    Task(title: 'Practice 2 LeetCode Problems', category: 'DSA', isCompleted: true),
    Task(title: 'Prepare UI Lab', category: 'College'),
  ];

  final List<Note> _notes = [
    Note(
      title: 'Flutter Basics',
      content: 'Flutter uses widgets to build the user interface.',
    ),
    Note(
      title: 'DSA Revision',
      content: 'Dynamic Programming = Recursion + Memoization/Tabulation.',
    ),
    Note(
      title: 'CN',
      content: 'TCP provides reliable and ordered communication.',
    ),
  ];

  void _navigateTo(int index) {
    setState(() => _currentIndex = index);
  }

  void _onDataChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(tasks: _tasks, onNavigate: _navigateTo),
      TasksScreen(
        key: _tasksKey,
        tasks: _tasks,
        onTasksChanged: _onDataChanged,
      ),
      const TimerScreen(),
      NotesScreen(
        key: _notesKey,
        notes: _notes,
        onNotesChanged: _onDataChanged,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      floatingActionButton: _buildFab(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _navigateTo,
        animationDuration: const Duration(milliseconds: 400),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Timer',
          ),
          NavigationDestination(
            icon: Icon(Icons.note_alt_outlined),
            selectedIcon: Icon(Icons.note_alt),
            label: 'Notes',
          ),
        ],
      ),
    );
  }

  Widget? _buildFab() {
    if (_currentIndex == 1) {
      return FloatingActionButton(
        onPressed: () => _tasksKey.currentState?.showAddTaskDialog(),
        child: const Icon(Icons.add),
      );
    }
    if (_currentIndex == 3) {
      return FloatingActionButton(
        onPressed: () => _notesKey.currentState?.showAddNoteDialog(),
        child: const Icon(Icons.add),
      );
    }
    return null;
  }
}
