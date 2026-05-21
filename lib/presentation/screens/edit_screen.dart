import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:safevault/presentation/providers/note_provider.dart';
import 'package:safevault/data/models/note.dart';

// Pantalla para editar una nota existente
class EditScreen extends ConsumerStatefulWidget {
  final int noteId;

  const EditScreen({super.key, required this.noteId});

  @override
  ConsumerState<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends ConsumerState<EditScreen> {
  TextEditingController? _titleController;
  TextEditingController? _contentController;
  Note? _originalNote;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController?.dispose();
    _contentController?.dispose();
    super.dispose();
  }

  void _save() {
    final notifier = ref.read(notesProvider.notifier);
    final updatedNote = _originalNote!.copyWith(
      title: _titleController!.text.trim(),
      content: _contentController!.text,
      updatedAt: DateTime.now(),
    );

    notifier.updateNote(updatedNote);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final notesState = ref.watch(notesProvider);

    return notesState.when(
      data: (notes) {
        final note = notes.where((n) => n.id == widget.noteId).isNotEmpty
            ? notes.firstWhere((n) => n.id == widget.noteId)
            : null;

        if (note == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Nota no encontrada')),
            body: const Center(child: Text('La nota solicitada no existe.')),
          );
        }

        // Inicializar controladores si no lo están
        _originalNote ??= note;
        _titleController ??= TextEditingController(text: note.title);
        _contentController ??= TextEditingController(text: note.content);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Editar nota'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _showDeleteDialog(context),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Título (opcional)',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Escribe aquí tus pensamientos...',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _save,
            label: const Text('Guardar'),
            icon: const Icon(Icons.save),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(appBar: AppBar(title: const Text('Error')), body: Center(child: Text('Error: $e'))),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: const Text('¿Seguro que quieres eliminar esta entrada?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              ref.read(notesProvider.notifier).deleteNote(widget.noteId);
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}