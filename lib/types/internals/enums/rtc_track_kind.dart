import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum RtcTrackKind {
  @JsonValue('audio')
  audio('audio'),
  @JsonValue('video')
  video('video');

  final String kind;
  const RtcTrackKind(this.kind);
}
