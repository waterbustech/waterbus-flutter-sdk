import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum RoomType {
  @JsonValue(0)
  videoConferencing,
  @JsonValue(1)
  liveStreaming,
}
