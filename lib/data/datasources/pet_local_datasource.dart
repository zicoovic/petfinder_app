import 'package:shared_preferences/shared_preferences.dart';

/// Abstract class defining the contract for local data operations
abstract class PetLocalDatasource {
  Future<void> addToFavorites(String petId);
  Future<void> removeFromFavorites(String petId);
  Future<List<String>> getFavoritePets();
  Future<bool> isFavorite(String petId);
}

/// Implementation of PetLocalDatasource using SharedPreferences
class PetLocalDataSourceImpl implements PetLocalDatasource {
  final SharedPreferences sharedPreferences;

  PetLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> addToFavorites(String petId) async {
  List<String> currentFavorites = sharedPreferences.getStringList('favoritePets') ?? [];
    currentFavorites.add(petId);
    await sharedPreferences.setStringList('favoritePets', currentFavorites);
  }

  @override
  Future<void> removeFromFavorites(String petId) async {
    List<String> currentFavorites = sharedPreferences.getStringList('favoritePets') ?? [];
    currentFavorites.remove(petId);
    await sharedPreferences.setStringList('favoritePets', currentFavorites);
  }

  @override
  Future<List<String>> getFavoritePets() async {
    List<String> favorites = sharedPreferences.getStringList('favoritePets') ?? [];
    return favorites;
  }

  @override
  Future<bool> isFavorite(String petId) async {
  List<String> favorites = sharedPreferences.getStringList('favoritePets') ?? [];
  return favorites.contains(petId); 
  }
}