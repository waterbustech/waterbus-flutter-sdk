import 'package:flutter/services.dart';

import 'package:injectable/injectable.dart';

import 'package:waterbus_sdk/core/rtc/rtc_manager.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

@singleton
class ReplayKitChannel {
  final MethodChannel rkChannel = const MethodChannel(kReplayKitChannel);

  void listenEvents(RtcManager rtcManager) {
    if (!WebRTC.platformIsIOS) return;

    rkChannel.setMethodCallHandler((call) async {
      if (call.method == "closeReplayKitFromNative") {
        rtcManager.stopScreenShare();
      } else if (call.method == "hasSampleBroadcast") {
        rtcManager.startScreenShare();
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
