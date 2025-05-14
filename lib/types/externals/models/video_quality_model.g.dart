// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_quality_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoQualityModel _$VideoQualityModelFromJson(Map<String, dynamic> json) =>
    _VideoQualityModel(
      minHeight: (json['minHeight'] as num).toInt(),
      minWidth: (json['minWidth'] as num).toInt(),
      minFrameRate: (json['minFrameRate'] as num).toInt(),
    );

Map<String, dynamic> _$VideoQualityModelToJson(_VideoQualityModel instance) =>
    <String, dynamic>{
      'minHeight': instance.minHeight,
      'minWidth': instance.minWidth,
      'minFrameRate': instance.minFrameRate,
    };
