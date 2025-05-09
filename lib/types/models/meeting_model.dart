import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

part 'meeting_model.freezed.dart';
part 'meeting_model.g.dart';

@freezed
abstract class Meeting with _$Meeting {
  const factory Meeting({
    @Default(-1) int id,
    required String title,
    @Default([]) List<Participant> participants,
    @Default([]) List<Member> members,
    @Default(-1) int code,
    DateTime? createdAt,
    DateTime? latestJoinedAt,
    @Default(MeetingStatus.active) MeetingStatus status,
    MessageModel? latestMessage,
    String? avatar,
  }) = _Meeting;

  factory Meeting.fromJson(Map<String, Object?> json) =>
      _$MeetingFromJson(json);
  // Map<String, dynamic> toJson() => _$MeetingToJson(this);

  factory Meeting.fromMapSocket(Map<String, dynamic> map) {
    return Meeting(
      id: map['id'] ?? 0,
      title: map['title'] ?? "",
      members: map['members'] != null && map['members'] is List
          ? (map['members'] as List)
              .whereType<Map<String, dynamic>>()
              .map<Member>((member) => Member.fromJson(member))
              .toList()
          : [],
      status: (int.tryParse(map['status']?.toString() ?? "0") ?? 0)
          .getMeetingStatusEnum,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(int.parse(map['createdAt']))
              .toLocal(),
      avatar: map['avatar'],
      code: map['code'] ?? 0,
    );
  }
}

extension MeetingExtention on Meeting {
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

  bool get isNoOneElse => members.length < 2;

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
