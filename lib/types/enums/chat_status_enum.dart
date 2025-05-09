import 'package:collection/collection.dart';

enum MeetingStatus {
  archived(1),
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
