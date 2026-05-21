import 'package:safevault/presentation/screens/edit_screen.dart';
import 'package:safevault/presentation/screens/home_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:safevault/presentation/screens/detail_screen.dart';
import 'package:safevault/presentation/screens/create_screen.dart';

// Configuración de GoRouter
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/create',
      builder: (context, state) => const CreateScreen(),
    ),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return DetailScreen(noteId: id);
      },
    ),
    GoRoute(
      path: '/edit/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return EditScreen(noteId: id);
      },
    ),
  ],
);

// Nota: Se trato de usar solo tres pantallas pero resulto mas facil usar cuatro...