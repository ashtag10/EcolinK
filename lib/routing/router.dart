import 'package:go_router/go_router.dart';
import '../ui/core/splash_screen.dart';
import '../ui/welcome/widgets/welcome_screen.dart';
import 'routes.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    // Ajoute ici les autres routes
  ],
);
