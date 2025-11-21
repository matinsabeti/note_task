import 'package:flutter/material.dart';
import 'package:note_task/database/note.dart';
import 'package:note_task/database/note_database.dart';
import 'package:note_task/screens/new_note_page.dart';
import 'package:note_task/screens/note_page.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {
  final String categoryName;
  const CategoriesPage({super.key, required this.categoryName});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();
    final List<Note> categoriedNotes = noteDatabase.currentNotes
        .where((note) => note.category == widget.categoryName)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName} Notes'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NewNotePage(categoryName: widget.categoryName),
                ),
              );
            },
            icon: Icon(Icons.add_rounded, size: 28),
          ),
          Padding(padding: EdgeInsets.only(right: 1)),
        ],
      ),
      body: Center(
        child: categoriedNotes.isNotEmpty
            ? ListView.builder(
                itemCount: categoriedNotes.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            NotePage(noteId: categoriedNotes[index].id),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Text(
                            categoriedNotes[index].title,
                            style: TextStyle(fontSize: 16),
                            softWrap: true,
                          ),
                          Expanded(child: SizedBox()),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                categoriedNotes[index].isCompleted
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                color: categoriedNotes[index].isCompleted
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              const SizedBox(height: 4),
                              Icon(
                                categoriedNotes[index].isDraft
                                    ? Icons.drafts_rounded
                                    : Icons.mark_email_read_rounded,
                                color: categoriedNotes[index].isDraft
                                    ? Colors.orange
                                    : Colors.grey,
                              ),
                            ],
                          ),
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
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                      children: [
                                        const TextSpan(
                                          text:
                                              'Are you sure you want to delete ',
                                        ),
                                        TextSpan(
                                          text: categoriedNotes[index].title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const TextSpan(text: ' note?'),
                                      ],
                                    ),
                                  ),

                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
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
                                        await noteDatabase.deleteNote(
                                          categoriedNotes[index].id,
                                        );
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop(true);
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Center(
                child: Text(
                  "There is no note in ${widget.categoryName} category.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
      ),
    );
  }
}
