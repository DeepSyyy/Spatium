import 'package:dartz/dartz.dart';
import 'package:spatium/core/errors/failures.dart';
import 'package:spatium/features/auth/domain/entities/auth_response_entity.dart';
import 'package:spatium/features/auth/domain/repositories/auth_repository.dart';

/// Register Use Case
/// Handles user registration business logic
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, AuthResponseEntity>> call(String alias) async {
    return await repository.register(alias);
  }
}
