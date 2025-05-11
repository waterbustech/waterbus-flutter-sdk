import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum CameraType {
  @JsonValue(0)
  front(0),
  @JsonValue(1)
  rear(1);

  const CameraType(this.type);
  final int type;
}
