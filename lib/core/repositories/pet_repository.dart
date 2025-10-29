import '../entities/pet.dart';
import '../error/failures.dart';

/// Result wrapper for repository operations
/// Using sealed classes for better type safety (Dart 3)
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);
}

/// Abstract Pet Repository
/// Defines the contract for pet data operations
/// Implementation will be in the data layer
abstract class PetRepository {
  /// Get all pets from remote source
  Future<Result<List<Pet>>> getPets();

  /// Get favorite pets from local storage
  Future<Result<List<Pet>>> getFavoritePets();

  /// Toggle pet favorite status
  Future<Result<bool>> toggleFavorite(Pet pet);

  /// Check if pet is favorite
  Future<Result<bool>> isFavorite(String petId);

  /// Get adopted pets from local storage
  Future<Result<List<Pet>>> getAdoptedPets();

  /// Adopt a pet
  Future<void> adoptPet(String petId);

  /// unAdopt a pet
  Future<void> unAdoptPet(String petId);

  /// Search pets by name or breed
  Future<Result<List<Pet>>> searchPets(String query);
}
