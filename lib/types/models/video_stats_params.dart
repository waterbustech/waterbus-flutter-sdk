import 'package:flutter/foundation.dart';

import 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';

import 'package:waterbus_sdk/types/models/rtc_participant_stats.dart';

class VideoStatsParam {
  final String ownerId;
  final Function(RtcParticipantStats) callBack;
  final List<RTCRtpSender> senders;
  final List<RTCRtpReceiver> receivers;
  VideoStatsParam({
    required this.ownerId,
    required this.callBack,
    this.senders = const [],
    this.receivers = const [],
  });

  VideoStatsParam copyWith({
    String? ownerId,
    Function(RtcParticipantStats)? callBack,
    List<RTCRtpSender>? senders,
    List<RTCRtpReceiver>? receivers,
  }) {
    return VideoStatsParam(
      ownerId: ownerId ?? this.ownerId,
      callBack: callBack ?? this.callBack,
      senders: senders ?? this.senders,
      receivers: receivers ?? this.receivers,
    );
  }

  @override
  String toString() {
    return 'VideoStatsParam(ownerId: $ownerId, callBack: $callBack, senders: $senders, receivers: $receivers)';
  }

  @override
  bool operator ==(covariant VideoStatsParam other) {
    if (identical(this, other)) return true;

    return other.ownerId == ownerId &&
        other.callBack == callBack &&
        listEquals(other.senders, senders) &&
        listEquals(other.receivers, receivers);
  }

  @override
  int get hashCode {
    return ownerId.hashCode ^
        callBack.hashCode ^
        senders.hashCode ^
        receivers.hashCode;
  }
}
