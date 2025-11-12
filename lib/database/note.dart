import 'package:isar/isar.dart';

part 'note.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement;
  String title = "";
  String content = "";
  String category = "";
  bool isDraft = false;
  bool isCompleted = false;
  DateTime createdAt = DateTime.now();
}
