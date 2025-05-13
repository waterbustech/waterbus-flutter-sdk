// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoConfig _$VideoConfigFromJson(Map<String, dynamic> json) => _VideoConfig(
      isVideoMuted: json['isVideoMuted'] as bool? ?? false,
      preferedCodec:
          $enumDecodeNullable(_$RTCVideoCodecEnumMap, json['preferedCodec']) ??
              RTCVideoCodec.h264,
      videoQuality:
          $enumDecodeNullable(_$VideoQualityEnumMap, json['videoQuality']) ??
              VideoQuality.high,
    );

Map<String, dynamic> _$VideoConfigToJson(_VideoConfig instance) =>
    <String, dynamic>{
      'isVideoMuted': instance.isVideoMuted,
      'preferedCodec': _$RTCVideoCodecEnumMap[instance.preferedCodec]!,
      'videoQuality': _$VideoQualityEnumMap[instance.videoQuality]!,
    };

const _$RTCVideoCodecEnumMap = {
  RTCVideoCodec.vp8: 'vp8',
  RTCVideoCodec.vp9: 'vp9',
  RTCVideoCodec.h264: 'h264',
  RTCVideoCodec.av1: 'av1',
};

const _$VideoQualityEnumMap = {
  VideoQuality.low: 'Data Saver',
  VideoQuality.auto: 'Balance',
  VideoQuality.high: 'High Quality',
};
