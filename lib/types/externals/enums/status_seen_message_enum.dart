import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum StatusSeenMessage {
  @JsonValue(0)
  unseen(0),
  @JsonValue(1)
  seen(1);

  const StatusSeenMessage(this.status);

  final int status;
}

extension StatusSeenMessageX on int {
  StatusSeenMessage get getStatusSeenMessage {
    final int index =
        StatusSeenMessage.values.indexWhere((status) => status.status == this);

    if (index == -1) return StatusSeenMessage.unseen;

    return StatusSeenMessage.values[index];
  }
}
