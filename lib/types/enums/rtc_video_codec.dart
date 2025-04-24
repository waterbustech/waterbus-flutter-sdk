import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/native/native_channel.dart';

enum RTCVideoCodec {
  vp8('vp8', true),
  vp9('vp9', true),
  h264('h264', true),
  // h265('h265', false),
  av1('av1', false);

  const RTCVideoCodec(this.codec, this.isSFrameSuported);
  final String codec;
  final bool isSFrameSuported;
}

extension CodecX on RTCVideoCodec {
  Future<bool> isPlatformSupported() async {
    if (this == RTCVideoCodec.av1) {
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
  RTCVideoCodec get videoCodec {
    return switch (toLowerCase()) {
      'vp8' || 'video/vp8' => RTCVideoCodec.vp8,
      'vp9' || 'video/vp9' => RTCVideoCodec.vp9,
      'h264' || 'video/h264' => RTCVideoCodec.h264,
      // 'h265' || 'video/h265' => WebRTCCodec.h265,
      'av1' || 'video/av1' => RTCVideoCodec.av1,
      _ => RTCVideoCodec.h264,
    };
  }
}
