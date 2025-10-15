import '../entities/pet.dart';
import '../repositories/pet_repository.dart';

/// Use Case: Get favorite pets from local storage
///
/// This use case fetches all pets that user has marked as favorite
/// Returns: `Result<List<Pet>>` - Success with favorite pets or Error with failure
///
/// Example usage:
/// ```dart
/// final getFavorites = GetFavorites(repository);
/// final result = await getFavorites();
/// ```
class GetFavorites {
  final PetRepository repository;

  GetFavorites(this.repository);

  Future<Result<List<Pet>>> call() async {
    return await repository.getFavoritePets();
  }
}
