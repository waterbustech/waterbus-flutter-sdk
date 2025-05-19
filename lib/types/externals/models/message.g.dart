// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
      id: (json['id'] as num).toInt(),
      data: json['data'] as String,
      roomId: const IntConverter().fromJson(json['roomId']),
      createdBy: json['createdBy'] == null
          ? null
          : User.fromJson(json['createdBy'] as Map<String, dynamic>),
      sendingStatus: $enumDecodeNullable(
              _$SendingStatusEnumEnumMap, json['sendingStatus']) ??
          SendingStatusEnum.sent,
      status: $enumDecode(_$MessageStatusEnumEnumMap, json['status']),
      type: (json['type'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
      'id': instance.id,
      'data': instance.data,
      'roomId': const IntConverter().toJson(instance.roomId),
      'createdBy': instance.createdBy?.toJson(),
      'sendingStatus': _$SendingStatusEnumEnumMap[instance.sendingStatus]!,
      'status': _$MessageStatusEnumEnumMap[instance.status]!,
      'type': instance.type,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$SendingStatusEnumEnumMap = {
  SendingStatusEnum.error: -1,
  SendingStatusEnum.sending: 0,
  SendingStatusEnum.sent: 1,
};

const _$MessageStatusEnumEnumMap = {
  MessageStatusEnum.inactive: 1,
  MessageStatusEnum.active: 0,
};
