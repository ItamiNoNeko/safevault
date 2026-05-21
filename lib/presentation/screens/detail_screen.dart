import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:safevault/presentation/providers/note_provider.dart';
import 'package:safevault/data/models/note.dart';

// Pantalla de detalle para mostrar el contenido completo de una nota
class DetailScreen extends ConsumerWidget {
  final int noteId;

  const DetailScreen({super.key, required this.noteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesState = ref.watch(notesProvider);

    return notesState.when(
      data: (notes) {
        final note = notes.where((n) => n.id == noteId).isNotEmpty
            ? notes.firstWhere((n) => n.id == noteId)
            : null;

        if (note == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Nota no encontrada')),
            body: const Center(child: Text('La nota solicitada no existe.')),
          );
        }

        return Scaffold(
      appBar: AppBar(
        title: Text(note.title.isEmpty ? 'Sin título' : note.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/edit/$noteId'),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _showDeleteDialog(context, ref, note),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.title.isNotEmpty)
              Text(
                note.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            if (note.title.isNotEmpty) const SizedBox(height: 16),
            Text(
              note.content,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 24),
            Text(
              'Creado: ${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Note note) {
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
              ref.read(notesProvider.notifier).deleteNote(note.id);
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