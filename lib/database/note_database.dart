import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';
import 'package:note_task/database/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;
  // I N I T I A L I Z E - T H E - D A T A B A S E
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  // List of Notes
  List<Note> currentNotes = [];

  // Add a Note
  Future<int> addNote({
    required String title,
    required String content,
    required String category,
    bool isDraft = false,
    bool isCompleted = false,
  }) async {
    final newNote = Note()
      ..title = title
      ..content = content
      ..category = category
      ..isDraft = isDraft
      ..isCompleted = isCompleted
      ..createdAt = DateTime.now();

    final id = await isar.writeTxn(() async {
      return await isar.notes.put(newNote); // returns the ID
    });
    await fetchNotes();
    return id;
  }

  // R E A D - notes from db
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes
        .where()
        .sortByCreatedAtDesc()
        .findAll();
    currentNotes = fetchedNotes.map((n) => n).toList();
    notifyListeners();
  }

  // U P D A T E - a note in db
  Future<void> updateNote(
    int id,
    String title,
    String content,
    String category,
    bool isDraft,
    bool isCompleted,
  ) async {
    final note = await isar.notes.get(id);
    if (note != null) {
      note.title = title;
      note.content = content;
      note.category = category;
      note.isDraft = isDraft;
      note.isCompleted = isCompleted;
      await isar.writeTxn(() => isar.notes.put(note));
      await fetchNotes();
    }
  }

  // D E L E T E - a note from db
  Future<void> deleteNote(int id) async {
    final note = await isar.notes.get(id);
    if (note != null) {
      await isar.writeTxn(() => isar.notes.delete(note.id));
      await fetchNotes();
    }
  }

  Future<void> getNotesByCategory(String categoryName) async {
    List<Note> categoryNotes = await isar.notes
        .filter()
        .categoryEqualTo(categoryName)
        .findAll();
    currentNotes = categoryNotes;
  }
}
