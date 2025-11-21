// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:note_task/database/note.dart';
import 'package:note_task/database/note_database.dart';
import 'package:provider/provider.dart';

class NotePage extends StatefulWidget {
  final int noteId;
  const NotePage({super.key, required this.noteId});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late Note? currentNote;
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final noteDatabase = context.read<NoteDatabase>();
      currentNote = noteDatabase.fetchNoteById(widget.noteId);

      // Set initial text ONLY once
      _contentController.text = currentNote?.content ?? "";
      _titleController.text = currentNote?.title ?? "";

      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();
    currentNote = noteDatabase.fetchNoteById(widget.noteId);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close_rounded, size: 28),
        ),
        actions: [
          // Delete icon
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              return showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Deletion'),
                  content: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        const TextSpan(
                          text: 'Are you sure you want to delete ',
                        ),
                        TextSpan(
                          text: currentNote?.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' note?'),
                      ],
                    ),
                  ),

                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.inversePrimary,
                      ),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        // do delete here
                        await noteDatabase.deleteNote(currentNote!.id);
                        Navigator.of(context).pop(true);
                        Navigator.of(context).pop(true);
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
          Padding(padding: EdgeInsets.only(right: size.width * 0.04)),
        ],
      ),
      extendBodyBehindAppBar: false,
      extendBody: true,
      body: Padding(
        padding: EdgeInsets.only(left: size.width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.03),
            SizedBox(
              width: size.width * 0.9,
              child: TextField(
                controller: _titleController,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
                maxLines: 1,
                cursorColor: Theme.of(context).colorScheme.inversePrimary,

                decoration: InputDecoration.collapsed(
                  hintText: 'Enter your title here',

                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: Theme.of(
                      context,
                    ).colorScheme.inversePrimary.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),

            Container(
              width: size.width * 0.9,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(
                  context,
                ).colorScheme.inversePrimary.withValues(alpha: 0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _contentController,
                  style: TextStyle(fontSize: 18),
                  maxLines: null,
                  cursorColor: Theme.of(context).colorScheme.inversePrimary,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Enter your note here',

                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Theme.of(
                        context,
                      ).colorScheme.inversePrimary.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            ElevatedButton(
              onPressed: () {
                noteDatabase.updateNote(
                  id: widget.noteId,
                  title: _titleController.text,
                  content: _contentController.text,
                );
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text(
                'SAVE',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
