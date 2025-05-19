import 'package:json_annotation/json_annotation.dart';

import 'package:waterbus_sdk/types/externals/models/video_quality.dart';

@JsonEnum()
enum VideoQualityEnum {
  @JsonValue("p1080")
  p1080,
  @JsonValue("p720")
  p720,
  @JsonValue("p360")
  p360;

  VideoQuality get quality => switch (this) {
        VideoQualityEnum.p1080 => VideoQuality(
            minHeight: 1080,
            minWidth: 1920,
            minFrameRate: 30,
          ),
        VideoQualityEnum.p720 => VideoQuality(
            minHeight: 720,
            minWidth: 1280,
            minFrameRate: 24,
          ),
        VideoQualityEnum.p360 => VideoQuality(
            minHeight: 360,
            minWidth: 640,
            minFrameRate: 15,
          ),
      };
}
