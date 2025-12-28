// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_response_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthResponseEntity {
  String get token => throw _privateConstructorUsedError;
  String get publicId => throw _privateConstructorUsedError;
  String get alias => throw _privateConstructorUsedError;
  String get recoveryCode => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of AuthResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthResponseEntityCopyWith<AuthResponseEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResponseEntityCopyWith<$Res> {
  factory $AuthResponseEntityCopyWith(
    AuthResponseEntity value,
    $Res Function(AuthResponseEntity) then,
  ) = _$AuthResponseEntityCopyWithImpl<$Res, AuthResponseEntity>;
  @useResult
  $Res call({
    String token,
    String publicId,
    String alias,
    String recoveryCode,
    DateTime createdAt,
  });
}

/// @nodoc
class _$AuthResponseEntityCopyWithImpl<$Res, $Val extends AuthResponseEntity>
    implements $AuthResponseEntityCopyWith<$Res> {
  _$AuthResponseEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? publicId = null,
    Object? alias = null,
    Object? recoveryCode = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthResponseEntityImplCopyWith<$Res>
    implements $AuthResponseEntityCopyWith<$Res> {
  factory _$$AuthResponseEntityImplCopyWith(
    _$AuthResponseEntityImpl value,
    $Res Function(_$AuthResponseEntityImpl) then,
  ) = __$$AuthResponseEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String token,
    String publicId,
    String alias,
    String recoveryCode,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$AuthResponseEntityImplCopyWithImpl<$Res>
    extends _$AuthResponseEntityCopyWithImpl<$Res, _$AuthResponseEntityImpl>
    implements _$$AuthResponseEntityImplCopyWith<$Res> {
  __$$AuthResponseEntityImplCopyWithImpl(
    _$AuthResponseEntityImpl _value,
    $Res Function(_$AuthResponseEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? publicId = null,
    Object? alias = null,
    Object? recoveryCode = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$AuthResponseEntityImpl(
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
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
      ),
    );
  }
}

/// @nodoc

class _$AuthResponseEntityImpl extends _AuthResponseEntity {
  const _$AuthResponseEntityImpl({
    required this.token,
    required this.publicId,
    required this.alias,
    required this.recoveryCode,
    required this.createdAt,
  }) : super._();

  @override
  final String token;
  @override
  final String publicId;
  @override
  final String alias;
  @override
  final String recoveryCode;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'AuthResponseEntity(token: $token, publicId: $publicId, alias: $alias, recoveryCode: $recoveryCode, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResponseEntityImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.publicId, publicId) ||
                other.publicId == publicId) &&
            (identical(other.alias, alias) || other.alias == alias) &&
            (identical(other.recoveryCode, recoveryCode) ||
                other.recoveryCode == recoveryCode) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, token, publicId, alias, recoveryCode, createdAt);

  /// Create a copy of AuthResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResponseEntityImplCopyWith<_$AuthResponseEntityImpl> get copyWith =>
      __$$AuthResponseEntityImplCopyWithImpl<_$AuthResponseEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _AuthResponseEntity extends AuthResponseEntity {
  const factory _AuthResponseEntity({
    required final String token,
    required final String publicId,
    required final String alias,
    required final String recoveryCode,
    required final DateTime createdAt,
  }) = _$AuthResponseEntityImpl;
  const _AuthResponseEntity._() : super._();

  @override
  String get token;
  @override
  String get publicId;
  @override
  String get alias;
  @override
  String get recoveryCode;
  @override
  DateTime get createdAt;

  /// Create a copy of AuthResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthResponseEntityImplCopyWith<_$AuthResponseEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
