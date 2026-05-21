import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:safevault/presentation/providers/note_provider.dart';
import 'package:safevault/data/models/note.dart';

// Pantalla para crear una nueva nota
class CreateScreen extends ConsumerStatefulWidget {
  const CreateScreen({super.key});

  @override
  ConsumerState<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends ConsumerState<CreateScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    if (_contentController.text.trim().isEmpty) return;

    final notifier = ref.read(notesProvider.notifier);
    final now = DateTime.now();

    final newNote = Note(
      id: 0,
      title: _titleController.text.trim(),
      content: _contentController.text,
      createdAt: now,
      updatedAt: now,
    );

    notifier.addNote(newNote);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva nota')),
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
  }
}