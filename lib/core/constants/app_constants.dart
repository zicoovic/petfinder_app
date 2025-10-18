class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // API Configuration
  static const String baseUrl = 'https://api.thecatapi.com/v1';
  static const String baseImageUrl = 'https://cdn2.thecatapi.com/images/';
  static const String apiKey =
      'live_0ZIF7Okn2Y0j4JpqhQOoX0w4L2g7Jo4odyokbxV5R0GFuCWXZq1PuYPHoHz381DO'; // Get from: https://thecatapi.com/signup

  // API Endpoints
  static const String breedsEndpoint = '/breeds';
  static const String imagesEndpoint = '/images/search';

  // Pet Categories (for UI filters)
  static const String categoryAll = 'All';
  static const String categoryCats = 'Cats';
  static const String categoryDogs = 'Dogs';
  static const String categoryBirds = 'Birds';
  static const String categoryFish = 'Fish';
  static const String categoryReptiles = 'Reptiles';

  static const List<String> petCategories = [
    categoryAll,
    categoryCats,
    categoryDogs,
    categoryBirds,
    categoryFish,
    categoryReptiles,
  ];

  // Routes
  static const String onboardingRoute = '/';
  static const String homeRoute = '/home';
  static const String detailsRoute = '/details';
  static const String favoriteRoute = '/favorite';

  // Shared Preferences Keys
  static const String favoritesKey = 'favorites_pets';
  static const String hasSeenOnboardingKey = 'has_seen_onboarding';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const int defaultAnimationDuration = 300; // milliseconds

  // Pagination & Limits
  static const int petsPerPage = 20;
  static const int imageLimit = 10;
}
