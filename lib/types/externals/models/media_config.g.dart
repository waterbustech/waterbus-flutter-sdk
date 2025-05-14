// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaConfig _$MediaConfigFromJson(Map<String, dynamic> json) => _MediaConfig(
      audioConfig: json['audioConfig'] == null
          ? const AudioConfig()
          : AudioConfig.fromJson(json['audioConfig'] as Map<String, dynamic>),
      videoConfig: json['videoConfig'] == null
          ? const VideoConfig()
          : VideoConfig.fromJson(json['videoConfig'] as Map<String, dynamic>),
      e2eeEnabled: json['e2eeEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$MediaConfigToJson(_MediaConfig instance) =>
    <String, dynamic>{
      'audioConfig': instance.audioConfig.toJson(),
      'videoConfig': instance.videoConfig.toJson(),
      'e2eeEnabled': instance.e2eeEnabled,
    };
