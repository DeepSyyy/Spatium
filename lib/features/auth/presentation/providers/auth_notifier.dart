import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spatium/features/auth/domain/usecases/google_login.dart';
import 'package:spatium/features/auth/domain/usecases/login_usecase.dart';
import 'package:spatium/features/auth/domain/usecases/logout_usecase.dart';
import 'package:spatium/features/auth/domain/usecases/register_usecase.dart';
import 'package:spatium/features/auth/presentation/providers/auth_providers.dart';
import 'package:spatium/features/auth/presentation/providers/auth_state.dart';

/// Auth Notifier
/// Manages authentication state and actions
class AuthNotifier extends StateNotifier<AuthState> {
  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;
  final GoogleLoginUseCase _googleLoginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthNotifier(
    this._registerUseCase,
    this._loginUseCase,
    this._googleLoginUseCase,
    this._logoutUseCase,
    this._getCurrentUserUseCase,
  ) : super(const AuthState.initial());

  /// Register a new user
  Future<void> register(String alias) async {
    state = const AuthState.loading();

    final result = await _registerUseCase(alias);

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (authResponse) => state = AuthState.authenticated(authResponse),
    );
  }

  /// Login with recovery code
  Future<void> login(String recoveryCode) async {
    state = const AuthState.loading();

    final result = await _loginUseCase(recoveryCode);

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (authResponse) => state = AuthState.authenticated(authResponse),
    );
  }

  /// Login with Google
  Future<void> googleLogin({
    required String googleId,
    required String email,
    String? alias,
    String? photoUrl,
  }) async {
    state = const AuthState.loading();

    final result = await _googleLoginUseCase(
      googleId: googleId,
      email: email,
      alias: alias,
      photoUrl: photoUrl,
    );

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (authResponse) => state = AuthState.authenticated(authResponse),
    );
  }

  /// Logout
  Future<void> logout() async {
    state = const AuthState.loading();

    final result = await _logoutUseCase();

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (_) => state = const AuthState.unauthenticated(),
    );
  }

  /// Check current authentication status
  Future<void> checkAuthStatus() async {
    final result = await _getCurrentUserUseCase();

    result.fold(
      (failure) => state = const AuthState.unauthenticated(),
      (user) {
        // If user exists in cache, create a minimal auth response
        // Note: We don't have the token here, but user is authenticated
        state = const AuthState.unauthenticated(); // Will be updated on next login
      },
    );
  }

  /// Reset to initial state
  void reset() {
    state = const AuthState.initial();
  }
}

/// Auth Notifier Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(registerUseCaseProvider),
    ref.watch(loginUseCaseProvider),
    ref.watch(googleLoginUseCaseProvider),
    ref.watch(logoutUseCaseProvider),
    ref.watch(getCurrentUserUseCaseProvider),
  );
});
