// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presigned_url.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PresignedUrl _$PresignedUrlFromJson(Map<String, dynamic> json) =>
    _PresignedUrl(
      presignedUrl: json['presignedUrl'] as String,
      sourceUrl: json['sourceUrl'] as String,
    );

Map<String, dynamic> _$PresignedUrlToJson(_PresignedUrl instance) =>
    <String, dynamic>{
      'presignedUrl': instance.presignedUrl,
      'sourceUrl': instance.sourceUrl,
    };
