// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe_hls_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubscribeHlsPayload _$SubscribeHlsPayloadFromJson(Map<String, dynamic> json) =>
    _SubscribeHlsPayload(
      roomId: json['roomId'] as String,
      participantId: json['participantId'] as String,
      targetId: json['targetId'] as String,
    );

Map<String, dynamic> _$SubscribeHlsPayloadToJson(
        _SubscribeHlsPayload instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'participantId': instance.participantId,
      'targetId': instance.targetId,
    };
