// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/constants/constants.dart';
import 'package:waterbus_sdk/interfaces/webrtc_interface.dart';

@singleton
class ReplayKitChannel {
  final MethodChannel rkChannel = const MethodChannel(kReplayKitChannel);

  void listenEvents(WaterbusWebRTCManager rtcManager) {
    if (!Platform.isIOS) return;

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
