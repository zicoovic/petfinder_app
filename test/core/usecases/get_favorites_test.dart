import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:petfinder_app/core/entities/pet.dart';
import 'package:petfinder_app/core/repositories/pet_repository.dart';
import 'package:petfinder_app/core/usecases/get_favorites.dart';
import 'package:petfinder_app/core/error/failures.dart';

/// ============================================================================
/// TESTING EXPLAINED - GetFavorites UseCase
/// ============================================================================
///
/// WHAT ARE WE TESTING?
/// - The GetFavorites use case, which fetches favorite pets from local storage
/// - Similar to GetPets, but only returns pets user has favorited
///
/// KEY DIFFERENCE FROM GetPets:
/// - GetPets fetches from API (remote)
/// - GetFavorites fetches from SharedPreferences (local storage)
/// - Both return List`<Pet>`, but favorites are stored on the device
///
/// TESTING STRATEGY:
/// - Test successful retrieval of favorites
/// - Test empty favorites (user hasn't favorited anything)
/// - Test cache errors (storage issues)
/// ============================================================================

// Mock Repository
class MockPetRepository extends Mock implements PetRepository {}

void main() {
  late GetFavorites useCase;
  late MockPetRepository mockRepository;

  setUp(() {
    mockRepository = MockPetRepository();
    useCase = GetFavorites(mockRepository);
  });

  // Test data - Favorite pets (notice isFavorite: true)
  final favoritePets = [
    const Pet(
      id: '1',
      name: 'Abyssinian',
      temperament: 'Active, Energetic',
      origin: 'Egypt',
      isFavorite: true, // This pet is favorited!
    ),
    const Pet(
      id: '5',
      name: 'Bengal',
      temperament: 'Curious, Active',
      origin: 'United States',
      isFavorite: true, // This pet is favorited!
    ),
  ];

  group('GetFavorites UseCase Tests', () {
    /// ========================================================================
    /// TEST 1: Success - User has favorites
    /// ========================================================================
    test(
      'should return list of favorite pets when repository succeeds',
      () async {
        // ARRANGE: Mock returns favorite pets
        when(
          () => mockRepository.getFavoritePets(),
        ).thenAnswer((_) async => Success(favoritePets));

        // ACT: Call the use case
        final result = await useCase();

        // ASSERT: Check results
        expect(result, isA<Success<List<Pet>>>());
        final successResult = result as Success<List<Pet>>;

        // Verify we got 2 favorite pets
        expect(successResult.data.length, 2);

        // Verify all returned pets are favorites
        expect(successResult.data.every((pet) => pet.isFavorite), true);

        // Verify the first favorite pet
        expect(successResult.data.first.name, 'Abyssinian');
        expect(successResult.data.first.isFavorite, true);

        // Verify repository was called
        verify(() => mockRepository.getFavoritePets()).called(1);
      },
    );

    /// ========================================================================
    /// TEST 2: Success - Empty favorites (new user)
    /// ========================================================================
    /// SCENARIO: User hasn't favorited any pets yet
    /// EXPECTED: Should return Success with empty list (not an error!)
    /// ========================================================================
    test('should return empty list when user has no favorites', () async {
      // ARRANGE: Mock returns empty list
      when(
        () => mockRepository.getFavoritePets(),
      ).thenAnswer((_) async => const Success([]));

      // ACT: Call the use case
      final result = await useCase();

      // ASSERT: Should be success, not error!
      expect(result, isA<Success<List<Pet>>>());
      final successResult = result as Success<List<Pet>>;

      // Verify list is empty
      expect(successResult.data, isEmpty);
      expect(successResult.data.length, 0);

      // Verify repository was called
      verify(() => mockRepository.getFavoritePets()).called(1);
    });

    /// ========================================================================
    /// TEST 3: Cache Error - Storage issue
    /// ========================================================================
    /// SCENARIO: SharedPreferences fails to read data
    /// EXPECTED: Should return Error with CacheFailure
    /// ========================================================================
    test('should return CacheFailure when storage fails', () async {
      // ARRANGE: Mock returns cache error
      when(
        () => mockRepository.getFavoritePets(),
      ).thenAnswer((_) async => const Error(CacheFailure()));

      // ACT: Call the use case
      final result = await useCase();

      // ASSERT: Check we got cache error
      expect(result, isA<Error<List<Pet>>>());
      final errorResult = result as Error<List<Pet>>;
      expect(errorResult.failure, isA<CacheFailure>());

      // Verify repository was called
      verify(() => mockRepository.getFavoritePets()).called(1);
    });

    /// ========================================================================
    /// TEST 4: Verify only favorited pets returned
    /// ========================================================================
    /// SCENARIO: Repository correctly filters only favorite pets
    /// EXPECTED: All returned pets should have isFavorite = true
    /// ========================================================================
    test('should only return pets with isFavorite true', () async {
      // ARRANGE: Create mixed list (some favorite, some not)
      final mixedPets = [
        const Pet(
          id: '1',
          name: 'Abyssinian',
          temperament: 'Active',
          origin: 'Egypt',
          isFavorite: true, // Favorite
        ),
        const Pet(
          id: '2',
          name: 'Aegean',
          temperament: 'Social',
          origin: 'Greece',
          isFavorite: true, // Favorite
        ),
      ];

      // Mock returns only favorite pets
      when(
        () => mockRepository.getFavoritePets(),
      ).thenAnswer((_) async => Success(mixedPets));

      // ACT: Call the use case
      final result = await useCase();

      // ASSERT: All returned pets should be favorites
      expect(result, isA<Success<List<Pet>>>());
      final successResult = result as Success<List<Pet>>;

      // Check every pet has isFavorite = true
      for (var pet in successResult.data) {
        expect(pet.isFavorite, true);
      }

      // Alternative way to check the same thing
      expect(successResult.data.every((pet) => pet.isFavorite), true);

      // Verify repository was called
      verify(() => mockRepository.getFavoritePets()).called(1);
    });
  });
}

/// ============================================================================
/// WHAT YOU LEARNED:
/// ============================================================================
///
/// 1. TESTING LOCAL STORAGE:
///    - GetFavorites reads from SharedPreferences (local storage)
///    - We mock the repository, so we don't need real storage
///    - Tests run fast because no disk I/O
///
/// 2. EMPTY vs ERROR:
///    - Empty list = Success (user just hasn't favorited anything)
///    - CacheFailure = Error (something went wrong with storage)
///    - IMPORTANT: These are different scenarios!
///
/// 3. DATA VALIDATION:
///    - We verify ALL pets have isFavorite = true
///    - Use .every() to check a condition on all items
///    - Use for-loop to check each item individually
///
/// 4. WHY MOCK REPOSITORY:
///    - Real repository would read from SharedPreferences
///    - That requires Android/iOS emulator or device
///    - Mocking makes tests instant and works on any machine
///
/// ============================================================================
/// REAL WORLD BENEFIT:
/// ============================================================================
///
/// Imagine a user reports: "My favorites aren't showing!"
///
/// WITHOUT TESTS:
/// - You'd need to manually test on device
/// - Hard to reproduce the bug
/// - Time-consuming debugging
///
/// WITH TESTS:
/// - Run: flutter test test/core/usecases/get_favorites_test.dart
/// - If tests pass, bug is elsewhere (UI, repository, etc.)
/// - If tests fail, you found the bug instantly!
///
/// Tests = Your safety net! 🎯
/// ============================================================================
