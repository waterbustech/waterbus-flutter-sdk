// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParticipantInfo _$ParticipantInfoFromJson(Map<String, dynamic> json) =>
    _ParticipantInfo(
      id: (json['id'] as num).toInt(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      isMe: json['isMe'] as bool? ?? false,
    );

Map<String, dynamic> _$ParticipantInfoToJson(_ParticipantInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user?.toJson(),
      'isMe': instance.isMe,
    };
