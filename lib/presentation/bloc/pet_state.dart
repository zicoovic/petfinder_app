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
  final List<Pet> pets;

  const PetLoaded(this.pets);

  @override
  List<Object?> get props => [pets];
}

class PetError extends PetState {
  final String message;

  const PetError(this.message);

  @override
  List<Object?> get props => [message];
}
