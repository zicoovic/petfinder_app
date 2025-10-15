import 'package:equatable/equatable.dart';

/// Base class for all failures in the app
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Server-related failures
/// When to use: API returns error codes (404, 500, etc.), Invalid response format
/// Example: GET /breeds returns 500 Internal Server Error
class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Unable to connect to the server. Please try again later.',
  ]);
}

/// Cache-related failures
/// When to use: SharedPreferences read/write fails, Data corruption in local storage
/// Example: Failed to save favorites list to device storage
class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'Failed to load saved data. Please restart the app.',
  ]);
}

/// Network-related failures
/// When to use: No internet connection, Request timeout, DNS resolution fails
/// Example: User is offline when trying to fetch pets from API
class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'No internet connection. Please check your network settings.',
  ]);
}

/// General failures
/// When to use: Unexpected errors that don't fit other categories
/// Example: JSON parsing fails, Null safety issues, Unknown exceptions
class GeneralFailure extends Failure {
  const GeneralFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}
