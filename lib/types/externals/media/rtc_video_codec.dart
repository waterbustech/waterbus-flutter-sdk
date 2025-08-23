import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum RTCVideoCodec {
  @JsonValue('vp8')
  vp8('vp8', true),
  @JsonValue('vp9')
  vp9('vp9', true),
  @JsonValue('h264')
  h264('h264', true);
  // @JsonValue('av1')
  // av1('av1', false);

  const RTCVideoCodec(this.codec, this.isSFrameSuported);
  final String codec;
  final bool isSFrameSuported;
}

extension CodecStringX on String {
  RTCVideoCodec get videoCodec {
    return switch (toLowerCase()) {
      'vp8' || 'video/vp8' => RTCVideoCodec.vp8,
      'vp9' || 'video/vp9' => RTCVideoCodec.vp9,
      'h264' || 'video/h264' => RTCVideoCodec.h264,
      // 'av1' || 'video/av1' => RTCVideoCodec.av1,
      _ => RTCVideoCodec.h264,
    };
  }
}
