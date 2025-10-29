import 'package:petfinder_app/core/entities/pet.dart';
import 'package:petfinder_app/core/repositories/pet_repository.dart';

class GetAdoptedPets {
  final PetRepository repository;
  GetAdoptedPets(this.repository);
  Future<Result<List<Pet>>> call() async {
    return await repository.getAdoptedPets();
  }
}
