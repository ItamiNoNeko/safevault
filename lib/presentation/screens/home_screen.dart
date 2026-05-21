import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:safevault/presentation/providers/note_provider.dart';

// Pantalla principal que muestra la lista de notas
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesState = ref.watch(notesProvider);

    return notesState.when(
      data: (notes) => Scaffold(
        appBar: AppBar(
          title: const Text('SafeVault'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: notes.isEmpty
            ? const Center(
                child: Text(
                  'No hay notas aún...\n¡Crea tu primera entrada privada!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return ListTile(
                    leading: const Icon(Icons.book_outlined),
                    title: Text(
                      note.title.isEmpty ? 'Sin título' : note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${note.updatedAt.day}/${note.updatedAt.month}/${note.updatedAt.year}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => context.push('/edit/${note.id}'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Eliminar nota'),
                                content: const Text('¿Seguro que quieres eliminar esta entrada?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                                    onPressed: () {
                                      ref.read(notesProvider.notifier).deleteNote(note.id);
                                      Navigator.pop(ctx);
                                    },
                                    child: const Text('Eliminar'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () => context.push('/detail/${note.id}'),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/create'),
          child: const Icon(Icons.add),
        ),
      ),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(appBar: AppBar(title: const Text('Error')), body: Center(child: Text('Error: $e'))),
    );
  }
}