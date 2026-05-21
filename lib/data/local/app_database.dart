import 'package:drift/drift.dart';
import 'package:safevault/data/models/note.dart' as model;

import 'connection/shared.dart';

part 'app_database.g.dart';

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DriftDatabase(tables: [Notes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  @override
  int get schemaVersion => 1;

  // ── CRUD helpers (usados por el repository) ──

  Future<List<model.Note>> getAllNotes() async {
    final query = await (select(notes)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).get();
    return query.map((row) => row.toNote()).toList();
  }

  Future<int> insertNote(NotesCompanion note) => into(notes).insert(note);

  Future<bool> updateNote(NotesCompanion note) => update(notes).replace(note);

  Future<int> deleteNote(int id) => (delete(notes)..where((t) => t.id.equals(id))).go();

  Future<model.Note?> getNoteById(int id) async {
    final row = await (select(notes)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row?.toNote();
  }
}

extension NoteExtension on model.Note {
  NotesCompanion toCompanion() {
    return NotesCompanion(
      id: id == 0 ? const Value.absent() : Value(id),
      title: Value(title),
      content: Value(content),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
}

extension NoteDataExtension on Note {
  model.Note toNote() {
    return model.Note(
      id: id,
      title: title,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}