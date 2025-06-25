import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum TrackQuality {
  @JsonValue(1)
  low,
  @JsonValue(2)
  medium,
  @JsonValue(3)
  high
}
