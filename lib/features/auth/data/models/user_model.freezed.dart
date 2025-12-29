// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  @JsonKey(name: 'public_id')
  String get publicId => throw _privateConstructorUsedError;
  String get alias => throw _privateConstructorUsedError;
  @JsonKey(name: 'recovery_code')
  String get recoveryCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_login')
  DateTime? get lastLogin => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'public_id') String publicId,
    String alias,
    @JsonKey(name: 'recovery_code') String recoveryCode,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'last_login') DateTime? lastLogin,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? publicId = null,
    Object? alias = null,
    Object? recoveryCode = null,
    Object? createdAt = null,
    Object? lastLogin = freezed,
  }) {
    return _then(
      _value.copyWith(
            publicId: null == publicId
                ? _value.publicId
                : publicId // ignore: cast_nullable_to_non_nullable
                      as String,
            alias: null == alias
                ? _value.alias
                : alias // ignore: cast_nullable_to_non_nullable
                      as String,
            recoveryCode: null == recoveryCode
                ? _value.recoveryCode
                : recoveryCode // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastLogin: freezed == lastLogin
                ? _value.lastLogin
                : lastLogin // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'public_id') String publicId,
    String alias,
    @JsonKey(name: 'recovery_code') String recoveryCode,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'last_login') DateTime? lastLogin,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? publicId = null,
    Object? alias = null,
    Object? recoveryCode = null,
    Object? createdAt = null,
    Object? lastLogin = freezed,
  }) {
    return _then(
      _$UserModelImpl(
        publicId: null == publicId
            ? _value.publicId
            : publicId // ignore: cast_nullable_to_non_nullable
                  as String,
        alias: null == alias
            ? _value.alias
            : alias // ignore: cast_nullable_to_non_nullable
                  as String,
        recoveryCode: null == recoveryCode
            ? _value.recoveryCode
            : recoveryCode // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastLogin: freezed == lastLogin
            ? _value.lastLogin
            : lastLogin // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl extends _UserModel {
  const _$UserModelImpl({
    @JsonKey(name: 'public_id') required this.publicId,
    required this.alias,
    @JsonKey(name: 'recovery_code') required this.recoveryCode,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'last_login') this.lastLogin,
  }) : super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  @JsonKey(name: 'public_id')
  final String publicId;
  @override
  final String alias;
  @override
  @JsonKey(name: 'recovery_code')
  final String recoveryCode;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'last_login')
  final DateTime? lastLogin;

  @override
  String toString() {
    return 'UserModel(publicId: $publicId, alias: $alias, recoveryCode: $recoveryCode, createdAt: $createdAt, lastLogin: $lastLogin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.publicId, publicId) ||
                other.publicId == publicId) &&
            (identical(other.alias, alias) || other.alias == alias) &&
            (identical(other.recoveryCode, recoveryCode) ||
                other.recoveryCode == recoveryCode) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastLogin, lastLogin) ||
                other.lastLogin == lastLogin));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    publicId,
    alias,
    recoveryCode,
    createdAt,
    lastLogin,
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel({
    @JsonKey(name: 'public_id') required final String publicId,
    required final String alias,
    @JsonKey(name: 'recovery_code') required final String recoveryCode,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'last_login') final DateTime? lastLogin,
  }) = _$UserModelImpl;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  @JsonKey(name: 'public_id')
  String get publicId;
  @override
  String get alias;
  @override
  @JsonKey(name: 'recovery_code')
  String get recoveryCode;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'last_login')
  DateTime? get lastLogin;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
