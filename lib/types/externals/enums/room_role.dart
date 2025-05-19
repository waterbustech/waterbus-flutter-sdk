import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum RoomRole {
  @JsonValue(0)
  host(0),
  @JsonValue(1)
  attendee(1);

  const RoomRole(this.value);
  final int value;
}

extension RoomRoleX on RoomRole {
  static RoomRole fromValue(int value) {
    switch (value) {
      case 0:
        return RoomRole.host;
      case 1:
        return RoomRole.attendee;
      default:
        throw Exception('Unknown MeetingRole value: $value');
    }
  }
}
