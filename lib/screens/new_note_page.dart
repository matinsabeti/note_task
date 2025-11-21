// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:note_task/database/note.dart';
import 'package:note_task/database/note_database.dart';
import 'package:provider/provider.dart';

class NewNotePage extends StatefulWidget {
  final String categoryName;
  const NewNotePage({super.key, required this.categoryName});

  @override
  State<NewNotePage> createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final Note currentNote = Note();

  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close_rounded, size: 28),
        ),
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
                noteDatabase.addNote(
                  category: widget.categoryName,
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
