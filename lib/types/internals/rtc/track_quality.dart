import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum TrackQuality {
  @JsonValue(0)
  none,
  @JsonValue(1)
  low,
  @JsonValue(2)
  medium,
  @JsonValue(3)
  high
}

extension TrackQualityX on TrackQuality {
  int get priority => index;

  String get rid {
    return switch (this) {
      TrackQuality.none => "",
      TrackQuality.low => "q",
      TrackQuality.medium => "h",
      TrackQuality.high => "f",
    };
  }
}
