import 'package:go_router/go_router.dart';
import '../ui/core/splash_screen.dart';
import '../ui/welcome/widgets/welcome_screen.dart';
import '../ui/user/home_screen_v2.dart';
import '../ui/user/login_screen.dart';
import '../ui/user/register_screen.dart';
import '../domain/models/user.dart';
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
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => HomeScreenV2(user: state.extra as User?),
    ),
    // Ajoute ici les autres routes
  ],
);
