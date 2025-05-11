// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Meeting _$MeetingFromJson(Map<String, dynamic> json) => _Meeting(
      id: (json['id'] as num?)?.toInt() ?? -1,
      title: json['title'] as String,
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) => Participant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      code: (json['code'] as num?)?.toInt() ?? -1,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      latestJoinedAt: json['latestJoinedAt'] == null
          ? null
          : DateTime.parse(json['latestJoinedAt'] as String),
      status: $enumDecodeNullable(_$MeetingStatusEnumMap, json['status']) ??
          MeetingStatus.active,
      latestMessage: json['latestMessage'] == null
          ? null
          : MessageModel.fromJson(
              json['latestMessage'] as Map<String, dynamic>),
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$MeetingToJson(_Meeting instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'participants': instance.participants.map((e) => e.toJson()).toList(),
      'members': instance.members.map((e) => e.toJson()).toList(),
      'code': instance.code,
      'createdAt': instance.createdAt?.toIso8601String(),
      'latestJoinedAt': instance.latestJoinedAt?.toIso8601String(),
      'status': _$MeetingStatusEnumMap[instance.status]!,
      'latestMessage': instance.latestMessage?.toJson(),
      'avatar': instance.avatar,
    };

const _$MeetingStatusEnumMap = {
  MeetingStatus.archived: 1,
  MeetingStatus.active: 0,
};
