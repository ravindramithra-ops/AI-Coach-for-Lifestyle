import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/workouts/presentation/workout_categories_screen.dart';
import '../../features/workouts/presentation/workout_detail_screen.dart';
import '../../features/calculators/presentation/bmi_calculator_screen.dart';
import '../../features/ai_coach/presentation/ai_coach_screen.dart';

/// Route name constants to avoid magic strings across the app.
class AppRoutes {
  AppRoutes._();
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';
  static const workoutCategories = '/workouts';
  static const workoutDetail = '/workouts/:categoryName';
  static const bmiCalculator = '/calculators/bmi';
  static const aiCoach = '/ai-coach';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.workoutCategories,
        builder: (context, state) => const WorkoutCategoriesScreen(),
      ),
      GoRoute(
        path: AppRoutes.workoutDetail,
        builder: (context, state) => WorkoutDetailScreen(
          categoryName: state.pathParameters['categoryName'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.bmiCalculator,
        builder: (context, state) => const BmiCalculatorScreen(),
      ),
      GoRoute(
        path: AppRoutes.aiCoach,
        builder: (context, state) => const AiCoachScreen(),
      ),
    ],
  );
});
