// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      publicId: json['public_id'] as String,
      alias: json['alias'] as String,
      recoveryCode: json['recovery_code'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastLogin: json['last_login'] == null
          ? null
          : DateTime.parse(json['last_login'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'public_id': instance.publicId,
      'alias': instance.alias,
      'recovery_code': instance.recoveryCode,
      'created_at': instance.createdAt.toIso8601String(),
      'last_login': instance.lastLogin?.toIso8601String(),
    };
