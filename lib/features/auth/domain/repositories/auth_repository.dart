import 'package:dartz/dartz.dart';
import 'package:spatium/core/errors/failures.dart';
import 'package:spatium/features/auth/domain/entities/auth_response_entity.dart';
import 'package:spatium/features/auth/domain/entities/user_entity.dart';

/// Auth Repository Interface - Domain layer
/// Defines the contract for authentication operations
abstract class AuthRepository {
  /// Register a new user
  Future<Either<Failure, AuthResponseEntity>> register(String alias);

  /// Login with recovery code
  Future<Either<Failure, AuthResponseEntity>> login(String recoveryCode);
  
  /// Login with Google
  Future<Either<Failure, AuthResponseEntity>> googleLogin({
    required String googleId,
    required String email,
    String? alias,
    String? photoUrl,
  });

  /// Get current user
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Logout
  Future<Either<Failure, void>> logout();

  /// Check if user is logged in
  Future<bool> isLoggedIn();
}
