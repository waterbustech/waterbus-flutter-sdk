import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum MeetingStatus {
  @JsonValue(1)
  archived(1),
  @JsonValue(0)
  active(0);

  const MeetingStatus(this.status);

  final int status;
}

extension MeetingStatusX on int {
  MeetingStatus get getMeetingStatusEnum {
    return MeetingStatus.values
            .firstWhereOrNull((status) => status.status == this) ??
        MeetingStatus.active;
  }
}
