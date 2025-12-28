import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spatium/features/auth/data/models/user_model.dart';
import 'package:spatium/features/auth/domain/entities/auth_response_entity.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

/// Auth Response Model - Data layer
/// Handles JSON serialization for authentication responses
@freezed
class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    required String token,
    required UserModel user,
  }) = _AuthResponseModel;

  const AuthResponseModel._();

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  /// Convert model to entity
  AuthResponseEntity toEntity() {
    return AuthResponseEntity(
      token: token,
      publicId: user.publicId,
      alias: user.alias,
      recoveryCode: user.recoveryCode,
      createdAt: user.createdAt,
    );
  }
}
