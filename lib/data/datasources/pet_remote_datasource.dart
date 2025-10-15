import '../models/pet_model.dart';
import 'api_service.dart';

/// Abstract class defining the contract for remote data operations
abstract class PetRemoteDataSource {
  Future<List<PetModel>> getPets();
}

/// Implementation of PetRemoteDataSource using The Cat API
class PetRemoteDataSourceImpl implements PetRemoteDataSource {
  final ApiService apiService;

  PetRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<PetModel>> getPets() async {
    final response = await apiService.get('/breeds');

    // API returns List directly, not wrapped in object
    final List<dynamic> data = response.data as List;

    return data.map((json) => PetModel.fromJson(json)).toList();
  }
}
