/// Custom Exceptions
/// All exceptions should extend this base class
class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => message;
}

class ServerException extends AppException {
  ServerException({
    required super.message,
    super.statusCode,
  });
}

class NetworkException extends AppException {
  NetworkException({
    super.message = 'No internet connection',
  });
}

class CacheException extends AppException {
  CacheException({
    super.message = 'Cache error',
  });
}

class UnauthorizedException extends AppException {
  UnauthorizedException({
    super.message = 'Unauthorized',
    super.statusCode = 401,
  });
}

class ValidationException extends AppException {
  ValidationException({
    required super.message,
    super.statusCode = 422,
  });
}
