// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publish_ws_emitter_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PublishWsEmitterPayLoad _$PublishWsEmitterPayLoadFromJson(
        Map<String, dynamic> json) =>
    _PublishWsEmitterPayLoad(
      sdp: json['sdp'] as String,
      roomId: json['roomId'] as String,
      participantId: json['participantId'] as String,
      isVideoEnabled: json['isVideoEnabled'] as bool,
      isAudioEnabled: json['isAudioEnabled'] as bool,
      isE2eeEnabled: json['isE2eeEnabled'] as bool,
      totalTracks: (json['totalTracks'] as num).toInt(),
      connectionType:
          $enumDecode(_$ConnectionTypeEnumMap, json['connectionType']),
      streamingProtocol:
          $enumDecode(_$StreamingProtocolEnumMap, json['streamingProtocol']),
      isIpv6Supported: json['isIpv6Supported'] as bool? ?? false,
    );

Map<String, dynamic> _$PublishWsEmitterPayLoadToJson(
        _PublishWsEmitterPayLoad instance) =>
    <String, dynamic>{
      'sdp': instance.sdp,
      'roomId': instance.roomId,
      'participantId': instance.participantId,
      'isVideoEnabled': instance.isVideoEnabled,
      'isAudioEnabled': instance.isAudioEnabled,
      'isE2eeEnabled': instance.isE2eeEnabled,
      'totalTracks': instance.totalTracks,
      'connectionType': _$ConnectionTypeEnumMap[instance.connectionType]!,
      'streamingProtocol':
          _$StreamingProtocolEnumMap[instance.streamingProtocol]!,
      'isIpv6Supported': instance.isIpv6Supported,
    };

const _$ConnectionTypeEnumMap = {
  ConnectionType.p2p: 0,
  ConnectionType.sfu: 1,
};

const _$StreamingProtocolEnumMap = {
  StreamingProtocol.sfu: 0,
  StreamingProtocol.hls: 1,
};
