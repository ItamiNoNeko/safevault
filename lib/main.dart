import 'package:safevault/presentation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: SafeVaultApp()));
}

class SafeVaultApp extends StatelessWidget {
  const SafeVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definimos nuestros colores de marca una sola vez
    const primaryColor = Color(0xFF4A90E2);
    const secondaryColor = Color(0xFFF5A623);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SafeVault',

      // --- TEMA CLARO (LIGHT THEME) ---
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        // ColorScheme.fromSeed es una maravilla de Material 3.
        // Genera una paleta de >20 colores armónicos a partir de un solo color semilla.
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
          secondary: secondaryColor,
        ),
        fontFamily: 'Roboto', // Fuente moderna y legible
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          bodyMedium: TextStyle(color: Colors.black54, fontSize: 14.0),
          labelSmall: TextStyle(fontWeight: FontWeight.w500),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade50,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
      ),

      // --- TEMA OSCURO (DARK THEME) ---
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
          secondary: secondaryColor,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 14.0),
          labelSmall: TextStyle(fontWeight: FontWeight.w500),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
          elevation: 0,
          centerTitle: true,
        ),
      ),

      // Flutter elegirá automáticamente entre theme y darkTheme según el sistema.
      themeMode: ThemeMode.system,

      routerConfig: appRouter,
    );
  }
}
