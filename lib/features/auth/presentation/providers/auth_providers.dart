import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/core/providers/core_providers.dart';
import 'package:spatium/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:spatium/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:spatium/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:spatium/features/auth/domain/repositories/auth_repository.dart';
import 'package:spatium/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spatium/features/auth/domain/usecases/google_login.dart';
import 'package:spatium/features/auth/domain/usecases/login_usecase.dart';
import 'package:spatium/features/auth/domain/usecases/logout_usecase.dart';
import 'package:spatium/features/auth/domain/usecases/register_usecase.dart';

// ============================================
// Data Sources
// ============================================

/// Auth Remote Data Source Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSourceImpl(apiClient);
});

/// Auth Local Data Source Provider
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final storageService = ref.watch(secureStorageServiceProvider);
  return AuthLocalDataSourceImpl(storageService);
});

// ============================================
// Repository
// ============================================

/// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

// ============================================
// Use Cases
// ============================================

/// Register Use Case Provider
final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
});

/// Login Use Case Provider
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

/// Google Login Use Case Provider
final googleLoginUseCaseProvider = Provider<GoogleLoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GoogleLoginUseCase(repository);
});

/// Logout Use Case Provider
final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
});

/// Get Current User Use Case Provider
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
});

// ============================================
// Check Login Status
// ============================================

/// Check if user is logged in
final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  return await repository.isLoggedIn();
});
