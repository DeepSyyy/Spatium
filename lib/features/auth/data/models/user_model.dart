import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spatium/features/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User Model - Data layer
/// Handles JSON serialization for API responses
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: 'public_id') required String publicId,
    required String alias,
    @JsonKey(name: 'recovery_code') required String recoveryCode,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'last_login') DateTime? lastLogin,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Convert model to entity
  UserEntity toEntity() {
    return UserEntity(
      publicId: publicId,
      alias: alias,
      recoveryCode: recoveryCode,
      createdAt: createdAt,
      lastLogin: lastLogin,
    );
  }

  /// Create model from entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      publicId: entity.publicId,
      alias: entity.alias,
      recoveryCode: entity.recoveryCode,
      createdAt: entity.createdAt,
      lastLogin: entity.lastLogin,
    );
  }
}
