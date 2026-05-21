import 'package:safevault/data/models/note.dart' as model;
import 'package:safevault/data/local/app_database.dart';

class NoteRepository {
  final AppDatabase _db;

  NoteRepository(this._db);

  /// Obtiene todas las notas ordenadas por fecha de actualización (mas reciente primero)
  Future<List<model.Note>> getAllNotes() => _db.getAllNotes();

  /// Añade una nota nueva
  Future<model.Note> addNote(model.Note note) async {
    final companion = note.toCompanion();
    final generatedId = await _db.insertNote(companion);

    // Devolvemos la nota con el ID real generado por la base de datos
    return note.copyWith(id: generatedId);
  }

  /// Actualiza una nota existente
  Future<void> updateNote(model.Note note) async {
    await _db.updateNote(note.toCompanion());
  }

  /// Elimina una nota por su ID
  Future<void> deleteNote(int id) async {
    await _db.deleteNote(id);
  }

  /// Obtiene una nota por ID (null si no existe)
  Future<model.Note?> getNoteById(int id) => _db.getNoteById(id);
}