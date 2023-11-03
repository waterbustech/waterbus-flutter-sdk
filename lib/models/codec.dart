enum WebRTCCodec {
  vp8('vp8'),
  h264('h264'),
  av1('av1');

  const WebRTCCodec(this.codec);
  final String codec;
}

extension CodecX on String {
  WebRTCCodec get videoCodec {
    return switch (toLowerCase()) {
      'vp8' || 'video/vp8' => WebRTCCodec.vp8,
      'h264' || 'video/h264' => WebRTCCodec.h264,
      'av1' || 'video/av1' => WebRTCCodec.av1,
      _ => WebRTCCodec.h264,
    };
  }
}
