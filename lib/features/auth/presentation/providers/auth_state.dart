import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spatium/features/auth/domain/entities/auth_response_entity.dart';

part 'auth_state.freezed.dart';

/// Auth State
/// Represents the authentication state in the app
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(AuthResponseEntity authResponse) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}
