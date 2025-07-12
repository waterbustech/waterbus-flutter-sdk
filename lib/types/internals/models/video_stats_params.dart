import 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/externals/models/rtc_participant_stats.dart';

part 'video_stats_params.freezed.dart';

@freezed
abstract class VideoStatsParam with _$VideoStatsParam {
  const factory VideoStatsParam({
    required String ownerId,
    required Function(RtcParticipantStats) callBack,
    @Default([]) List<RTCRtpSender> senders,
    @Default([]) receivers,
  }) = _VideoStatsParam;
}
