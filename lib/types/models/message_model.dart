// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class MessageModel {
  final int id;
  final String data;
  final int meeting;
  final int createdBy;
  final int status;
  MessageModel({
    required this.id,
    required this.data,
    required this.meeting,
    required this.createdBy,
    required this.status,
  });

  MessageModel copyWith({
    int? id,
    String? data,
    int? meeting,
    int? createdBy,
    int? status,
  }) {
    return MessageModel(
      id: id ?? this.id,
      data: data ?? this.data,
      meeting: meeting ?? this.meeting,
      createdBy: createdBy ?? this.createdBy,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'data': data,
      'meeting': meeting,
      'createdBy': createdBy,
      'status': status,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['_id'] as int,
      data: map['data'] as String,
      meeting: map['meeting'] as int,
      createdBy: map['createdBy'] as int,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageModel(id: $id, data: $data, meeting: $meeting, createdBy: $createdBy, status: $status)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.data == data &&
        other.meeting == meeting &&
        other.createdBy == createdBy &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        data.hashCode ^
        meeting.hashCode ^
        createdBy.hashCode ^
        status.hashCode;
  }
}
