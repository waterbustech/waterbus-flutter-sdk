// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_payload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthPayloadModel _$AuthPayloadModelFromJson(Map<String, dynamic> json) =>
    _AuthPayloadModel(
      fullName: json['fullName'] as String,
      authId: json['authId'] as String?,
    );

Map<String, dynamic> _$AuthPayloadModelToJson(_AuthPayloadModel instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'authId': instance.authId,
    };
