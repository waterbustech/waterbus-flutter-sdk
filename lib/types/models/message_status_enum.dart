enum MessageStatusEnum {
  error(-1),
  sending(0),
  sent(1);

  const MessageStatusEnum(this.status);

  final int status;
}

extension MessageStatusEnumX on int {
  MessageStatusEnum get getMessageStatus {
    final int index =
        MessageStatusEnum.values.indexWhere((status) => status.status == this);

    if (index == -1) return MessageStatusEnum.sending;

    return MessageStatusEnum.values[index];
  }
}
