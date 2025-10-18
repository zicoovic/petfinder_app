import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:petfinder_app/core/entities/pet.dart';
import 'package:petfinder_app/core/error/failures.dart';
import 'package:petfinder_app/core/repositories/pet_repository.dart';
import 'package:petfinder_app/data/datasources/pet_local_datasource.dart';
import 'package:petfinder_app/data/datasources/pet_remote_datasource.dart';
import 'package:petfinder_app/data/repositories/pet_repository_impl.dart';
import 'package:petfinder_app/data/models/pet_model.dart';

/// ============================================================================
/// TESTING EXPLAINED - PetRepositoryImpl
/// ============================================================================
///
/// WHAT ARE WE TESTING?
/// - The PetRepositoryImpl class - the BRAIN of our data layer!
/// - It coordinates between 2 data sources:
///   1. Remote (API) - Fetches cat data from The Cat API
///   2. Local (Storage) - Saves/loads favorites from SharedPreferences
///
/// WHY IS REPOSITORY COMPLEX?
/// - It combines TWO data sources (remote + local)
/// - It syncs favorite status between API data and local storage
/// - It handles errors from BOTH sources
/// - Example: getPets() fetches from API, then checks local storage for favorites
///
/// REAL WORLD EXAMPLE:
/// When you open the app:
/// 1. Repository calls API → Gets 67 cats
/// 2. Repository checks local storage → Gets favorite IDs: ["1", "5", "12"]
/// 3. Repository combines both → Marks cats 1, 5, 12 as isFavorite: true
/// 4. Returns combined data to app
///
/// TESTING STRATEGY:
/// - Mock BOTH data sources (remote + local)
/// - Test how repository combines their data
/// - Test error handling from both sources
/// ============================================================================

// Mock Data Sources
class MockPetRemoteDataSource extends Mock implements PetRemoteDataSource {}

class MockPetLocalDataSource extends Mock implements PetLocalDataSource {}

void main() {
  late PetRepositoryImpl repository;
  late MockPetRemoteDataSource mockRemoteDataSource;
  late MockPetLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockPetRemoteDataSource();
    mockLocalDataSource = MockPetLocalDataSource();
    repository = PetRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  // Test data - Using PetModel because remote data source returns PetModel
  final testPets = [
    const PetModel(
      id: '1',
      name: 'Abyssinian',
      temperament: 'Active, Energetic',
      origin: 'Egypt',
      isFavorite: false, // From API, not yet synced with local
    ),
    const PetModel(
      id: '2',
      name: 'Aegean',
      temperament: 'Social, Intelligent',
      origin: 'Greece',
      isFavorite: false,
    ),
    const PetModel(
      id: '3',
      name: 'American Bobtail',
      temperament: 'Playful, Smart',
      origin: 'United States',
      isFavorite: false,
    ),
  ];

  /// ==========================================================================
  /// GROUP 1: getPets() Tests
  /// ==========================================================================
  /// This method:
  /// 1. Fetches pets from API (remote)
  /// 2. Fetches favorite IDs from storage (local)
  /// 3. Combines them: marks favorited pets with isFavorite: true
  /// ==========================================================================
  group('getPets', () {
    /// ========================================================================
    /// TEST 1: Success - No favorites yet
    /// ========================================================================
    /// SCENARIO: User opens app for first time (no favorites saved)
    /// EXPECTED: Returns all pets with isFavorite: false
    /// ========================================================================
    test('should return pets with isFavorite false when no favorites saved',
        () async {
      // ARRANGE: Mock API returns pets
      when(() => mockRemoteDataSource.getPets())
          .thenAnswer((_) async => testPets);

      // Mock storage returns empty list (no favorites)
      when(() => mockLocalDataSource.getFavoritePets())
          .thenAnswer((_) async => []);

      // ACT: Get pets from repository
      final result = await repository.getPets();

      // ASSERT: Check result
      expect(result, isA<Success<List<Pet>>>());
      final successResult = result as Success<List<Pet>>;

      // All pets should have isFavorite: false
      expect(successResult.data.length, 3);
      expect(successResult.data.every((pet) => pet.isFavorite == false), true);

      // Verify both data sources were called
      verify(() => mockRemoteDataSource.getPets()).called(1);
      verify(() => mockLocalDataSource.getFavoritePets()).called(1);
    });

    /// ========================================================================
    /// TEST 2: Success - With favorites
    /// ========================================================================
    /// SCENARIO: User has favorited some pets before
    /// EXPECTED: Returns pets with correct favorite status synced from storage
    /// ========================================================================
    test('should return pets with correct isFavorite flag based on local storage',
        () async {
      // ARRANGE: Mock API returns pets
      when(() => mockRemoteDataSource.getPets())
          .thenAnswer((_) async => testPets);

      // Mock storage returns favorite IDs: ["1", "3"]
      // (User favorited Abyssinian and American Bobtail)
      when(() => mockLocalDataSource.getFavoritePets())
          .thenAnswer((_) async => ['1', '3']);

      // ACT: Get pets
      final result = await repository.getPets();

      // ASSERT: Check result
      expect(result, isA<Success<List<Pet>>>());
      final successResult = result as Success<List<Pet>>;

      // Should have 3 pets
      expect(successResult.data.length, 3);

      // Pet 1 (Abyssinian) should be favorite
      final pet1 = successResult.data.firstWhere((p) => p.id == '1');
      expect(pet1.isFavorite, true);
      expect(pet1.name, 'Abyssinian');

      // Pet 2 (Aegean) should NOT be favorite
      final pet2 = successResult.data.firstWhere((p) => p.id == '2');
      expect(pet2.isFavorite, false);
      expect(pet2.name, 'Aegean');

      // Pet 3 (American Bobtail) should be favorite
      final pet3 = successResult.data.firstWhere((p) => p.id == '3');
      expect(pet3.isFavorite, true);
      expect(pet3.name, 'American Bobtail');

      // Verify both data sources called
      verify(() => mockRemoteDataSource.getPets()).called(1);
      verify(() => mockLocalDataSource.getFavoritePets()).called(1);
    });

    /// ========================================================================
    /// TEST 3: API Error
    /// ========================================================================
    /// SCENARIO: API fails (no internet, server down, etc.)
    /// EXPECTED: Returns ServerFailure error
    /// ========================================================================
    test('should return ServerFailure when API call fails', () async {
      // ARRANGE: Mock API throws error
      when(() => mockRemoteDataSource.getPets()).thenThrow(Exception('API Error'));

      // ACT: Try to get pets
      final result = await repository.getPets();

      // ASSERT: Should return error
      expect(result, isA<Error<List<Pet>>>());
      final errorResult = result as Error<List<Pet>>;
      expect(errorResult.failure, isA<ServerFailure>());

      // Verify API was called
      verify(() => mockRemoteDataSource.getPets()).called(1);

      // Local storage should NOT be called (because API failed first)
      verifyNever(() => mockLocalDataSource.getFavoritePets());
    });
  });

  /// ==========================================================================
  /// GROUP 2: getFavoritePets() Tests
  /// ==========================================================================
  /// This method:
  /// 1. Gets favorite IDs from local storage
  /// 2. Fetches ALL pets from API
  /// 3. Filters to return ONLY favorited pets
  /// ==========================================================================
  group('getFavoritePets', () {
    /// ========================================================================
    /// TEST 1: Success - User has favorites
    /// ========================================================================
    test('should return only favorited pets', () async {
      // ARRANGE: Mock storage has favorite IDs
      when(() => mockLocalDataSource.getFavoritePets())
          .thenAnswer((_) async => ['1', '3']);

      // Mock API returns all pets
      when(() => mockRemoteDataSource.getPets())
          .thenAnswer((_) async => testPets);

      // ACT: Get favorites
      final result = await repository.getFavoritePets();

      // ASSERT: Check result
      expect(result, isA<Success<List<Pet>>>());
      final successResult = result as Success<List<Pet>>;

      // Should return only 2 pets (ID 1 and 3)
      expect(successResult.data.length, 2);

      // All returned pets should be favorites
      expect(successResult.data.every((pet) => pet.isFavorite == true), true);

      // Check specific pets
      expect(successResult.data.any((p) => p.id == '1'), true); // Abyssinian
      expect(successResult.data.any((p) => p.id == '3'), true); // American Bobtail
      expect(successResult.data.any((p) => p.id == '2'), false); // NOT Aegean

      // Verify both sources called
      verify(() => mockLocalDataSource.getFavoritePets()).called(1);
      verify(() => mockRemoteDataSource.getPets()).called(1);
    });

    /// ========================================================================
    /// TEST 2: Success - No favorites
    /// ========================================================================
    /// SCENARIO: User hasn't favorited anything
    /// EXPECTED: Returns empty list (not an error!)
    /// ========================================================================
    test('should return empty list when user has no favorites', () async {
      // ARRANGE: Mock storage returns empty list
      when(() => mockLocalDataSource.getFavoritePets())
          .thenAnswer((_) async => []);

      // ACT: Get favorites
      final result = await repository.getFavoritePets();

      // ASSERT: Should be success with empty list
      expect(result, isA<Success<List<Pet>>>());
      final successResult = result as Success<List<Pet>>;
      expect(successResult.data, isEmpty);
      expect(successResult.data.length, 0);

      // Only local storage called (no need to call API if no favorites)
      verify(() => mockLocalDataSource.getFavoritePets()).called(1);
      verifyNever(() => mockRemoteDataSource.getPets());
    });

    /// ========================================================================
    /// TEST 3: Error - API fails
    /// ========================================================================
    test('should return ServerFailure when API fails', () async {
      // ARRANGE: Storage has favorites
      when(() => mockLocalDataSource.getFavoritePets())
          .thenAnswer((_) async => ['1', '3']);

      // But API fails
      when(() => mockRemoteDataSource.getPets())
          .thenThrow(Exception('API Error'));

      // ACT: Try to get favorites
      final result = await repository.getFavoritePets();

      // ASSERT: Should return error
      expect(result, isA<Error<List<Pet>>>());
      final errorResult = result as Error<List<Pet>>;
      expect(errorResult.failure, isA<ServerFailure>());
    });
  });

  /// ==========================================================================
  /// GROUP 3: toggleFavorite() Tests
  /// ==========================================================================
  /// This method:
  /// 1. Checks if pet is currently favorite
  /// 2. If yes → removes from favorites (returns false)
  /// 3. If no → adds to favorites (returns true)
  /// ==========================================================================
  group('toggleFavorite', () {
    const testPet = Pet(
      id: '1',
      name: 'Abyssinian',
      temperament: 'Active',
      origin: 'Egypt',
      isFavorite: false,
    );

    /// ========================================================================
    /// TEST 1: Add to favorites
    /// ========================================================================
    test('should add pet to favorites when not already favorited', () async {
      // ARRANGE: Pet is NOT favorited
      when(() => mockLocalDataSource.isFavorite('1'))
          .thenAnswer((_) async => false);

      // Mock addToFavorites
      when(() => mockLocalDataSource.addToFavorites('1'))
          .thenAnswer((_) async => Future.value());

      // ACT: Toggle favorite
      final result = await repository.toggleFavorite(testPet);

      // ASSERT: Should return true (now favorited)
      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, true);

      // Verify correct methods called
      verify(() => mockLocalDataSource.isFavorite('1')).called(1);
      verify(() => mockLocalDataSource.addToFavorites('1')).called(1);
      verifyNever(() => mockLocalDataSource.removeFromFavorites('1'));
    });

    /// ========================================================================
    /// TEST 2: Remove from favorites
    /// ========================================================================
    test('should remove pet from favorites when already favorited', () async {
      // ARRANGE: Pet IS favorited
      when(() => mockLocalDataSource.isFavorite('1'))
          .thenAnswer((_) async => true);

      // Mock removeFromFavorites
      when(() => mockLocalDataSource.removeFromFavorites('1'))
          .thenAnswer((_) async => Future.value());

      // ACT: Toggle favorite
      final result = await repository.toggleFavorite(testPet);

      // ASSERT: Should return false (now unfavorited)
      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, false);

      // Verify correct methods called
      verify(() => mockLocalDataSource.isFavorite('1')).called(1);
      verify(() => mockLocalDataSource.removeFromFavorites('1')).called(1);
      verifyNever(() => mockLocalDataSource.addToFavorites('1'));
    });

    /// ========================================================================
    /// TEST 3: Storage error
    /// ========================================================================
    test('should return CacheFailure when storage fails', () async {
      // ARRANGE: Storage throws error
      when(() => mockLocalDataSource.isFavorite('1'))
          .thenThrow(Exception('Storage error'));

      // ACT: Try to toggle
      final result = await repository.toggleFavorite(testPet);

      // ASSERT: Should return cache error
      expect(result, isA<Error<bool>>());
      expect((result as Error<bool>).failure, isA<CacheFailure>());

      // Verify isFavorite was called
      verify(() => mockLocalDataSource.isFavorite('1')).called(1);
    });
  });

  /// ==========================================================================
  /// GROUP 4: isFavorite() Tests
  /// ==========================================================================
  /// Simple method that checks if a pet ID is favorited
  /// ==========================================================================
  group('isFavorite', () {
    test('should return true when pet is favorited', () async {
      // ARRANGE: Mock storage returns true
      when(() => mockLocalDataSource.isFavorite('1'))
          .thenAnswer((_) async => true);

      // ACT: Check if favorite
      final result = await repository.isFavorite('1');

      // ASSERT: Should return true
      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, true);
    });

    test('should return false when pet is not favorited', () async {
      // ARRANGE: Mock storage returns false
      when(() => mockLocalDataSource.isFavorite('1'))
          .thenAnswer((_) async => false);

      // ACT: Check if favorite
      final result = await repository.isFavorite('1');

      // ASSERT: Should return false
      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, false);
    });

    test('should return CacheFailure when storage fails', () async {
      // ARRANGE: Storage throws error
      when(() => mockLocalDataSource.isFavorite('1'))
          .thenThrow(Exception('Storage error'));

      // ACT: Try to check
      final result = await repository.isFavorite('1');

      // ASSERT: Should return error
      expect(result, isA<Error<bool>>());
      expect((result as Error<bool>).failure, isA<CacheFailure>());
    });
  });

  /// ==========================================================================
  /// GROUP 5: searchPets() Tests
  /// ==========================================================================
  /// Searches pets by name (case-insensitive)
  /// ==========================================================================
  group('searchPets', () {
    test('should return pets matching search query', () async {
      // ARRANGE: Mock API returns all pets
      when(() => mockRemoteDataSource.getPets())
          .thenAnswer((_) async => testPets);

      // ACT: Search for "aegean"
      final result = await repository.searchPets('aegean');

      // ASSERT: Should return only Aegean
      expect(result, isA<Success<List<Pet>>>());
      final successResult = result as Success<List<Pet>>;
      expect(successResult.data.length, 1);
      expect(successResult.data.first.name, 'Aegean');
    });

    test('should be case-insensitive', () async {
      // ARRANGE: Mock API returns all pets
      when(() => mockRemoteDataSource.getPets())
          .thenAnswer((_) async => testPets);

      // ACT: Search with different cases
      final result1 = await repository.searchPets('AEGEAN');
      final result2 = await repository.searchPets('aegean');
      final result3 = await repository.searchPets('AeGeAn');

      // ASSERT: All should find Aegean
      expect((result1 as Success<List<Pet>>).data.length, 1);
      expect((result2 as Success<List<Pet>>).data.length, 1);
      expect((result3 as Success<List<Pet>>).data.length, 1);
    });

    test('should return empty list when no match', () async {
      // ARRANGE: Mock API returns all pets
      when(() => mockRemoteDataSource.getPets())
          .thenAnswer((_) async => testPets);

      // ACT: Search for non-existent pet
      final result = await repository.searchPets('Persian');

      // ASSERT: Should return empty list
      expect(result, isA<Success<List<Pet>>>());
      final successResult = result as Success<List<Pet>>;
      expect(successResult.data, isEmpty);
    });

    test('should return ServerFailure when API fails', () async {
      // ARRANGE: Mock API throws error
      when(() => mockRemoteDataSource.getPets())
          .thenThrow(Exception('API Error'));

      // ACT: Try to search
      final result = await repository.searchPets('aegean');

      // ASSERT: Should return error
      expect(result, isA<Error<List<Pet>>>());
      expect((result as Error<List<Pet>>).failure, isA<ServerFailure>());
    });
  });
}

/// ============================================================================
/// WHAT YOU LEARNED - Repository Testing
/// ============================================================================
///
/// 1. TESTING WITH MULTIPLE DEPENDENCIES:
///    - Repository has 2 dependencies: remote + local data sources
///    - We mock BOTH to isolate repository logic
///    - Tests run without real API or storage
///
/// 2. TESTING DATA SYNCHRONIZATION:
///    - getPets() fetches from API, syncs with local favorites
///    - We test if favorites are correctly merged
///    - Example: API has 67 cats, local has IDs [1,5,12] favorited
///              → Repository marks only those 3 as favorite
///
/// 3. VERIFY vs VERIFYNEVER:
///    - verify() = ensures method WAS called
///    - verifyNever() = ensures method was NOT called
///    - Example: If no favorites, don't call API unnecessarily
///
/// 4. TESTING BUSINESS LOGIC:
///    - toggleFavorite() has logic: check → add OR remove
///    - We test BOTH paths (add and remove)
///    - Tests ensure logic works correctly
///
/// 5. ERROR HANDLING FROM MULTIPLE SOURCES:
///    - API can fail → ServerFailure
///    - Storage can fail → CacheFailure
///    - Repository must handle both correctly
///
/// ============================================================================
/// WHY REPOSITORY TESTS ARE CRITICAL:
/// ============================================================================
///
/// Bug Example: "Favorites don't persist after restarting app!"
///
/// WITHOUT TESTS:
/// - Is it the repository? The local data source? The remote?
/// - Hours of debugging through layers
///
/// WITH TESTS:
/// - Run: flutter test test/data/repositories/
/// - If tests pass → Bug is in UI or data sources
/// - If tests fail → Found the bug in repository!
///
/// Repository = Data Coordination Center
/// Tests = Ensure coordination works! 🎯
/// ============================================================================
