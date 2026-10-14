import 'package:flutter/material.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';

class NotesScreen extends StatefulWidget {
  final List<Note> notes;
  final VoidCallback onNotesChanged;

  const NotesScreen({
    super.key,
    required this.notes,
    required this.onNotesChanged,
  });

  @override
  State<NotesScreen> createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {
  void showAddNoteDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text('Add New Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter note title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Content',
                  hintText: 'Enter note content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Icon(Icons.notes),
                  ),
                ),
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
                final title = titleController.text.trim();
                final content = contentController.text.trim();
                if (title.isEmpty || content.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Title and content cannot be empty'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                setState(() {
                  widget.notes.add(Note(title: title, content: content));
                });
                widget.onNotesChanged();
                Navigator.pop(ctx);
              },
              child: const Text('Add Note'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Notes',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Keep your important study points here.',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: widget.notes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.note_alt_outlined,
                            size: 64,
                            color:
                                colorScheme.onSurface.withValues(alpha: 0.2)),
                        const SizedBox(height: 12),
                        Text(
                          'No notes yet.\nTap + to add one!',
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
                    itemCount: widget.notes.length,
                    itemBuilder: (context, index) {
                      return NoteCard(
                        note: widget.notes[index],
                        onDelete: () {
                          setState(() {
                            widget.notes.removeAt(index);
                          });
                          widget.onNotesChanged();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
