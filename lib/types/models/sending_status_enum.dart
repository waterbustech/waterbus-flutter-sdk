enum SendingStatusEnum {
  error(-1),
  sending(0),
  sent(1);

  const SendingStatusEnum(this.status);

  final int status;
}

extension SendingStatusEnumX on int {
  SendingStatusEnum get getSendingStatus {
    final int index =
        SendingStatusEnum.values.indexWhere((status) => status.status == this);

    if (index == -1) return SendingStatusEnum.sending;

    return SendingStatusEnum.values[index];
  }
}
