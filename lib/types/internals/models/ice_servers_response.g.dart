// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ice_servers_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IceServersResponse _$IceServersResponseFromJson(Map<String, dynamic> json) =>
    _IceServersResponse(
      iceServers: (json['iceServers'] as List<dynamic>)
          .map((e) => IceServer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IceServersResponseToJson(_IceServersResponse instance) =>
    <String, dynamic>{
      'iceServers': instance.iceServers.map((e) => e.toJson()).toList(),
    };
