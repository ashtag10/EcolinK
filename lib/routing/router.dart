import '../ui/core/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    // Ajoute ici les autres routes
  ],
);
