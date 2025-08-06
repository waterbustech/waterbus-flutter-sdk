import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/native/native_channel.dart';

@JsonEnum()
enum RTCVideoCodec {
  @JsonValue('vp8')
  vp8('vp8', true),
  @JsonValue('vp9')
  vp9('vp9', true),
  @JsonValue('h264')
  h264('h264', true),
  @JsonValue('av1')
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
      'av1' || 'video/av1' => RTCVideoCodec.av1,
      _ => RTCVideoCodec.h264,
    };
  }
}
