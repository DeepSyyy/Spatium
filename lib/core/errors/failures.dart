import 'package:dartz/dartz.dart';

/// Base Failure class for error handling
/// All failures should extend this class
abstract class Failure {
  final String message;
  final int? statusCode;
  final dynamic data;

  const Failure({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => message;
}

/// Server Failure - for API errors
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
    super.data,
  });

  factory ServerFailure.fromStatusCode(int statusCode, {String? message}) {
    switch (statusCode) {
      case 400:
        return ServerFailure(
          message: message ?? 'Bad request',
          statusCode: statusCode,
        );
      case 401:
        return ServerFailure(
          message: message ?? 'Unauthorized. Please login again',
          statusCode: statusCode,
        );
      case 403:
        return ServerFailure(
          message: message ?? 'Forbidden',
          statusCode: statusCode,
        );
      case 404:
        return ServerFailure(
          message: message ?? 'Not found',
          statusCode: statusCode,
        );
      case 422:
        return ServerFailure(
          message: message ?? 'Validation error',
          statusCode: statusCode,
        );
      case 500:
        return ServerFailure(
          message: message ?? 'Internal server error',
          statusCode: statusCode,
        );
      case 503:
        return ServerFailure(
          message: message ?? 'Service unavailable',
          statusCode: statusCode,
        );
      default:
        return ServerFailure(
          message: message ?? 'Something went wrong',
          statusCode: statusCode,
        );
    }
  }
}

/// Network Failure - for connection errors
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network',
  });
}

/// Cache Failure - for local storage errors
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to access local storage',
  });
}

/// Validation Failure - for form validation errors
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
  });
}

/// Unexpected Failure - for unknown errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred',
  });
}

/// Type alias for Either responses
typedef FailureOr<T> = Either<Failure, T>;
