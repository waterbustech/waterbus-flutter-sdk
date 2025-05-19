import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum SendingStatusEnum {
  @JsonValue(-1)
  error(-1),
  @JsonValue(0)
  sending(0),
  @JsonValue(1)
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
