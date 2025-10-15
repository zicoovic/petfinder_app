import '../entities/pet.dart';
import '../repositories/pet_repository.dart';

/// Use Case: Toggle pet favorite status
///
/// This use case adds a pet to favorites if not already added,
/// or removes it from favorites if already added
/// Returns: `Result<bool>` - Success with true/false or Error with failure
///
/// Example usage:
/// ```dart
/// final toggleFavorite = ToggleFavorite(repository);
/// final result = await toggleFavorite(pet);
/// ```
class ToggleFavorite {
  final PetRepository repository;

  ToggleFavorite(this.repository);

  Future<Result<bool>> call(Pet pet) async {
    return await repository.toggleFavorite(pet);
  }
}
