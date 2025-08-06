// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AudioConfig _$AudioConfigFromJson(Map<String, dynamic> json) => _AudioConfig(
      deviceId: json['deviceId'] as String?,
      isLowBandwidthMode: json['isLowBandwidthMode'] as bool? ?? false,
      isAudioMuted: json['isAudioMuted'] as bool? ?? false,
      echoCancellationEnabled: json['echoCancellationEnabled'] as bool? ?? true,
      noiseSuppressionEnabled: json['noiseSuppressionEnabled'] as bool? ?? true,
      agcEnabled: json['agcEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$AudioConfigToJson(_AudioConfig instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'isLowBandwidthMode': instance.isLowBandwidthMode,
      'isAudioMuted': instance.isAudioMuted,
      'echoCancellationEnabled': instance.echoCancellationEnabled,
      'noiseSuppressionEnabled': instance.noiseSuppressionEnabled,
      'agcEnabled': instance.agcEnabled,
    };
