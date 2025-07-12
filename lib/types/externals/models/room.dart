import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/internals/enums/index.dart';

part 'room.freezed.dart';
part 'room.g.dart';

@freezed
abstract class Room with _$Room {
  const factory Room({
    @Default(-1) int id,
    required String title,
    @Default([]) List<Participant> participants,
    @Default([]) List<Member> members,
    String? code,
    DateTime? createdAt,
    DateTime? latestJoinedAt,
    @Default(RoomStatus.active) RoomStatus status,
    Message? latestMessage,
    String? avatar,
  }) = _Room;

  factory Room.fromJson(Map<String, Object?> json) => _$RoomFromJson(json);
}

extension RoomExtention on Room {
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
