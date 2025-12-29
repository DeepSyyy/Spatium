import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

/// User Entity - Domain layer
/// Represents the core user business object
@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String publicId,
    required String alias,
    required String recoveryCode,
    required DateTime createdAt,
    DateTime? lastLogin,
  }) = _UserEntity;

  const UserEntity._();

  // Helper methods
  bool get hasLoggedIn => lastLogin != null;
  
  String get displayName => alias;
}
