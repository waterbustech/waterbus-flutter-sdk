import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/externals/enums/member_status_enum.dart';
import 'package:waterbus_sdk/types/externals/enums/room_role.dart';
import 'package:waterbus_sdk/types/externals/models/index.dart';
import 'package:waterbus_sdk/types/internals/models/int_converter.dart';

part 'member.freezed.dart';
part 'member.g.dart';

@freezed
abstract class Member with _$Member {
  const factory Member({
    required int id,
    required RoomRole role,
    required User user,
    @Default(false) bool isMe,
    @IntConverter() int? roomId,
    @Default(MemberStatusEnum.joined) MemberStatusEnum status,
  }) = _Member;

  factory Member.fromJson(Map<String, Object?> json) => _$MemberFromJson(json);

  factory Member.fromMapSocket(Map<String, dynamic> map) {
    final Map<String, dynamic> member = map['member'];
    return Member(
      id: member['id'] ?? 0,
      role: RoomRoleX.fromValue(member['role'] ?? RoomRole.attendee.value),
      user: User.fromJson(member['user'] as Map<String, dynamic>),
      isMe: member['isMe'] ?? false,
      status: MemberStatusEnum.fromValue(
        member['status'] ?? MemberStatusEnum.inviting.value,
      ),
      roomId: map['roomId'],
    );
  }
}
