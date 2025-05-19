// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Member _$MemberFromJson(Map<String, dynamic> json) => _Member(
      id: (json['id'] as num).toInt(),
      role: $enumDecode(_$RoomRoleEnumMap, json['role']),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      isMe: json['isMe'] as bool? ?? false,
      roomId: const IntConverter().fromJson(json['roomId']),
      status: $enumDecodeNullable(_$MemberStatusEnumEnumMap, json['status']) ??
          MemberStatusEnum.joined,
    );

Map<String, dynamic> _$MemberToJson(_Member instance) => <String, dynamic>{
      'id': instance.id,
      'role': _$RoomRoleEnumMap[instance.role]!,
      'user': instance.user.toJson(),
      'isMe': instance.isMe,
      'roomId': const IntConverter().toJson(instance.roomId),
      'status': _$MemberStatusEnumEnumMap[instance.status]!,
    };

const _$RoomRoleEnumMap = {
  RoomRole.host: 0,
  RoomRole.attendee: 1,
};

const _$MemberStatusEnumEnumMap = {
  MemberStatusEnum.inviting: 0,
  MemberStatusEnum.invisible: 1,
  MemberStatusEnum.joined: 2,
};
