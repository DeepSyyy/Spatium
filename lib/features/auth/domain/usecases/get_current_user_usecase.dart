import 'package:dartz/dartz.dart';
import 'package:spatium/core/errors/failures.dart';
import 'package:spatium/features/auth/domain/entities/user_entity.dart';
import 'package:spatium/features/auth/domain/repositories/auth_repository.dart';

/// Get Current User Use Case
/// Retrieves currently logged in user
class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getCurrentUser();
  }
}
