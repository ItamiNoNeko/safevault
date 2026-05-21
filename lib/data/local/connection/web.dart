import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

LazyDatabase connect() {
  // --- WEB CONNECTION (WASM) ---
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'safevault', // Name of your IndexedDB database
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.dart.js'),
    );

    if (result.missingFeatures.isNotEmpty) {
      debugPrint(
        'Using ${result.chosenImplementation} due to unsupported browser features: ${result.missingFeatures}',
      );
    }

    return result.resolvedExecutor;
  });
}
