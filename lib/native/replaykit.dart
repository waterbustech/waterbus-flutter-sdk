import 'package:flutter/services.dart';

import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/core/webrtc/webrtc_interface.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

@singleton
class ReplayKitChannel {
  final MethodChannel rkChannel = const MethodChannel(kReplayKitChannel);

  void listenEvents(WaterbusWebRTCManager rtcManager) {
    if (!WebRTC.platformIsIOS) return;

    rkChannel.setMethodCallHandler((call) async {
      if (call.method == "closeReplayKitFromNative") {
        rtcManager.stopScreenSharing();
      } else if (call.method == "hasSampleBroadcast") {
        rtcManager.startScreenSharing();
      }
    });
  }

  void startReplayKit() {
    if (!WebRTC.platformIsIOS) return;

    rkChannel.invokeMethod("startReplayKit");
  }

  void closeReplayKit() {
    if (!WebRTC.platformIsIOS) return;

    rkChannel.invokeMethod("closeReplayKitFromFlutter");
  }
}
