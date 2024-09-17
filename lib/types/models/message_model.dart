// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/types/models/message_status_enum.dart';
import 'package:waterbus_sdk/types/models/sending_status_enum.dart';

class MessageModel {
  final int id;
  String data;
  final int meeting;
  final User? createdBy;
  SendingStatusEnum sendingStatus;
  MessageStatusEnum status;
  final int type;
  final DateTime createdAt;
  final DateTime updatedAt;
  MessageModel({
    required this.id,
    required this.data,
    required this.meeting,
    required this.createdBy,
    this.sendingStatus = SendingStatusEnum.sent,
    required this.status,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  MessageModel copyWith({
    int? id,
    String? data,
    int? meeting,
    User? createdBy,
    SendingStatusEnum? sendingStatus,
    MessageStatusEnum? status,
    int? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      data: data ?? this.data,
      meeting: meeting ?? this.meeting,
      createdBy: createdBy ?? this.createdBy,
      sendingStatus: sendingStatus ?? this.sendingStatus,
      status: status ?? this.status,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'data': data,
      'meeting': meeting,
      'createdBy': createdBy?.toMap(),
      'sendingStatus': sendingStatus.status,
      'status': status.status,
      'type': type,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? 0,
      data: map['data'] ?? "",
      meeting: (map['meeting'] is Map<String, dynamic>
              ? map['meeting']['id']
              : map['meeting']) ??
          0,
      status:
          (int.tryParse(map['status']?.toString() ?? "") ?? 0).getMessageStatus,
      createdBy:
          map['createdBy'] != null && map['createdBy'] is Map<String, dynamic>
              ? User.fromMap(map['createdBy'])
              : null,
      type: map['type'] ?? 0,
      createdAt: DateTime.parse((map['createdAt'] ?? DateTime.now()).toString())
          .toLocal(),
      updatedAt: DateTime.parse((map['updatedAt'] ?? DateTime.now()).toString())
          .toLocal(),
    );
  }

  factory MessageModel.fromMapSocket(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? 0,
      status:
          (int.tryParse(map['status']?.toString() ?? "") ?? 0).getMessageStatus,
      data: map['data'] ?? "",
      meeting: (map['meeting'] is Map<String, dynamic>
              ? map['meeting']['id']
              : map['meeting']) ??
          0,
      createdBy:
          map['createdBy'] != null && map['createdBy'] is Map<String, dynamic>
              ? User.fromMap(map['createdBy'])
              : null,
      type: map['type'] ?? 0,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(int.parse(map['createdAt']))
              .toLocal(),
      updatedAt:
          DateTime.fromMillisecondsSinceEpoch(int.parse(map['updatedAt']))
              .toLocal(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageModel(id: $id, data: $data, meeting: $meeting, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, status: $sendingStatus)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.data == data &&
        other.meeting == meeting &&
        other.createdBy == createdBy &&
        other.type == type &&
        other.updatedAt == updatedAt &&
        other.createdAt == createdAt &&
        other.sendingStatus == sendingStatus;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        data.hashCode ^
        meeting.hashCode ^
        createdBy.hashCode ^
        type.hashCode ^
        updatedAt.hashCode ^
        createdAt.hashCode ^
        sendingStatus.hashCode;
  }

  bool get isDeleted => status == MessageStatusEnum.inactive;
}
