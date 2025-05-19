// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthPayload _$AuthPayloadFromJson(Map<String, dynamic> json) => _AuthPayload(
      fullName: json['fullName'] as String,
      externalId: json['externalId'] as String,
    );

Map<String, dynamic> _$AuthPayloadToJson(_AuthPayload instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'externalId': instance.externalId,
    };
