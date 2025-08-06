// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Room _$RoomFromJson(Map<String, dynamic> json) => _Room(
      id: (json['id'] as num?)?.toInt() ?? -1,
      title: json['title'] as String,
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) => ParticipantInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      code: json['code'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      latestJoinedAt: json['latestJoinedAt'] == null
          ? null
          : DateTime.parse(json['latestJoinedAt'] as String),
      status: $enumDecodeNullable(_$RoomStatusEnumMap, json['status']) ??
          RoomStatus.active,
      latestMessage: json['latestMessage'] == null
          ? null
          : Message.fromJson(json['latestMessage'] as Map<String, dynamic>),
      avatar: json['avatar'] as String?,
      streamingProtocol: $enumDecodeNullable(
              _$StreamingProtocolEnumMap, json['streamingProtocol']) ??
          StreamingProtocol.sfu,
      roomType: $enumDecodeNullable(_$RoomTypeEnumMap, json['roomType']) ??
          RoomType.videoConferencing,
      isProtected: json['isProtected'] as bool? ?? false,
      capacity: (json['capacity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RoomToJson(_Room instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'participants': instance.participants.map((e) => e.toJson()).toList(),
      'members': instance.members.map((e) => e.toJson()).toList(),
      'code': instance.code,
      'createdAt': instance.createdAt?.toIso8601String(),
      'latestJoinedAt': instance.latestJoinedAt?.toIso8601String(),
      'status': _$RoomStatusEnumMap[instance.status]!,
      'latestMessage': instance.latestMessage?.toJson(),
      'avatar': instance.avatar,
      'streamingProtocol':
          _$StreamingProtocolEnumMap[instance.streamingProtocol]!,
      'roomType': _$RoomTypeEnumMap[instance.roomType]!,
      'isProtected': instance.isProtected,
      'capacity': instance.capacity,
    };

const _$RoomStatusEnumMap = {
  RoomStatus.archived: 1,
  RoomStatus.active: 0,
};

const _$StreamingProtocolEnumMap = {
  StreamingProtocol.sfu: 0,
  StreamingProtocol.hls: 1,
};

const _$RoomTypeEnumMap = {
  RoomType.videoConferencing: 0,
  RoomType.liveStreaming: 1,
};
