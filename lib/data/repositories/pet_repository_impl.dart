import 'package:petfinder_app/core/entities/pet.dart';
import 'package:petfinder_app/core/repositories/pet_repository.dart';
import 'package:petfinder_app/data/datasources/pet_local_datasource.dart';
import 'package:petfinder_app/data/datasources/pet_remote_datasource.dart';
import 'package:petfinder_app/core/error/failures.dart';

class PetRepositoryImpl implements PetRepository {
  final PetRemoteDataSource remoteDataSource;
  final PetLocalDataSource localDataSource;

  PetRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  @override
  Future<Result<List<Pet>>> getFavoritePets() async {
    try {
      final favoriteIds = await localDataSource.getFavoritePets();
      if (favoriteIds.isEmpty) {
        return const Success([]);
      }
      final allPets = await remoteDataSource.getPets();
      final favoritePets = allPets
          .where((pet) => favoriteIds.contains(pet.id))
          .toList();

      return Success(favoritePets);
    } catch (_) {
      return const Error(ServerFailure());
    }
  }

  @override
  Future<Result<List<Pet>>> getPets() async {
    try {
      final pets = await remoteDataSource.getPets();
      return Success(pets);
    } catch (_) {
      return const Error(ServerFailure());
    }
  }

  @override
  Future<Result<bool>> isFavorite(String petId) async {
    try {
      final isFav = await localDataSource.isFavorite(petId);
      return Success(isFav);
    } catch (_) {
      return const Error(CacheFailure());
    }
  }

  @override
  Future<Result<List<Pet>>> searchPets(String query) async {
    try {
      final pets = await remoteDataSource.getPets();

      final filteredPets = pets
          .where((pet) => pet.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return Success(filteredPets);
    } catch (_) {
      return const Error(ServerFailure());
    }
  }

  @override
  Future<Result<bool>> toggleFavorite(Pet pet) async {
    try {
      final isFav = await localDataSource.isFavorite(pet.id);
      if (isFav) {
        await localDataSource.removeFromFavorites(pet.id);
        return const Success(false);
      } else {
        await localDataSource.addToFavorites(pet.id);
        return const Success(true);
      }
    } catch (_) {
      return const Error(CacheFailure());
    }
  }
}
