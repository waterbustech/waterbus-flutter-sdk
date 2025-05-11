import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum StatusMessage {
  @JsonValue(0)
  none(0),
  @JsonValue(1)
  file(1),
  @JsonValue(2)
  endCall(2),
  @JsonValue(3)
  missCall(3);

  const StatusMessage(this.status);

  final int status;
}

extension StatusMessageX on int {
  StatusMessage get getStatusMessage {
    final int index =
        StatusMessage.values.indexWhere((status) => status.status == this);

    if (index == -1) return StatusMessage.none;

    return StatusMessage.values[index];
  }
}
