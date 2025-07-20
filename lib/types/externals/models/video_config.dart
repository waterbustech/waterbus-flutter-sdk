import 'package:flutter/foundation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/externals/enums/rtc_video_codec.dart';
import 'package:waterbus_sdk/types/externals/enums/video_quality_enum.dart';

part "video_config.freezed.dart";
part "video_config.g.dart";

@freezed
abstract class VideoConfig with _$VideoConfig {
  const factory VideoConfig({
    String? deviceId,
    @Default(false) bool isVideoMuted,
    @Default(RTCVideoCodec.h264) RTCVideoCodec preferedCodec,
    @Default(VideoQualityEnum.k720p) VideoQualityEnum videoQuality,
  }) = _VideoConfig;

  factory VideoConfig.fromJson(Map<String, Object?> json) =>
      _$VideoConfigFromJson(json);
}

extension VideoConfigX on VideoConfig {
  Map<String, dynamic> get configDeviceId {
    final Map<String, dynamic> constraints = {};
    if (deviceId != null && deviceId!.isNotEmpty) {
      if (kIsWeb) {
        // if (isChrome129OrLater()) {
        constraints['deviceId'] = {'exact': deviceId};
        // } else {
        //   constraints['deviceId'] = {'ideal': deviceId};
        // }
      } else {
        constraints['optional'] = [
          {'sourceId': deviceId},
        ];
      }
    }

    return constraints;
  }
}
