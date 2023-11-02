// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/constants/method_channel_name.dart';
import 'package:waterbus_sdk/interfaces/webrtc_interface.dart';

@singleton
class ReplayKitChannel {
  final MethodChannel rkChannel = const MethodChannel(replayKitChannel);

  void listenEvents(WaterbusWebRTCManager rtcManager) {
    rkChannel.setMethodCallHandler((call) async {
      if (call.method == "closeReplayKitFromNative") {
        rtcManager.stopScreenSharing();
      } else if (call.method == "hasSampleBroadcast") {
        rtcManager.startScreenSharing();
      }
    });
  }

  void startReplayKit() {
    if (!Platform.isIOS) return;

    rkChannel.invokeMethod("startReplayKit");
  }

  void closeReplayKit() {
    if (!Platform.isIOS) return;

    rkChannel.invokeMethod("closeReplayKitFromFlutter");
  }
}
