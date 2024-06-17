enum StatusMessage {
  none(0),
  file(1),
  endCall(2),
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
