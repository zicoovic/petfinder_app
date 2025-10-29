import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:petfinder_app/core/entities/pet.dart';
import 'package:petfinder_app/core/error/failures.dart';
import 'package:petfinder_app/core/repositories/pet_repository.dart';
import 'package:petfinder_app/core/usecases/get_favorites.dart';
import 'package:petfinder_app/core/usecases/get_pets.dart';
import 'package:petfinder_app/core/usecases/toggle_favorite.dart';
import 'package:petfinder_app/core/usecases/adopt_pet.dart';
import 'package:petfinder_app/core/usecases/get_adopted_pets.dart';
import 'package:petfinder_app/core/usecases/unadopt_pet.dart';
import 'package:petfinder_app/presentation/bloc/pet_cubit.dart';
import 'package:petfinder_app/presentation/bloc/pet_state.dart';

// Mock classes - Fake versions of real classes for testing
class MockGetPets extends Mock implements GetPets {}

class MockGetFavorites extends Mock implements GetFavorites {}

class MockToggleFavorite extends Mock implements ToggleFavorite {}

class MockAdoptPet extends Mock implements AdoptPet {}

class MockGetAdoptedPets extends Mock implements GetAdoptedPets {}

class MockUnAdoptPet extends Mock implements UnAdoptPet {}

void main() {
  // Test setup - runs before each test
  late PetCubit cubit;
  late MockGetPets mockGetPets;
  late MockGetFavorites mockGetFavorites;
  late MockToggleFavorite mockToggleFavorite;
  late MockAdoptPet mockAdoptPet;
  late MockGetAdoptedPets mockGetAdoptedPets;
  late MockUnAdoptPet mockUnAdoptPet;

  // Sample test data
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

  setUp(() {
    // Create fresh mocks for each test
    mockGetPets = MockGetPets();
    mockGetFavorites = MockGetFavorites();
    mockToggleFavorite = MockToggleFavorite();
    mockAdoptPet = MockAdoptPet();
    mockGetAdoptedPets = MockGetAdoptedPets();
    mockUnAdoptPet = MockUnAdoptPet();

    // Create cubit with mocks
    cubit = PetCubit(
      getPetsUseCase: mockGetPets,
      getFavoritesUseCase: mockGetFavorites,
      toggleFavoriteUseCase: mockToggleFavorite,
      adoptPetUseCase: mockAdoptPet,
      getAdoptedPetsUseCase: mockGetAdoptedPets,
      unAdoptPetUseCase: mockUnAdoptPet,
    );
  });

  tearDown(() {
    // Clean up after each test
    cubit.close();
  });

  group('PetCubit Tests', () {
    test('initial state is PetInitial', () {
      // WHAT: Check cubit starts in correct state
      // WHY: Ensures app shows correct initial UI
      expect(cubit.state, const PetInitial());
    });

    test('loadPets emits [PetLoading, PetLoaded] when successful', () async {
      // ARRANGE: Setup mock to return success
      when(() => mockGetPets()).thenAnswer((_) async => Success(testPets));

      // ACT & ASSERT: Call method and check final state
      await cubit.loadPets();

      // Check final state
      expect(cubit.state, isA<PetLoaded>());
      final state = cubit.state as PetLoaded;
      expect(state.pets.length, 2);
      expect(state.allPets?.length, 2);
    });

    test('loadPets emits PetError when fails', () async {
      // ARRANGE: Setup mock to return error
      when(
        () => mockGetPets(),
      ).thenAnswer((_) async => const Error(ServerFailure()));

      // ACT
      await cubit.loadPets();

      // ASSERT: Check error state
      expect(cubit.state, isA<PetError>());
    });

    test('filterByBreed with "All" shows all pets', () async {
      // ARRANGE: Setup initial state with pets
      when(() => mockGetPets()).thenAnswer((_) async => Success(testPets));
      await cubit.loadPets();
      await Future.delayed(Duration.zero); // Wait for state to settle

      // ACT: Filter by "All"
      await cubit.filterByBreed('All');

      // ASSERT: Should show all pets
      expect(cubit.state, isA<PetLoaded>());
      final state = cubit.state as PetLoaded;
      expect(state.pets.length, 2);
      expect(state.allPets?.length, 2);
    });

    test('filterByBreed filters pets correctly', () async {
      // ARRANGE
      when(() => mockGetPets()).thenAnswer((_) async => Success(testPets));
      await cubit.loadPets();
      await Future.delayed(Duration.zero);

      // ACT: Filter by specific breed
      await cubit.filterByBreed('Abyssinian');

      // ASSERT: Should show only Abyssinian
      expect(cubit.state, isA<PetLoaded>());
      final state = cubit.state as PetLoaded;
      expect(state.pets.length, 1);
      expect(state.pets.first.name, 'Abyssinian');
      expect(state.allPets?.length, 2); // All pets still available
    });

    test('searchPets filters by name containing query', () async {
      // ARRANGE
      when(() => mockGetPets()).thenAnswer((_) async => Success(testPets));

      // ACT: Search for "aeg"
      await cubit.searchPets('aeg');

      // ASSERT: Should find "Aegean"
      expect(cubit.state, isA<PetLoaded>());
      final state = cubit.state as PetLoaded;
      expect(state.pets.length, 1);
      expect(state.pets.first.name, 'Aegean');
    });

    test('searchPets with empty query loads all pets', () async {
      // ARRANGE
      when(() => mockGetPets()).thenAnswer((_) async => Success(testPets));

      // ACT: Search with empty string
      await cubit.searchPets('');

      // ASSERT: Should load all pets
      expect(cubit.state, isA<PetLoaded>());
      final state = cubit.state as PetLoaded;
      expect(state.pets.length, 2);
    });

    test('toggleFavoriteStatus updates pet favorite status', () async {
      // ARRANGE: Load pets first
      when(() => mockGetPets()).thenAnswer((_) async => Success(testPets));
      await cubit.loadPets();
      await Future.delayed(Duration.zero);

      final petToToggle = testPets.first;

      // Mock toggle favorite to return true (favorited)
      when(
        () => mockToggleFavorite(petToToggle),
      ).thenAnswer((_) async => const Success(true));

      // ACT: Toggle favorite
      await cubit.toggleFavoriteStatus(petToToggle);

      // ASSERT: Pet should be favorited
      expect(cubit.state, isA<PetLoaded>());
      final state = cubit.state as PetLoaded;
      final updatedPet = state.pets.firstWhere((p) => p.id == '1');
      expect(updatedPet.isFavorite, true);
    });
  });
}
