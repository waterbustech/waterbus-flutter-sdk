import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/models/chat_status_enum.dart';

class Meeting {
  final int id;
  final String title;
  final List<Participant> participants;
  final List<Member> members;
  final int code;
  final DateTime? createdAt;
  final DateTime? latestJoinedAt;
  final ChatStatusEnum status;
  final String? avatar;
  MessageModel? latestMessage;

  Meeting({
    this.id = -1,
    required this.title,
    this.participants = const [],
    this.members = const [],
    this.code = -1,
    this.createdAt,
    this.latestJoinedAt,
    this.status = ChatStatusEnum.join,
    this.latestMessage,
    this.avatar,
  });

  Meeting copyWith({
    int? id,
    String? title,
    List<Participant>? participants,
    List<Member>? members,
    int? code,
    DateTime? createdAt,
    DateTime? latestJoinedAt,
    ChatStatusEnum? status,
    MessageModel? latestMessage,
    String? avatar,
  }) {
    return Meeting(
      id: id ?? this.id,
      title: title ?? this.title,
      participants: participants ?? this.participants,
      members: members ?? this.members,
      code: code ?? this.code,
      createdAt: createdAt ?? this.createdAt,
      latestJoinedAt: latestJoinedAt ?? this.latestJoinedAt,
      status: status ?? this.status,
      latestMessage: latestMessage ?? this.latestMessage,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'participants': participants.map((x) => x.toMap()).toList(),
      'members': members.map((x) => x.toMap()).toList(),
      'code': code,
      'createdAt': createdAt.toString(),
      'latestJoinedAt': latestJoinedAt.toString(),
      'status': status.status,
      'latestMessage': latestMessage?.toMap(),
      'avatar': avatar,
    };
  }

  Map<String, dynamic> toMapCreate({String? password}) {
    final Map<String, dynamic> body = {
      'title': title,
      'code': code,
      'avatar': avatar,
    };

    if (password != null) {
      body['password'] = password;
    }

    return body;
  }

  factory Meeting.fromMap(Map<String, dynamic> map) {
    return Meeting(
      id: map['id'] as int,
      title: map['title'] as String,
      participants: List<Participant>.from(
        (map['participants'] as List).map<Participant>(
          (x) => Participant.fromMap(x as Map<String, dynamic>),
        ),
      ),
      members: List<Member>.from(
        (map['members'] as List).map<Member>(
          (x) => Member.fromMap(x as Map<String, dynamic>),
        ),
      ),
      code: map['code'],
      status: (int.tryParse(map['status'].toString()) ?? 0).getChatStatusEnum,
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
      latestJoinedAt:
          DateTime.parse(map['latestJoinedAt'] ?? map['createdAt']).toLocal(),
      latestMessage: map['latestMessage'] != null &&
              map['latestMessage'] is Map<String, dynamic>
          ? MessageModel.fromMap(map['latestMessage'])
          : null,
      avatar: map['avatar'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Meeting.fromJson(String source) =>
      Meeting.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Meeting other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.createdAt == createdAt &&
        other.avatar == avatar &&
        other.status == status &&
        other.latestJoinedAt == latestJoinedAt &&
        other.latestMessage == latestMessage &&
        listEquals(other.participants, participants) &&
        listEquals(other.members, members) &&
        other.code == code;
  }

  @override
  String toString() {
    return 'MessageModel(id: $id, title: $title, avatar: $avatar, createdAt: $createdAt, status: $status, latestJoinedAt: $latestJoinedAt, participants: $participants, members: $members, status: $status, code: $code, latestMessage: $latestMessage)';
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        participants.hashCode ^
        members.hashCode ^
        status.hashCode ^
        code.hashCode ^
        avatar.hashCode ^
        createdAt.hashCode ^
        latestMessage.hashCode ^
        latestJoinedAt.hashCode;
  }

  bool get isNoOneElse => participants.length < 2;

  String get inviteLink => 'https:/waterbus.tech/meeting/$code';

  String? get participantsOnlineTile {
    if (participants.isEmpty) return null;

    final int numberOfPaticipants = participants.length;

    if (numberOfPaticipants == 1) {
      return '${participants[0].user?.fullName} is in the room';
    } else if (numberOfPaticipants == 2) {
      return '${participants[0].user?.fullName} and ${participants[1].user?.fullName} are in the room';
    } else {
      final int otherParticipants = numberOfPaticipants - 2;
      final String participantList = participants
          .sublist(0, 2)
          .map<String>((participant) => participant.user?.fullName ?? "")
          .join(', ');
      return '$participantList and $otherParticipants others are in the room';
    }
  }

  DateTime get latestJoinedTime {
    return latestJoinedAt ?? createdAt ?? DateTime.now();
  }

  bool get isGroup => memberJoined.length >= 2;

  StatusSeenMessage get statusLastedMessage => StatusSeenMessage.seen;

  List<Member> get memberJoined => members
      .where((member) => member.status == MemberStatusEnum.joined)
      .toList();

  StatusMessage get statusMessage => StatusMessage.none;

  int get countUnreadMessage => 10;

  DateTime get updatedAt =>
      (latestMessage?.updatedAt ?? createdAt ?? DateTime.now()).toLocal();
}
