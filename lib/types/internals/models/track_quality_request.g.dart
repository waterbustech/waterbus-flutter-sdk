// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_quality_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrackQualityRequest _$TrackQualityRequestFromJson(Map<String, dynamic> json) =>
    _TrackQualityRequest(
      trackId: json['trackId'] as String,
      quality: $enumDecode(_$TrackQualityEnumMap, json['quality']),
    );

Map<String, dynamic> _$TrackQualityRequestToJson(
        _TrackQualityRequest instance) =>
    <String, dynamic>{
      'trackId': instance.trackId,
      'quality': _$TrackQualityEnumMap[instance.quality]!,
    };

const _$TrackQualityEnumMap = {
  TrackQuality.none: 0,
  TrackQuality.low: 1,
  TrackQuality.medium: 2,
  TrackQuality.high: 3,
};
