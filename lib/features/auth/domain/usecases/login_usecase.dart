import 'package:dartz/dartz.dart';
import 'package:spatium/core/errors/failures.dart';
import 'package:spatium/features/auth/domain/entities/auth_response_entity.dart';
import 'package:spatium/features/auth/domain/repositories/auth_repository.dart';

/// Login Use Case
/// Handles user login business logic
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, AuthResponseEntity>> call(String recoveryCode) async {
    return await repository.login(recoveryCode);
  }
}
