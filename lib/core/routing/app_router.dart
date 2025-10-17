import 'package:go_router/go_router.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/details/details_screen.dart';
import '../../presentation/favourite/favourite_screen.dart';
import '../../core/entities/pet.dart';
import '../constants/app_constants.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppConstants.onboardingRoute,
    routes: [
      GoRoute(
        path: AppConstants.onboardingRoute,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppConstants.homeRoute,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppConstants.detailsRoute,
        name: 'details',
        builder: (context, state) {
          final pet = state.extra as Pet;
          return DetailsScreen(pet: pet);
        },
      ),
      GoRoute(
        path: AppConstants.favoriteRoute,
        name: 'favorites',
        builder: (context, state) => const FavoriteScreen(),
      ),
    ],
  );
}