import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/feed_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../services/auth_service.dart';

/// Notificador que escucha los cambios en authStateChanges de Firebase
/// y le avisa a GoRouter para evaluar redirecciones en tiempo real.
class AuthNotifier extends ChangeNotifier {
  final AuthService _authService;
  late final StreamSubscription<dynamic> _subscription;

  AuthNotifier(this._authService) {
    _subscription = _authService.authStateChanges.listen((user) {
      notifyListeners();
    });
  }

  bool get isLoggedIn => _authService.currentUser != null;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  final AuthService authService;
  late final AuthNotifier authNotifier;
  late final GoRouter router;

  AppRouter({required this.authService}) {
    authNotifier = AuthNotifier(authService);

    router = GoRouter(
      initialLocation: '/login',
      refreshListenable: authNotifier,
      redirect: (BuildContext context, GoRouterState state) {
        final bool loggedIn = authNotifier.isLoggedIn;
        final String location = state.matchedLocation;
        final bool isAuthRoute = location == '/login' || location == '/registro';

        // 1. Si no hay sesión iniciada y la ruta no es de auth (/login o /registro), redirigir a /login
        if (!loggedIn && !isAuthRoute) {
          return '/login';
        }

        // 2. Si ya hay sesión iniciada y está intentando acceder a /login o /registro, redirigir al feed
        if (loggedIn && isAuthRoute) {
          return '/feed';
        }

        // 3. No se requiere redirección adicional
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => LoginScreen(authService: authService),
        ),
        GoRoute(
          path: '/registro',
          name: 'registro',
          builder: (context, state) => RegisterScreen(authService: authService),
        ),
        GoRoute(
          path: '/feed',
          name: 'feed',
          builder: (context, state) => FeedScreen(authService: authService),
        ),
      ],
    );
  }
}
