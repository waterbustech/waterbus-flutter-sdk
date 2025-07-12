// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_subscribed_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrackSubscribedMessage _$TrackSubscribedMessageFromJson(
        Map<String, dynamic> json) =>
    _TrackSubscribedMessage(
      trackId: json['trackId'] as String,
      subscribedCount: (json['subscribedCount'] as num).toInt(),
      quality: $enumDecode(_$TrackQualityEnumMap, json['quality']),
      timestamp: (json['timestamp'] as num).toInt(),
    );

Map<String, dynamic> _$TrackSubscribedMessageToJson(
        _TrackSubscribedMessage instance) =>
    <String, dynamic>{
      'trackId': instance.trackId,
      'subscribedCount': instance.subscribedCount,
      'quality': _$TrackQualityEnumMap[instance.quality]!,
      'timestamp': instance.timestamp,
    };

const _$TrackQualityEnumMap = {
  TrackQuality.none: 0,
  TrackQuality.low: 1,
  TrackQuality.medium: 2,
  TrackQuality.high: 3,
};
