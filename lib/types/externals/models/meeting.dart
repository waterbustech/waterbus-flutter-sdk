import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

part 'meeting.freezed.dart';
part 'meeting.g.dart';

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
    Message? latestMessage,
    String? avatar,
  }) = _Meeting;

  factory Meeting.fromJson(Map<String, Object?> json) =>
      _$MeetingFromJson(json);
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
}
