import '../entities/pet.dart';
import '../repositories/pet_repository.dart';

/// Use Case: Get all pets from remote source
///
/// This use case fetches all available pets from the API
/// Returns: `Result<List<Pet>>` - Success with pets list or Error with failure
///
/// Example usage:
/// ```dart
/// final getPets = GetPets(repository);
/// final result = await getPets();
/// ```
class GetPets {
  final PetRepository repository;

  GetPets(this.repository);

  Future<Result<List<Pet>>> call() async {
    return await repository.getPets();
  }
}
