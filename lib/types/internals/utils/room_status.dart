import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum RoomStatus {
  @JsonValue(1)
  archived(1),
  @JsonValue(0)
  active(0);

  const RoomStatus(this.status);

  final int status;
}
