// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_quality.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoQuality _$VideoQualityFromJson(Map<String, dynamic> json) =>
    _VideoQuality(
      minHeight: (json['minHeight'] as num).toInt(),
      minWidth: (json['minWidth'] as num).toInt(),
      minFrameRate: (json['minFrameRate'] as num).toInt(),
    );

Map<String, dynamic> _$VideoQualityToJson(_VideoQuality instance) =>
    <String, dynamic>{
      'minHeight': instance.minHeight,
      'minWidth': instance.minWidth,
      'minFrameRate': instance.minFrameRate,
    };
