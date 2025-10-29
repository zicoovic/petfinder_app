import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

/// Abstract class defining the contract for local data operations
abstract class PetLocalDataSource {
  Future<void> addToFavorites(String petId);
  Future<void> removeFromFavorites(String petId);
  Future<List<String>> getFavoritePets();
  Future<bool> isFavorite(String petId);
  Future<void> adoptPet(String petId);
  Future<void> unAdoptPet(String petId);
  Future<List<String>> getAdoptedPets();
}

/// Implementation of PetLocalDataSource using SharedPreferences
class PetLocalDataSourceImpl implements PetLocalDataSource {
  final SharedPreferences sharedPreferences;

  PetLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> addToFavorites(String petId) async {
    List<String> currentFavorites =
        sharedPreferences.getStringList(AppConstants.favoritesKey) ?? [];

    // Avoid duplicates
    if (!currentFavorites.contains(petId)) {
      currentFavorites.add(petId);
      await sharedPreferences.setStringList(
        AppConstants.favoritesKey,
        currentFavorites,
      );
    }
  }

  @override
  Future<void> removeFromFavorites(String petId) async {
    List<String> currentFavorites =
        sharedPreferences.getStringList(AppConstants.favoritesKey) ?? [];
    currentFavorites.remove(petId);
    await sharedPreferences.setStringList(
      AppConstants.favoritesKey,
      currentFavorites,
    );
  }

  @override
  Future<List<String>> getFavoritePets() async {
    return sharedPreferences.getStringList(AppConstants.favoritesKey) ?? [];
  }

  @override
  Future<bool> isFavorite(String petId) async {
    List<String> favorites =
        sharedPreferences.getStringList(AppConstants.favoritesKey) ?? [];
    return favorites.contains(petId);
  }

  @override
  Future<void> adoptPet(String petId) async {
    List<String> currentAdopted =
        sharedPreferences.getStringList(AppConstants.adoptedKey) ?? [];

    // Avoid duplicates
    if (!currentAdopted.contains(petId)) {
      currentAdopted.add(petId);
      await sharedPreferences.setStringList(
        AppConstants.adoptedKey,
        currentAdopted,
      );
    }
  }

  @override
  Future<List<String>> getAdoptedPets() async {
    return sharedPreferences.getStringList(AppConstants.adoptedKey) ?? [];
  }

  @override
  Future<void> unAdoptPet(String petId) async {
    List<String> currentAdopted =
        sharedPreferences.getStringList(AppConstants.adoptedKey) ?? [];
    currentAdopted.remove(petId);
    await sharedPreferences.setStringList(
      AppConstants.adoptedKey,
      currentAdopted,
    );
  }
}
