import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';

/// API Service for handling HTTP requests using Dio
class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
        queryParameters: {'api_key': AppConstants.apiKey},
      ),
    );
  }

  /// Performs GET request
  Future<Response> get(String endpoint) async {
    return await _dio.get(endpoint);
  }

  /// Performs POST request
  Future<Response> post(String endpoint, {dynamic data}) async {
    return await _dio.post(endpoint, data: data);
  }
}
