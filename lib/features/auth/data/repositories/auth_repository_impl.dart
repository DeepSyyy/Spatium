import 'package:dartz/dartz.dart';
import 'package:spatium/core/errors/exceptions.dart';
import 'package:spatium/core/errors/failures.dart';
import 'package:spatium/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:spatium/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:spatium/features/auth/domain/entities/auth_response_entity.dart';
import 'package:spatium/features/auth/domain/entities/user_entity.dart';
import 'package:spatium/features/auth/domain/repositories/auth_repository.dart';

/// Auth Repository Implementation
/// Implements the auth repository interface with actual data operations
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthResponseEntity>> register(String alias) async {
    try {
      // Validate input
      if (alias.trim().isEmpty) {
        return const Left(
          ValidationFailure(message: 'Alias tidak boleh kosong'),
        );
      }

      if (alias.length < 3) {
        return const Left(
          ValidationFailure(message: 'Alias minimal 3 karakter'),
        );
      }

      // Call API
      final response = await remoteDataSource.register(alias);

      // Cache auth data
      await localDataSource.cacheAuthData(
        token: response.token,
        userId: response.user.publicId,
        alias: response.user.alias,
        recoveryCode: response.user.recoveryCode,
      );

      // Cache user data
      await localDataSource.cacheUser(response.user);

      return Right(response.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(
        message: 'Terjadi kesalahan: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> login(String recoveryCode) async {
    try {
      // Validate input
      if (recoveryCode.trim().isEmpty) {
        return const Left(
          ValidationFailure(message: 'Recovery code tidak boleh kosong'),
        );
      }

      // Call API
      final response = await remoteDataSource.login(recoveryCode);

      // Cache auth data
      await localDataSource.cacheAuthData(
        token: response.token,
        userId: response.user.publicId,
        alias: response.user.alias,
        recoveryCode: response.user.recoveryCode,
      );

      // Cache user data
      await localDataSource.cacheUser(response.user);

      return Right(response.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(
        message: 'Terjadi kesalahan: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      if (user != null) {
        return Right(user);
      } else {
        return const Left(
          CacheFailure(message: 'User data tidak ditemukan'),
        );
      }
    } catch (e) {
      return Left(CacheFailure(
        message: 'Gagal mengambil data user: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearAuthData();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(
        message: 'Gagal logout: ${e.toString()}',
      ));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await localDataSource.isLoggedIn();
    } catch (e) {
      return false;
    }
  }
}
