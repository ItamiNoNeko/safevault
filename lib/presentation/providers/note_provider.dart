import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safevault/domain/database_provider.dart';
import 'package:safevault/domain/repositories/note_repository.dart';
import 'package:safevault/data/models/note.dart' as model;

// Repository
final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return NoteRepository(db);
});

// Notifier asincrono
class NotesNotifier extends AsyncNotifier<List<model.Note>> {
  late final NoteRepository _repository;

  @override
  Future<List<model.Note>> build() async {
    _repository = ref.watch(noteRepositoryProvider);
    return await _repository.getAllNotes();
  }

  // Metodo para añadir una nota nueva
  Future<void> addNote(model.Note note) async {
    final savedNote = await _repository.addNote(note);
    state = AsyncData([...?state.value, savedNote]);
  }

  // Metodo para actualizar una nota existente
  Future<void> updateNote(model.Note updatedNote) async {
    await _repository.updateNote(updatedNote);
    state = AsyncData(
      state.value?.map((n) => n.id == updatedNote.id ? updatedNote : n).toList() ?? [],
    );
  }

  // Metodo para eliminar una nota
  Future<void> deleteNote(int id) async {
    await _repository.deleteNote(id);
    state = AsyncData(state.value?.where((n) => n.id != id).toList() ?? []);
  }

  // Metodo para obtener una nota por ID
  Future<model.Note?> getNoteById(int id) async {
    return await _repository.getNoteById(id);
  }
}

/// Provider principal que usan las pantallas
final notesProvider = AsyncNotifierProvider<NotesNotifier, List<model.Note>>(
  NotesNotifier.new,
);