import 'package:petfinder_app/core/repositories/pet_repository.dart';

class AdoptPet {
  final PetRepository repository;
  AdoptPet(this.repository);

  Future<void> call(String petId) async {
    await repository.adoptPet(petId);
  }
}
