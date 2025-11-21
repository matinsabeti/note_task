import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_task/database/note_database.dart';
import 'package:note_task/screens/categories_page.dart';
import 'package:note_task/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDarkMode = false;
  final List categoriesIcon = [
    Icons.work_rounded,
    Icons.school_rounded,
    Icons.home_rounded,
  ];
  final List categoriesName = ["Work", "Study", "Home"];

  @override
  Widget build(BuildContext context) {
    // note database
    final noteDatabase = context.watch<NoteDatabase>();
    noteDatabase.fetchNotes();

    return Scaffold(
      appBar: AppBar(title: const Text('Note Page')),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 100, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Dark Mode",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  CupertinoSwitch(
                    value: isDarkMode,
                    onChanged: (value) {
                      isDarkMode = !isDarkMode;
                      Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      ).toggleTheme();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: categoriesIcon.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: InkWell(
              onTap: () {
                // Handle category tap
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CategoriesPage(categoryName: categoriesName[index]),
                  ),
                );
              },
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(
                    context,
                  ).colorScheme.inversePrimary.withValues(alpha: 0.4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 12,
                  children: [
                    Icon(
                      categoriesIcon[index],
                      size: 36,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    Text(
                      categoriesName[index],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
