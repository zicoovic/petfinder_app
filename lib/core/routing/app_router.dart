import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/details/details_screen.dart';
import '../../presentation/favourite/favourite_screen.dart';
import '../../core/entities/pet.dart';
import 'app_routes.dart';

/// Route generation configuration using GoRouter
class RouteGenerationConfig {
  RouteGenerationConfig._();

  static final GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        pageBuilder: (context, state) => MaterialPage(
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => MaterialPage(
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.details,
        name: 'details',
        pageBuilder: (context, state) {
          final pet = state.extra as Pet;
          return MaterialPage(
            child: DetailsScreen(pet: pet),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.favorites,
        name: 'favorites',
        pageBuilder: (context, state) => MaterialPage(
          child: const FavoriteScreen(),
        ),
      ),
    ],
  );
}
