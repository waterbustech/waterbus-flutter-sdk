import 'package:json_annotation/json_annotation.dart';

import 'package:waterbus_sdk/types/externals/models/video_quality.dart';

@JsonEnum()
enum VideoQualityEnum {
  @JsonValue("1080p")
  k1080p,
  @JsonValue("720p")
  k720p,
  @JsonValue("360p")
  k360p;

  VideoQuality get quality => switch (this) {
        VideoQualityEnum.k1080p => VideoQuality(
            minHeight: 1080,
            minWidth: 1920,
            minFrameRate: 30,
          ),
        VideoQualityEnum.k720p => VideoQuality(
            minHeight: 720,
            minWidth: 1280,
            minFrameRate: 24,
          ),
        VideoQualityEnum.k360p => VideoQuality(
            minHeight: 360,
            minWidth: 640,
            minFrameRate: 15,
          ),
      };
}
