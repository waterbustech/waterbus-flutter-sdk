enum StatusSeenMessage {
  unseen(0),
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
