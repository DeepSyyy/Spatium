import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response_entity.freezed.dart';

/// Auth Response Entity - Domain layer
/// Represents authentication response with token and user data
@freezed
class AuthResponseEntity with _$AuthResponseEntity {
  const factory AuthResponseEntity({
    required String token,
    required String publicId,
    required String alias,
    required String recoveryCode,
    required DateTime createdAt,
  }) = _AuthResponseEntity;

  const AuthResponseEntity._();
}
