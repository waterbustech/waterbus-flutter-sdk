import 'package:flutter_webrtc_plus/flutter_webrtc_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/externals/enums/audio_level.dart';

part 'audio_stats_params.freezed.dart';

@freezed
abstract class AudioStatsParams with _$AudioStatsParams {
  const factory AudioStatsParams({
    required String ownerId,
    required Function(AudioLevel) callBack,
    RTCPeerConnection? pc,
    required List<RTCRtpReceiver> receivers,
  }) = _AudioStatsParams;
}
