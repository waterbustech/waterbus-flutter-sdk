// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_payload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthPayloadModel _$AuthPayloadModelFromJson(Map<String, dynamic> json) =>
    _AuthPayloadModel(
      fullName: json['fullName'] as String,
      facebookId: json['facebookId'] as String?,
      googleId: json['googleId'] as String?,
      appleId: json['appleId'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$AuthPayloadModelToJson(_AuthPayloadModel instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'facebookId': instance.facebookId,
      'googleId': instance.googleId,
      'appleId': instance.appleId,
      'email': instance.email,
    };
