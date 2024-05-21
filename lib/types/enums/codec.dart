// Project imports:
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/native/native_channel.dart';

enum WebRTCCodec {
  vp8('vp8', true),
  vp9('vp9', true),
  h264('h264', true),
  h265('h265', false),
  av1('av1', false);

  const WebRTCCodec(this.codec, this.isSFrameSuported);
  final String codec;
  final bool isSFrameSuported;
}

extension CodecX on WebRTCCodec {
  Future<bool> isPlatformSupported() async {
    if (this == WebRTCCodec.av1) {
      final double platformVersion = await NativeService().getPlatformVersion();

      if (WebRTC.platformIsAndroid &&
              platformVersion >= kMinAV1AndroidSupported ||
          WebRTC.platformIsIOS && platformVersion >= kMinAV1iOSSupported) {
        return true;
      }
    }

    return true;
  }
}

extension CodecStringX on String {
  WebRTCCodec get videoCodec {
    return switch (toLowerCase()) {
      'vp8' || 'video/vp8' => WebRTCCodec.vp8,
      'vp9' || 'video/vp9' => WebRTCCodec.vp9,
      'h264' || 'video/h264' => WebRTCCodec.h264,
      'h265' || 'video/h265' => WebRTCCodec.h265,
      'av1' || 'video/av1' => WebRTCCodec.av1,
      _ => WebRTCCodec.h264,
    };
  }
}
