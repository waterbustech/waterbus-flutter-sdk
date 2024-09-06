enum MessageStatusEnum {
  inactive(1),
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
