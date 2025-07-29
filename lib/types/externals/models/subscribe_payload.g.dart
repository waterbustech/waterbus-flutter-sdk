// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubscribePayload _$SubscribePayloadFromJson(Map<String, dynamic> json) =>
    _SubscribePayload(
      roomId: json['roomId'] as String,
      participantId: json['participantId'] as String,
      targetId: json['targetId'] as String,
      isIpv6Supported: json['isIpv6Supported'] as bool? ?? false,
    );

Map<String, dynamic> _$SubscribePayloadToJson(_SubscribePayload instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'participantId': instance.participantId,
      'targetId': instance.targetId,
      'isIpv6Supported': instance.isIpv6Supported,
    };
