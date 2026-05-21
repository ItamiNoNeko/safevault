import 'package:safevault/data/local/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();

  // Cerrar la DB cuando se destruya el provider
  ref.onDispose(() => db.close());

  return db;
});