import 'package:equatable/equatable.dart';
import '../../core/entities/pet.dart';

abstract class PetState extends Equatable {
  const PetState();

  @override
  List<Object?> get props => [];
}

class PetInitial extends PetState {
  const PetInitial();
}

class PetLoading extends PetState {
  const PetLoading();
}

class PetLoaded extends PetState {
  final List<Pet> pets;         // Currently displayed pets (filtered or all)
  final List<Pet>? allPets;     // All pets from API (for categories)

  const PetLoaded(this.pets, {this.allPets});

  @override
  List<Object?> get props => [pets, allPets];
}

class PetError extends PetState {
  final String message;

  const PetError(this.message);

  @override
  List<Object?> get props => [message];
}
