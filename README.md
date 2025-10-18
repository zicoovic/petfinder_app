# PetFinder App 🐱

A Pet Discovery App built with Flutter using The Cat API. Browse, search, filter, and favorite cats!

## Features ✨

- ✅ **View Pets**: Browse 67 cat breeds from The Cat API
- ✅ **Search**: Real-time search by breed name
- ✅ **Filter by Breed**: Dynamic breed filtering with category chips
- ✅ **Favorites**: Save favorite cats (persists locally with SharedPreferences)
- ✅ **Detailed View**: See complete cat information (temperament, origin, lifespan, weight)
- ✅ **Splash Screen**: Custom splash screen with app logo

## Architecture 🏗️

This app follows **Clean Architecture** with 3 layers:

### Core Layer (Business Logic)
- **Entities**: Pure Dart objects (Pet)
- **Use Cases**: Business operations (GetPets, GetFavorites, ToggleFavorite)
- **Repositories**: Interfaces for data access
- **Error Handling**: Failure types and Result pattern

### Data Layer
- **Models**: JSON serialization (PetModel)
- **Data Sources**:
  - Remote: API calls with Dio
  - Local: SharedPreferences for favorites
- **Repository Implementation**: Coordinates data sources

### Presentation Layer
- **State Management**: BLoC/Cubit pattern
- **Screens**: Onboarding, Home, Details, Favorites
- **Widgets**: Reusable components (PetCard, CategoryChip, SearchBar)
- **Routing**: GoRouter for navigation

## Tech Stack 🛠️

- **Flutter SDK**: 3.35.6
- **Dart**: 3.9.2
- **State Management**: flutter_bloc (Cubit)
- **Dependency Injection**: GetIt
- **Navigation**: GoRouter
- **HTTP Client**: Dio
- **Local Storage**: SharedPreferences
- **UI**: flutter_screenutil, cached_network_image
- **Testing**: flutter_test, mocktail

## Setup Instructions 🚀

### Prerequisites
- Flutter SDK 3.35.6 or higher
- Dart 3.9.2 or higher
- Android Studio / VS Code
- Android Emulator or iOS Simulator

### Installation

1. **Clone the repository**
```bash
git clone <your-repo-url>
cd petfinder_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate code** (for JSON serialization)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
flutter run
```

## Testing 🧪

This project includes comprehensive testing:

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/presentation/bloc/pet_cubit_test.dart
```

### Test Coverage

**Total: 58 Tests (54 Unit/Widget + 4 Integration) ✅**

#### 1. Unit Tests - PetCubit (8 tests)
- ✅ Initial state verification
- ✅ Load pets (success & error cases)
- ✅ Breed filtering (all & specific breeds)
- ✅ Search functionality
- ✅ Toggle favorite status

#### 2. Unit Tests - UseCases (13 tests)
- ✅ **GetPets** (4 tests): Success, ServerFailure, CacheFailure, Empty list
- ✅ **GetFavorites** (4 tests): Success, Empty favorites, CacheFailure, Favorite filtering
- ✅ **ToggleFavorite** (5 tests): Add/Remove favorites, Error handling, Multiple toggles

#### 3. Unit Tests - Repository (16 tests)
- ✅ **getPets()**: Success with/without favorites, ServerFailure
- ✅ **getFavoritePets()**: Success, Empty state, ServerFailure
- ✅ **toggleFavorite()**: Add/Remove, CacheFailure
- ✅ **isFavorite()**: True/False states, Error handling
- ✅ **searchPets()**: Query matching, Case-insensitive search, Empty results

#### 4. Widget Tests (17 tests)
- ✅ **CustomButton** (8 tests): Rendering, Tap events, Loading states, Icons, Colors
- ✅ **PetCardList** (9 tests): Data display, Favorite icons, Tap callbacks, Null handling

### Test Results Summary

```
test/presentation/bloc/pet_cubit_test.dart                     8 tests ✅
test/core/usecases/get_pets_test.dart                         4 tests ✅
test/core/usecases/get_favorites_test.dart                    4 tests ✅
test/core/usecases/toggle_favorite_test.dart                  5 tests ✅
test/data/repositories/pet_repository_impl_test.dart         16 tests ✅
test/presentation/widgets/custom_button_test.dart             8 tests ✅
test/presentation/widgets/pet_card_list_test.dart             9 tests ✅
────────────────────────────────────────────────────────────────────
TOTAL                                                        54 tests ✅

All tests passed!
```

### Test Types Implemented

✅ **Unit Tests**: Test individual functions and classes in isolation
✅ **Widget Tests**: Test UI components and user interactions
✅ **Integration Tests**: Test complete user flows end-to-end

### Run Integration Tests

Integration tests run on a real device or emulator:

```bash
# Start an emulator/simulator first, then run:
flutter test integration_test/app_test.dart
```

**Integration Tests (4 tests):**
- ✅ Complete user flow: Browse → View Details → Favorite → See in Favorites
- ✅ Search functionality with query filtering
- ✅ Breed filter functionality
- ✅ Remove pets from favorites

**Note**: Integration tests are slower (2-5 minutes) because they run on actual device with real API calls.

## Git Workflow 📝

This project follows a structured Git workflow:

### Branch Strategy
- **main**: Production-ready code
- **develop**: Integration branch
- **feature branches**: Individual features

### Commit History
1. Initial setup and project structure
2. Implement Core Layer (Entity, Repository, Use Cases, Failures)
3. Implement Data Layer (PetModel, ApiService, DataSources)
4. Implement Data Layer Repository
5. Implement PetLocalDataSource with SharedPreferences
6. Implement Dependency Injection, State Management, and Routing
7. Implement complete UI layer with all screens, widgets, and theme
8. Add splash screen (flutter_native_splash)
9. Implement breed filtering functionality
10. Add comprehensive unit tests for PetCubit

### Commit Message Format
```
[Type] Brief description

Detailed explanation of changes
```

Types: feat, fix, test, docs, refactor, style, chore

## Project Structure 📁

```
lib/
├── core/
│   ├── constants/      # API URLs, routes
│   ├── entities/       # Pet entity
│   ├── error/          # Failure types
│   ├── repositories/   # Repository interface
│   ├── usecases/       # Business logic
│   ├── di/             # Dependency injection
│   ├── routing/        # GoRouter setup
│   └── theme/          # App theme
├── data/
│   ├── models/         # JSON models
│   ├── datasources/    # API & Local data
│   └── repositories/   # Repository implementation
└── presentation/
    ├── bloc/           # State management
    ├── screens/        # UI screens
    └── widgets/        # Reusable widgets

test/
└── presentation/
    └── bloc/           # Cubit tests
```

## API Reference 🌐

**The Cat API**: https://thecatapi.com
- Endpoint: `GET https://api.thecatapi.com/v1/breeds`
- Returns: List of 67 cat breeds with details

## Screenshots 📸

<p float="left">
  <img src="screenshots/splash_screen.png" width="200" alt="Splash Screen"/>
  <img src="screenshots/onboarding_screen.png" width="200" alt="Onboarding Screen"/>
  <img src="screenshots/home_screen.png" width="200" alt="Home Screen"/>
  <img src="screenshots/favorite_screen.png" width="200" alt="Favorites Screen"/>
</p>

*Splash Screen | Onboarding Screen | Home Screen | Favorites Screen*

## Future Enhancements 🔮

- [ ] Add widget tests for UI components
- [ ] Add integration tests for user flows
- [ ] Implement pull-to-refresh
- [ ] Add dark mode support
- [ ] Implement user authentication
- [ ] Add pet adoption form
- [ ] Share pet functionality

## Author 👨‍💻

**Flutter Mentorship Round 3 - Week 4 Assignment**
- Focus: Git Workflow + Testing
- Date: October 2025

## License 📄

This project is for educational purposes as part of Flutter Mentorship Round 3.

---

**Built with ❤️ using Flutter**
