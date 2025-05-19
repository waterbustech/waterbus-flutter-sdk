import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/types/externals/enums/rtc_video_codec.dart';
import 'package:waterbus_sdk/types/internals/enums/video_quality_enum.dart';

part "video_config.freezed.dart";
part "video_config.g.dart";

@freezed
abstract class VideoConfig with _$VideoConfig {
  const factory VideoConfig({
    @Default(false) bool isVideoMuted,
    @Default(RTCVideoCodec.h264) RTCVideoCodec preferedCodec,
    @Default(VideoQualityEnum.p1080) VideoQualityEnum videoQuality,
  }) = _VideoConfig;

  factory VideoConfig.fromJson(Map<String, Object?> json) =>
      _$VideoConfigFromJson(json);
}
