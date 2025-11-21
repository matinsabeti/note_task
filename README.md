# 📝 note_task

A simple and modern note‑taking application built with **Flutter**, **Isar**, and **Provider**.

---

## ✨ Features

* 🗒️ Create and edit notes
* ⚡ Ultra‑fast offline storage via **Isar Database**
* 🗂️ Categorized notes (Apartment, Workplace, Garden Flower, Toxic Flower)
* 🔄 State management using **Provider**
* 🗑️ Delete notes with confirmation dialog
* ✍️ Text editing powered by `TextEditingController`
* 📌 Supports `isDraft` and `isCompleted` states

---

## 📂 Project Structure

```
lib/
 ├── database/
 │     ├── note.dart
 │     └── note_database.dart
 ├── pages/
 │     └── note_page.dart
 └── main.dart
```

---

## 🚀 Getting Started

### 1️⃣ Clone the repository

```bash
git clone https://github.com/matinsabeti/note_task.git
cd note_task
```

### 2️⃣ Install dependencies

```bash
flutter pub get
```

### 3️⃣ Run the application

```bash
flutter run
```

---

## 🗄️ Working with Isar

If your models use Isar annotations, run code generation:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🧩 Implementation Notes

### 🔹 Setting Initial Value in `TextFormField`

Do **not** use `initialValue` when using a controller.
Instead, set the value like this:

```dart
@override
void didChangeDependencies() {
  if (!_initialized) {
    final noteDatabase = context.read<NoteDatabase>();
    currentNote = noteDatabase.fetchNoteById(widget.noteId);

    _textEditingController.text = currentNote?.content ?? "";
    _initialized = true;
  }
  super.didChangeDependencies();
}
```

### 🔹 Preventing Overflow in AlertDialog

Avoid placing long text inside a `Row` (it causes overflow).
Use `Text` or `RichText` instead:

```dart
content: Text('Are you sure you want to delete this note?');
```

### 🔹 Update Only Provided Fields

```dart
if (title != null) note.title = title;
if (content != null) note.content = content;
```

---

## 🙌 Contributing

* ⭐ Star the repository
* 🐞 Report issues
* 🔧 Submit pull requests

---

## 📄 License

This project is licensed under the **MIT License**.
