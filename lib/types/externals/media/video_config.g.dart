// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoConfig _$VideoConfigFromJson(Map<String, dynamic> json) => _VideoConfig(
      deviceId: json['deviceId'] as String?,
      isVideoMuted: json['isVideoMuted'] as bool? ?? false,
      preferedCodec:
          $enumDecodeNullable(_$RTCVideoCodecEnumMap, json['preferedCodec']) ??
              RTCVideoCodec.h264,
      videoQuality: $enumDecodeNullable(
              _$VideoQualityEnumEnumMap, json['videoQuality']) ??
          VideoQualityEnum.k720p,
    );

Map<String, dynamic> _$VideoConfigToJson(_VideoConfig instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'isVideoMuted': instance.isVideoMuted,
      'preferedCodec': _$RTCVideoCodecEnumMap[instance.preferedCodec]!,
      'videoQuality': _$VideoQualityEnumEnumMap[instance.videoQuality]!,
    };

const _$RTCVideoCodecEnumMap = {
  RTCVideoCodec.vp8: 'vp8',
  RTCVideoCodec.vp9: 'vp9',
  RTCVideoCodec.h264: 'h264',
  RTCVideoCodec.av1: 'av1',
};

const _$VideoQualityEnumEnumMap = {
  VideoQualityEnum.k1080p: '1080p',
  VideoQualityEnum.k720p: '720p',
  VideoQualityEnum.k360p: '360p',
};
