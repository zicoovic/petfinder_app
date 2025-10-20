import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:petfinder_app/core/entities/pet.dart';
import 'package:petfinder_app/core/repositories/pet_repository.dart';
import 'package:petfinder_app/core/usecases/toggle_favorite.dart';
import 'package:petfinder_app/core/error/failures.dart';

/// ============================================================================
/// TESTING EXPLAINED - ToggleFavorite UseCase
/// ============================================================================
///
/// WHAT ARE WE TESTING?
/// - The ToggleFavorite use case, which adds/removes pets from favorites
/// - Unlike GetPets/GetFavorites, this one CHANGES data (not just reads)
///
/// HOW TOGGLE WORKS:
/// - If pet is NOT favorite → Add to favorites (returns true)
/// - If pet IS favorite → Remove from favorites (returns false)
/// - Stores result in SharedPreferences
///
/// KEY DIFFERENCE:
/// - This use case takes a PARAMETER (the Pet to toggle)
/// - Returns Result`<bool` instead of Result<List`<Pet`>`
/// - true = now favorited, false = now unfavorited
///
/// TESTING STRATEGY:
/// - Test adding to favorites (not favorite → favorite)
/// - Test removing from favorites (favorite → not favorite)
/// - Test error scenarios
/// ============================================================================

// Mock Repository
class MockPetRepository extends Mock implements PetRepository {}

void main() {
  late ToggleFavorite useCase;
  late MockPetRepository mockRepository;

  setUp(() {
    mockRepository = MockPetRepository();
    useCase = ToggleFavorite(mockRepository);
  });

  // Test data - Different pet states
  const unfavoritedPet = Pet(
    id: '1',
    name: 'Abyssinian',
    temperament: 'Active, Energetic',
    origin: 'Egypt',
    isFavorite: false, // NOT favorited
  );

  const favoritedPet = Pet(
    id: '1',
    name: 'Abyssinian',
    temperament: 'Active, Energetic',
    origin: 'Egypt',
    isFavorite: true, // Already favorited
  );

  // `IMPORTANT: Register fallback values for mocktail
  // This is needed when mocking methods that take parameters
  setUpAll(() {
    registerFallbackValue(unfavoritedPet);
  });

  group('ToggleFavorite UseCase Tests', () {
    /// ========================================================================
    /// `TEST 1: Add to favorites (false → true)
    /// ========================================================================
    /// `SCENARIO: User clicks heart on unfavorited pet
    /// `EXPECTED: Pet gets added to favorites, returns true
    /// ========================================================================
    test('should add pet to favorites when pet is not favorited', () async {
      // `ARRANGE: Mock returns true (now favorited)
      when(
        () => mockRepository.toggleFavorite(unfavoritedPet),
      ).thenAnswer((_) async => const Success(true));

      // `ACT: Toggle favorite on unfavorited pet
      final result = await useCase(unfavoritedPet);

      // `ASSERT: Check result
      expect(result, isA<Success<bool>>());

      // Extract the boolean value
      final successResult = result as Success<bool>;

      // Should return true (now favorited)
      expect(successResult.data, true);

      // Verify repository was called with correct pet
      verify(() => mockRepository.toggleFavorite(unfavoritedPet)).called(1);
    });

    /// ========================================================================
    /// `TEST 2: Remove from favorites (true → false)
    /// ========================================================================
    /// `SCENARIO: User clicks heart on already favorited pet
    /// `EXPECTED: Pet gets removed from favorites, returns false
    /// ========================================================================
    test(
      'should remove pet from favorites when pet is already favorited',
      () async {
        // `ARRANGE: Mock returns false (now unfavorited)
        when(
          () => mockRepository.toggleFavorite(favoritedPet),
        ).thenAnswer((_) async => const Success(false));

        // ACT: Toggle favorite on favorited pet
        final result = await useCase(favoritedPet);

        // `ASSERT: Check result
        expect(result, isA<Success<bool>>());
        final successResult = result as Success<bool>;

        // Should return false (now unfavorited)
        expect(successResult.data, false);

        // Verify repository was called with correct pet
        verify(() => mockRepository.toggleFavorite(favoritedPet)).called(1);
      },
    );

    /// ========================================================================
    /// TEST 3: Cache Error - Storage fails
    /// ========================================================================
    /// SCENARIO: SharedPreferences fails to save favorite
    /// EXPECTED: Returns CacheFailure error
    /// ========================================================================
    test('should return CacheFailure when storage fails', () async {
      // ARRANGE: Mock returns cache error
      when(
        () => mockRepository.toggleFavorite(unfavoritedPet),
      ).thenAnswer((_) async => const Error(CacheFailure()));

      // ACT: Try to toggle favorite
      final result = await useCase(unfavoritedPet);

      // ASSERT: Check we got error
      expect(result, isA<Error<bool>>());
      final errorResult = result as Error<bool>;
      expect(errorResult.failure, isA<CacheFailure>());

      // Verify repository was called
      verify(() => mockRepository.toggleFavorite(unfavoritedPet)).called(1);
    });

    /// ========================================================================
    /// TEST 4: Multiple toggles
    /// ========================================================================
    /// SCENARIO: User toggles favorite multiple times (add → remove → add)
    /// EXPECTED: Each toggle should work independently
    /// ========================================================================
    test('should handle multiple toggles correctly', () async {
      // ARRANGE: First toggle - add to favorites
      when(
        () => mockRepository.toggleFavorite(unfavoritedPet),
      ).thenAnswer((_) async => const Success(true));

      // ACT 1: First toggle (add)
      final result1 = await useCase(unfavoritedPet);

      // ASSERT 1: Should be favorited
      expect(result1, isA<Success<bool>>());
      expect((result1 as Success<bool>).data, true);

      // ARRANGE: Second toggle - remove from favorites
      when(
        () => mockRepository.toggleFavorite(favoritedPet),
      ).thenAnswer((_) async => const Success(false));

      // ACT 2: Second toggle (remove)
      final result2 = await useCase(favoritedPet);

      // ASSERT 2: Should be unfavorited
      expect(result2, isA<Success<bool>>());
      expect((result2 as Success<bool>).data, false);

      // ARRANGE: Third toggle - add again
      when(
        () => mockRepository.toggleFavorite(unfavoritedPet),
      ).thenAnswer((_) async => const Success(true));

      // ACT 3: Third toggle (add again)
      final result3 = await useCase(unfavoritedPet);

      // ASSERT 3: Should be favorited again
      expect(result3, isA<Success<bool>>());
      expect((result3 as Success<bool>).data, true);

      // Verify each call was made
      verify(() => mockRepository.toggleFavorite(unfavoritedPet)).called(2);
      verify(() => mockRepository.toggleFavorite(favoritedPet)).called(1);
    });

    /// ========================================================================
    /// TEST 5: Correct pet passed to repository
    /// ========================================================================
    /// SCENARIO: Ensure the exact pet object is passed to repository
    /// EXPECTED: Repository receives the same pet we sent
    /// ========================================================================
    test('should pass correct pet to repository', () async {
      // ARRANGE: Create a specific pet
      const testPet = Pet(
        id: '42',
        name: 'Maine Coon',
        temperament: 'Gentle, Social',
        origin: 'United States',
        isFavorite: false,
      );

      // Mock the toggle
      when(
        () => mockRepository.toggleFavorite(testPet),
      ).thenAnswer((_) async => const Success(true));

      // ACT: Toggle this specific pet
      await useCase(testPet);

      // ASSERT: Verify repository received the EXACT pet
      final captured = verify(
        () => mockRepository.toggleFavorite(captureAny()),
      ).captured;

      // Check the captured pet matches our test pet
      expect(captured.length, 1); // Only called once
      expect(captured.first, testPet); // Same pet object
      expect((captured.first as Pet).id, '42'); // Same ID
      expect((captured.first as Pet).name, 'Maine Coon'); // Same name
    });
  });
}

/// ============================================================================
/// WHAT YOU LEARNED:
/// ============================================================================
///
/// 1. TESTING WITH PARAMETERS:
///    - ToggleFavorite takes a Pet parameter
///    - We test with different pet states (favorited vs not favorited)
///    - Use registerFallbackValue() for mocktail with parameters
///
/// 2. TESTING STATE CHANGES:
///    - This use case MODIFIES data (not just reads)
///    - We test both directions: add and remove
///    - Multiple toggles ensure consistency
///
/// 3. BOOLEAN RESULTS:
///    - Returns Result`<bool>` not Result<List`<Pet>`>
///    - true = now favorited
///    - false = now unfavorited
///
/// 4. CAPTURING ARGUMENTS:
///    - captureAny() captures what was passed to the method
///    - Useful to verify exact parameters
///    - .captured gives you list of captured arguments
///
/// 5. SETUPALL:
///    - setUp() runs before EACH test
///    - setUpAll() runs ONCE before ALL tests
///    - Use for one-time setup like registerFallbackValue()
///
/// ============================================================================
/// REAL WORLD SCENARIO:
/// ============================================================================
///
/// Bug Report: "When I favorite a cat, the heart doesn't stay filled!"
///
/// WITHOUT TESTS:
/// - "Does toggle work? Let me manually test..."
/// - "Is it the UI? The repository? The use case?"
/// - Hours of debugging
///
/// WITH TESTS:
/// - Run: flutter test test/core/usecases/toggle_favorite_test.dart
/// - All tests pass → Bug is in UI or repository
/// - Test fails → Found the bug in use case!
/// - Fixed in minutes instead of hours
///
/// TESTING SAVES TIME! ⏰
/// ============================================================================
///
/// BONUS: WHY registerFallbackValue?
/// ============================================================================
///
/// Mocktail needs to know what default value to use for types.
/// When you mock a method like: toggleFavorite(Pet pet)
/// Mocktail needs a "fallback" Pet object to compare against.
///
/// Without it, you get an error like:
/// "Bad state: Missing fallback value for Pet"
///
/// With it, Mocktail knows: "Oh, when comparing Pet objects, use this one"
/// ============================================================================
