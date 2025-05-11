// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CallSetting _$CallSettingFromJson(Map<String, dynamic> json) => _CallSetting(
      isLowBandwidthMode: json['isLowBandwidthMode'] as bool? ?? false,
      isAudioMuted: json['isAudioMuted'] as bool? ?? false,
      echoCancellationEnabled: json['echoCancellationEnabled'] as bool? ?? true,
      noiseSuppressionEnabled: json['noiseSuppressionEnabled'] as bool? ?? true,
      agcEnabled: json['agcEnabled'] as bool? ?? true,
      isVideoMuted: json['isVideoMuted'] as bool? ?? false,
      e2eeEnabled: json['e2eeEnabled'] as bool? ?? false,
      preferedCodec:
          $enumDecodeNullable(_$RTCVideoCodecEnumMap, json['preferedCodec']) ??
              RTCVideoCodec.h264,
      videoQuality:
          $enumDecodeNullable(_$VideoQualityEnumMap, json['videoQuality']) ??
              VideoQuality.high,
    );

Map<String, dynamic> _$CallSettingToJson(_CallSetting instance) =>
    <String, dynamic>{
      'isLowBandwidthMode': instance.isLowBandwidthMode,
      'isAudioMuted': instance.isAudioMuted,
      'echoCancellationEnabled': instance.echoCancellationEnabled,
      'noiseSuppressionEnabled': instance.noiseSuppressionEnabled,
      'agcEnabled': instance.agcEnabled,
      'isVideoMuted': instance.isVideoMuted,
      'e2eeEnabled': instance.e2eeEnabled,
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
