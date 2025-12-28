// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UserEntity {
  String get publicId => throw _privateConstructorUsedError;
  String get alias => throw _privateConstructorUsedError;
  String get recoveryCode => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastLogin => throw _privateConstructorUsedError;

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserEntityCopyWith<UserEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserEntityCopyWith<$Res> {
  factory $UserEntityCopyWith(
    UserEntity value,
    $Res Function(UserEntity) then,
  ) = _$UserEntityCopyWithImpl<$Res, UserEntity>;
  @useResult
  $Res call({
    String publicId,
    String alias,
    String recoveryCode,
    DateTime createdAt,
    DateTime? lastLogin,
  });
}

/// @nodoc
class _$UserEntityCopyWithImpl<$Res, $Val extends UserEntity>
    implements $UserEntityCopyWith<$Res> {
  _$UserEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserEntity
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
abstract class _$$UserEntityImplCopyWith<$Res>
    implements $UserEntityCopyWith<$Res> {
  factory _$$UserEntityImplCopyWith(
    _$UserEntityImpl value,
    $Res Function(_$UserEntityImpl) then,
  ) = __$$UserEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String publicId,
    String alias,
    String recoveryCode,
    DateTime createdAt,
    DateTime? lastLogin,
  });
}

/// @nodoc
class __$$UserEntityImplCopyWithImpl<$Res>
    extends _$UserEntityCopyWithImpl<$Res, _$UserEntityImpl>
    implements _$$UserEntityImplCopyWith<$Res> {
  __$$UserEntityImplCopyWithImpl(
    _$UserEntityImpl _value,
    $Res Function(_$UserEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEntity
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
      _$UserEntityImpl(
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

class _$UserEntityImpl extends _UserEntity {
  const _$UserEntityImpl({
    required this.publicId,
    required this.alias,
    required this.recoveryCode,
    required this.createdAt,
    this.lastLogin,
  }) : super._();

  @override
  final String publicId;
  @override
  final String alias;
  @override
  final String recoveryCode;
  @override
  final DateTime createdAt;
  @override
  final DateTime? lastLogin;

  @override
  String toString() {
    return 'UserEntity(publicId: $publicId, alias: $alias, recoveryCode: $recoveryCode, createdAt: $createdAt, lastLogin: $lastLogin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserEntityImpl &&
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

  @override
  int get hashCode => Object.hash(
    runtimeType,
    publicId,
    alias,
    recoveryCode,
    createdAt,
    lastLogin,
  );

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserEntityImplCopyWith<_$UserEntityImpl> get copyWith =>
      __$$UserEntityImplCopyWithImpl<_$UserEntityImpl>(this, _$identity);
}

abstract class _UserEntity extends UserEntity {
  const factory _UserEntity({
    required final String publicId,
    required final String alias,
    required final String recoveryCode,
    required final DateTime createdAt,
    final DateTime? lastLogin,
  }) = _$UserEntityImpl;
  const _UserEntity._() : super._();

  @override
  String get publicId;
  @override
  String get alias;
  @override
  String get recoveryCode;
  @override
  DateTime get createdAt;
  @override
  DateTime? get lastLogin;

  /// Create a copy of UserEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserEntityImplCopyWith<_$UserEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
