// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecordModel _$RecordModelFromJson(Map<String, dynamic> json) => _RecordModel(
      id: (json['id'] as num).toInt(),
      meeting: Meeting.fromJson(json['meeting'] as Map<String, dynamic>),
      urlToVideo: json['urlToVideo'] as String,
      thumbnail: json['thumbnail'] as String,
      duration: (json['duration'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$RecordModelToJson(_RecordModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'meeting': instance.meeting,
      'urlToVideo': instance.urlToVideo,
      'thumbnail': instance.thumbnail,
      'duration': instance.duration,
      'createdAt': instance.createdAt.toIso8601String(),
    };
