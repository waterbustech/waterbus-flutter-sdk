// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Member _$MemberFromJson(Map<String, dynamic> json) => _Member(
      id: (json['id'] as num).toInt(),
      role: $enumDecode(_$MeetingRoleEnumMap, json['role']),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      isMe: json['isMe'] as bool? ?? false,
      meetingId: (json['meetingId'] as num?)?.toInt(),
      status: $enumDecodeNullable(_$MemberStatusEnumEnumMap, json['status']) ??
          MemberStatusEnum.joined,
    );

Map<String, dynamic> _$MemberToJson(_Member instance) => <String, dynamic>{
      'id': instance.id,
      'role': _$MeetingRoleEnumMap[instance.role]!,
      'user': instance.user,
      'isMe': instance.isMe,
      'meetingId': instance.meetingId,
      'status': _$MemberStatusEnumEnumMap[instance.status]!,
    };

const _$MeetingRoleEnumMap = {
  MeetingRole.host: 0,
  MeetingRole.attendee: 1,
};

const _$MemberStatusEnumEnumMap = {
  MemberStatusEnum.inviting: 0,
  MemberStatusEnum.invisible: 1,
  MemberStatusEnum.joined: 2,
};
