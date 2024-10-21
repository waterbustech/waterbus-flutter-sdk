import 'dart:convert';

import 'package:waterbus_sdk/types/enums/meeting_role.dart';
import 'package:waterbus_sdk/types/enums/status_enum.dart';
import 'package:waterbus_sdk/types/models/user_model.dart';

class Member {
  final int id;
  final MeetingRole role;
  MemberStatusEnum status;
  final User user;
  final bool isMe;
  final int? meetingId;

  Member({
    required this.id,
    required this.role,
    required this.user,
    this.isMe = false,
    this.meetingId,
    this.status = MemberStatusEnum.joined,
  });

  Member copyWith({
    int? id,
    MeetingRole? role,
    User? user,
    bool? isMe,
    int? meetingId,
    MemberStatusEnum? status,
  }) {
    return Member(
      id: id ?? this.id,
      role: role ?? this.role,
      user: user ?? this.user,
      isMe: isMe ?? this.isMe,
      status: status ?? this.status,
      meetingId: meetingId ?? this.meetingId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'role': role.value,
      'user': user.toMap(),
      'isMe': isMe,
      'status': status.value,
      'meetingId': meetingId,
    };
  }

  factory Member.fromMapSocket(Map<String, dynamic> map) {
    final Map<String, dynamic> member = map['member'];
    return Member(
      id: member['id'] ?? 0,
      role:
          MeetingRoleX.fromValue(member['role'] ?? MeetingRole.attendee.value),
      user: User.fromMap(member['user'] as Map<String, dynamic>),
      isMe: member['isMe'] ?? false,
      status: MemberStatusEnum.fromValue(
        member['status'] ?? MemberStatusEnum.inviting.value,
      ),
      meetingId: map['meetingId'],
    );
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'] ?? 0,
      role: MeetingRoleX.fromValue(map['role'] ?? MeetingRole.attendee.value),
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      isMe: map['isMe'] ?? false,
      status: MemberStatusEnum.fromValue(
        map['status'] ?? MemberStatusEnum.inviting.value,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Member.fromJson(String source) =>
      Member.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Participant(id: $id, role: $role, meetingId: $meetingId, user: $user, status: $status)';

  @override
  bool operator ==(covariant Member other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.role == role &&
        other.user == user &&
        other.isMe == isMe &&
        other.meetingId == meetingId &&
        other.status == status;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      role.hashCode ^
      user.hashCode ^
      isMe.hashCode ^
      meetingId.hashCode ^
      status.hashCode;
}
