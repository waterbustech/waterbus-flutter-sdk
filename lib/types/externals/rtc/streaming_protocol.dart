import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum StreamingProtocol {
  @JsonValue(0)
  sfu,
  @JsonValue(1)
  hls,
  // @JsonValue(2)
  // moq,
}
