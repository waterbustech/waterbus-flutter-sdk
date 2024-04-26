// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/interfaces/webrtc_interface.dart';

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
