import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum MessageStatusEnum {
  @JsonValue(1)
  inactive(1),
  @JsonValue(0)
  active(0);

  const MessageStatusEnum(this.status);

  final int status;
}

extension MessageStatusEnumX on int {
  MessageStatusEnum get getMessageStatus {
    final int index =
        MessageStatusEnum.values.indexWhere((status) => status.status == this);

    if (index == -1) return MessageStatusEnum.inactive;

    return MessageStatusEnum.values[index];
  }
}
