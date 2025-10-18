import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:petfinder_app/core/entities/pet.dart';
import 'package:petfinder_app/core/repositories/pet_repository.dart';
import 'package:petfinder_app/core/usecases/get_pets.dart';
import 'package:petfinder_app/core/error/failures.dart';

/// ============================================================================
/// TESTING EXPLAINED - GetPets UseCase
/// ============================================================================
///
/// WHAT ARE WE TESTING?
/// - The GetPets use case, which fetches all pets from the repository
/// - It's a simple class that calls repository.getPets()
///
/// WHY TEST USE CASES?
/// - Ensures business logic works correctly
/// - Makes sure use case properly calls the repository
/// - Verifies error handling works
///
/// HOW DOES TESTING WORK?
/// 1. We create a MOCK repository (fake version)
/// 2. We tell the mock what to return (success or error)
/// 3. We call the use case
/// 4. We check if we got the expected result
///
/// TESTING PATTERN (AAA):
/// - ARRANGE: Set up test data and mocks
/// - ACT: Run the code we're testing
/// - ASSERT: Check if the result is what we expected
/// ============================================================================

// Mock Repository - This is a FAKE version of PetRepository
// We use this so we don't need to make real API calls during testing
class MockPetRepository extends Mock implements PetRepository {}

void main() {
  // These variables will be used in all tests
  late GetPets useCase; // The thing we're testing
  late MockPetRepository mockRepository; // Fake repository

  // setUp runs BEFORE each test
  // It creates fresh instances so each test is independent
  setUp(() {
    mockRepository = MockPetRepository();
    useCase = GetPets(mockRepository);
  });

  // Test data - Sample pets we'll use in our tests
  final testPets = [
    const Pet(
      id: '1',
      name: 'Abyssinian',
      temperament: 'Active, Energetic',
      origin: 'Egypt',
      isFavorite: false,
    ),
    const Pet(
      id: '2',
      name: 'Aegean',
      temperament: 'Social, Intelligent',
      origin: 'Greece',
      isFavorite: false,
    ),
  ];

  // group() organizes related tests together
  group('GetPets UseCase Tests', () {
    /// ========================================================================
    /// TEST 1: Success Case
    /// ========================================================================
    /// SCENARIO: Repository successfully returns pets
    /// EXPECTED: Use case should return Success with the pets list
    /// ========================================================================
    test('should return list of pets when repository succeeds', () async {
      // ARRANGE: Tell the mock repository to return success with test pets
      // "when" = when this method is called
      // "thenAnswer" = return this result
      when(() => mockRepository.getPets())
          .thenAnswer((_) async => Success(testPets));

      // ACT: Call the use case (this will call our mock repository)
      final result = await useCase();

      // ASSERT: Check the results
      // 1. Verify we got a Success result
      expect(result, isA<Success<List<Pet>>>());

      // 2. Extract the pets from the Success result
      final successResult = result as Success<List<Pet>>;

      // 3. Verify we got the correct number of pets
      expect(successResult.data.length, 2);

      // 4. Verify the first pet is correct
      expect(successResult.data.first.name, 'Abyssinian');

      // 5. Verify the repository was called exactly once
      verify(() => mockRepository.getPets()).called(1);
    });

    /// ========================================================================
    /// TEST 2: Server Error Case
    /// ========================================================================
    /// SCENARIO: Repository fails with a server error
    /// EXPECTED: Use case should return Error with ServerFailure
    /// ========================================================================
    test('should return ServerFailure when repository fails', () async {
      // ARRANGE: Tell the mock repository to return an error
      when(() => mockRepository.getPets())
          .thenAnswer((_) async => const Error(ServerFailure()));

      // ACT: Call the use case
      final result = await useCase();

      // ASSERT: Check we got an error result
      expect(result, isA<Error<List<Pet>>>());

      // Extract the error
      final errorResult = result as Error<List<Pet>>;

      // Verify it's a ServerFailure
      expect(errorResult.failure, isA<ServerFailure>());

      // Verify the repository was called
      verify(() => mockRepository.getPets()).called(1);
    });

    /// ========================================================================
    /// TEST 3: Cache Error Case
    /// ========================================================================
    /// SCENARIO: Repository fails with a cache error
    /// EXPECTED: Use case should return Error with CacheFailure
    /// ========================================================================
    test('should return CacheFailure when repository has cache error',
        () async {
      // ARRANGE: Tell the mock to return cache error
      when(() => mockRepository.getPets())
          .thenAnswer((_) async => const Error(CacheFailure()));

      // ACT: Call the use case
      final result = await useCase();

      // ASSERT: Check we got a cache error
      expect(result, isA<Error<List<Pet>>>());
      final errorResult = result as Error<List<Pet>>;
      expect(errorResult.failure, isA<CacheFailure>());

      // Verify the repository was called
      verify(() => mockRepository.getPets()).called(1);
    });

    /// ========================================================================
    /// TEST 4: Empty List Case
    /// ========================================================================
    /// SCENARIO: Repository returns success but with empty list
    /// EXPECTED: Use case should return Success with empty list
    /// ========================================================================
    test('should return empty list when repository returns no pets', () async {
      // ARRANGE: Mock returns success with empty list
      when(() => mockRepository.getPets())
          .thenAnswer((_) async => const Success([]));

      // ACT: Call the use case
      final result = await useCase();

      // ASSERT: Check we got success with empty list
      expect(result, isA<Success<List<Pet>>>());
      final successResult = result as Success<List<Pet>>;
      expect(successResult.data, isEmpty); // List should be empty
      expect(successResult.data.length, 0); // Length should be 0

      // Verify the repository was called
      verify(() => mockRepository.getPets()).called(1);
    });
  });
}

/// ============================================================================
/// KEY TESTING CONCEPTS USED:
/// ============================================================================
///
/// 1. MOCKING (MockPetRepository):
///    - Creates a fake object that behaves like the real one
///    - Lets us control what it returns (success or error)
///    - No real API calls = fast, reliable tests
///
/// 2. ARRANGE-ACT-ASSERT (AAA Pattern):
///    - Arrange: Set up test data and tell mocks what to return
///    - Act: Run the code being tested
///    - Assert: Check if results match expectations
///
/// 3. WHEN-THEN (Mocktail syntax):
///    - when(() => mockObject.method()) = when this is called
///    - thenAnswer((_) async => result) = return this result
///
/// 4. VERIFY (Checking method calls):
///    - verify(() => mockObject.method()).called(1)
///    - Ensures the method was actually called
///    - Helps catch bugs where code isn't calling dependencies
///
/// 5. EXPECT (Assertions):
///    - expect(actual, matcher) = check if actual matches expected
///    - isA<Type>() = checks if value is of certain type
///    - equals() = checks if values are equal
///    - isEmpty = checks if list is empty
///
/// ============================================================================
/// WHY THESE TESTS MATTER:
/// ============================================================================
///
/// Without tests, you'd need to:
/// 1. Manually open the app
/// 2. Wait for API to load
/// 3. Check if pets appear
/// 4. Simulate errors (disconnect internet, etc.)
/// 5. Repeat every time you change code
///
/// With tests, you just run:
/// flutter test test/core/usecases/get_pets_test.dart
///
/// And in seconds, you know if your code works! 🚀
/// ============================================================================
