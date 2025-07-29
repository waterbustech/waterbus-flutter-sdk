// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ice_server.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IceServer _$IceServerFromJson(Map<String, dynamic> json) => _IceServer(
      urls: (json['urls'] as List<dynamic>).map((e) => e as String).toList(),
      username: json['username'] as String?,
      credential: json['credential'] as String?,
    );

Map<String, dynamic> _$IceServerToJson(_IceServer instance) =>
    <String, dynamic>{
      'urls': instance.urls,
      'username': instance.username,
      'credential': instance.credential,
    };
