// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AvatarModel _$AvatarModelFromJson(Map<String, dynamic> json) => _AvatarModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      src: json['src'] as String,
      location: json['location'] as String,
      version: (json['version'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AvatarModelToJson(_AvatarModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'src': instance.src,
      'location': instance.location,
      'version': instance.version,
    };
