import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petfinder_app/core/usecases/adopt_pet.dart';
import 'package:petfinder_app/core/usecases/get_adopted_pets.dart';
import 'package:petfinder_app/core/usecases/unadopt_pet.dart';
import '../../core/repositories/pet_repository.dart';
import '../../core/usecases/get_favorites.dart';
import '../../core/usecases/get_pets.dart';
import '../../core/usecases/toggle_favorite.dart';
import '../../core/entities/pet.dart';
import 'pet_state.dart';

class PetCubit extends Cubit<PetState> {
  final GetPets getPetsUseCase;
  final GetFavorites getFavoritesUseCase;
  final ToggleFavorite toggleFavoriteUseCase;
  final GetAdoptedPets getAdoptedPetsUseCase;
  final AdoptPet adoptPetUseCase;
  final UnAdoptPet unAdoptPetUseCase;

  PetCubit({
    required this.getPetsUseCase,
    required this.getFavoritesUseCase,
    required this.toggleFavoriteUseCase,
    required this.getAdoptedPetsUseCase,
    required this.adoptPetUseCase,
    required this.unAdoptPetUseCase,
  }) : super(const PetInitial());

  Future<void> loadPets() async {
    emit(const PetLoading());
    try {
      final result = await getPetsUseCase();

      if (result is Success<List<Pet>>) {
        // Store all pets for filtering
        emit(PetLoaded(result.data, allPets: result.data));
      } else if (result is Error<List<Pet>>) {
        emit(PetError(result.failure.message));
      }
    } catch (e) {
      emit(PetError('Failed to load pets: $e'));
    }
  }

  Future<void> loadFavorites() async {
    emit(const PetLoading());
    try {
      final result = await getFavoritesUseCase();

      if (result is Success<List<Pet>>) {
        emit(PetLoaded(result.data));
      } else if (result is Error<List<Pet>>) {
        emit(PetError(result.failure.message));
      }
    } catch (e) {
      emit(PetError('Failed to load favorites: $e'));
    }
  }

  Future<void> loadAdoptedPets() async {
    emit(const PetLoading());
    try {
      final result = await getAdoptedPetsUseCase();

      if (result is Success<List<Pet>>) {
        emit(PetLoaded(result.data));
      } else if (result is Error<List<Pet>>) {
        emit(PetError(result.failure.message));
      }
    } catch (e) {
      emit(PetError('Failed to load adopted pets: $e'));
    }
  }

  Future<void> adoptPet(Pet pet) async {
    try {
      await adoptPetUseCase(pet.id);
    } catch (e) {
      emit(PetError('Failed to adopt pet: $e'));
    }
  }

  Future<void> unAdoptPet(Pet pet) async {
    try {
      await unAdoptPetUseCase(pet.id);

      // Refresh the adopted pets list to remove the unadopted pet
      final currentState = state;
      if (currentState is PetLoaded) {
        final updatedPets = currentState.pets
            .where((p) => p.id != pet.id)
            .toList();
        emit(PetLoaded(updatedPets));
      }
    } catch (e) {
      emit(PetError('Failed to unadopt pet: $e'));
    }
  }

  Future<void> toggleFavoriteStatus(Pet pet) async {
    try {
      final result = await toggleFavoriteUseCase(pet);

      if (result is Success<bool>) {
        // Get the current state
        final currentState = state;

        // If we have pets loaded, update the list
        if (currentState is PetLoaded) {
          final updatedPets = currentState.pets.map((p) {
            if (p.id == pet.id) {
              return p.copyWith(isFavorite: result.data);
            }
            return p;
          }).toList();

          // Also update allPets if it exists
          final updatedAllPets = currentState.allPets?.map((p) {
            if (p.id == pet.id) {
              return p.copyWith(isFavorite: result.data);
            }
            return p;
          }).toList();

          emit(PetLoaded(updatedPets, allPets: updatedAllPets));
        }
      } else if (result is Error<bool>) {
        emit(PetError(result.failure.message));
      }
    } catch (e) {
      emit(PetError('Failed to toggle favorite status: $e'));
    }
  }

  Future<void> searchPets(String query) async {
    if (query.isEmpty) {
      loadPets();
      return;
    }

    emit(const PetLoading());
    try {
      final result = await getPetsUseCase();

      if (result is Success<List<Pet>>) {
        final filteredPets = result.data
            .where(
              (pet) => pet.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
        emit(PetLoaded(filteredPets));
      } else if (result is Error<List<Pet>>) {
        emit(PetError(result.failure.message));
      }
    } catch (e) {
      emit(PetError('Failed to search pets: $e'));
    }
  }

  /// Filter pets by breed name
  /// If breed is "All", shows all pets
  /// Otherwise, shows only pets matching that breed
  Future<void> filterByBreed(String breed) async {
    final currentState = state;

    // Get all pets from current state or fetch from API
    List<Pet> allPets = [];

    if (currentState is PetLoaded && currentState.allPets != null) {
      // Use cached all pets
      allPets = currentState.allPets!;
    } else {
      // Fetch from API
      emit(const PetLoading());
      try {
        final result = await getPetsUseCase();
        if (result is Success<List<Pet>>) {
          allPets = result.data;
        } else if (result is Error<List<Pet>>) {
          emit(PetError(result.failure.message));
          return;
        }
      } catch (e) {
        emit(PetError('Failed to filter pets: $e'));
        return;
      }
    }

    // Filter pets
    if (breed == 'All') {
      // Show all pets
      emit(PetLoaded(allPets, allPets: allPets));
    } else {
      // Filter by breed
      final filteredPets = allPets.where((pet) => pet.name == breed).toList();
      emit(PetLoaded(filteredPets, allPets: allPets));
    }
  }
}
