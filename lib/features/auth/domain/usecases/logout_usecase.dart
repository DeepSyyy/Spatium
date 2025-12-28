import 'package:dartz/dartz.dart';
import 'package:spatium/core/errors/failures.dart';
import 'package:spatium/features/auth/domain/repositories/auth_repository.dart';

/// Logout Use Case
/// Handles user logout business logic
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}
