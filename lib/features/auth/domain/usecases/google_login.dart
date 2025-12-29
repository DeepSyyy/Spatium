import 'package:dartz/dartz.dart';
import 'package:spatium/core/errors/failures.dart';
import 'package:spatium/features/auth/domain/entities/auth_response_entity.dart';
import 'package:spatium/features/auth/domain/repositories/auth_repository.dart';

/// Google Login Use Case
/// Handles Google authentication business logic
class GoogleLoginUseCase {
  final AuthRepository repository;

  GoogleLoginUseCase(this.repository);

  Future<Either<Failure, AuthResponseEntity>> call({
    required String googleId,
    required String email,
    String? alias,
    String? photoUrl,
  }) async {
    return await repository.googleLogin(
      googleId: googleId,
      email: email,
      alias: alias,
      photoUrl: photoUrl,
    );
  }
}
