import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Data Sources
import '../../data/datasources/api_service.dart';
import '../../data/datasources/pet_local_datasource.dart';
import '../../data/datasources/pet_remote_datasource.dart';

// Repository
import '../../data/repositories/pet_repository_impl.dart';
import '../repositories/pet_repository.dart';

// Use Cases
import '../usecases/get_pets.dart';
import '../usecases/get_favorites.dart';
import '../usecases/toggle_favorite.dart';

// BLoC
import '../../presentation/bloc/pet_cubit.dart';

final injectionContainer = GetIt.instance;

Future<void> init() async {
  // Cubit
  injectionContainer.registerFactory(
    () => PetCubit(
      getPetsUseCase: injectionContainer(),
      getFavoritesUseCase: injectionContainer(),
      toggleFavoriteUseCase: injectionContainer(),
    ),
  );

  // Use Cases
  injectionContainer.registerFactory(() => GetPets(injectionContainer()));
  injectionContainer.registerFactory(() => GetFavorites(injectionContainer()));
  injectionContainer.registerFactory(() => ToggleFavorite(injectionContainer()));

  // Repository
  injectionContainer.registerLazySingleton<PetRepository>(
    () => PetRepositoryImpl(
      remoteDataSource: injectionContainer(),
      localDataSource: injectionContainer(),
    ),
  );

  // Data Sources
  injectionContainer.registerLazySingleton<PetRemoteDataSource>(
    () => PetRemoteDataSourceImpl(injectionContainer()),
  );

  injectionContainer.registerLazySingleton<PetLocalDataSource>(
    () => PetLocalDataSourceImpl(injectionContainer()),
  );

  // Core
  injectionContainer.registerLazySingleton(() => ApiService());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  injectionContainer.registerLazySingleton(() => sharedPreferences);
}