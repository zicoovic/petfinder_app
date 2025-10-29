import 'package:petfinder_app/core/repositories/pet_repository.dart';

class UnAdoptPet {
  final PetRepository repository;
  UnAdoptPet(this.repository);

  Future<void> call(String petId) async {
    await repository.unAdoptPet(petId);
  }
}
