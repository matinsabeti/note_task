import 'package:flutter/material.dart';
import 'package:note_task/database/note.dart';

class CategoriesPage extends StatefulWidget {
  final String categoryName;
  final List<Note> notes;
  const CategoriesPage({
    super.key,
    required this.categoryName,
    required this.notes,
  });

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.categoryName} Notes')),
      body: const Center(child: Text('Categories Page Content')),
    );
  }
}
