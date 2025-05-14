import 'package:injectable/injectable.dart';
import 'package:waterbus_callkit_incoming/entities/call_event.dart';
import 'package:waterbus_callkit_incoming/waterbus_callkit_incoming.dart';

import 'package:waterbus_sdk/core/webrtc/webrtc_manager.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

@singleton
class CallKitListener {
  final WaterbusLogger _logger;
  final WebRTCManager _rtcManager;
  CallKitListener(
    this._logger,
    this._rtcManager,
  );

  void listenerEvents() {
    if (!WebRTC.platformIsIOS) return;

    try {
      FlutterCallkitIncoming.onEvent.listen((event) {
        if (event == null) return;

        switch (event.event) {
          case Event.actionCallIncoming:
            break;
          case Event.actionCallStart:
            break;
          case Event.actionCallAccept:
            break;
          case Event.actionCallDecline:
            break;
          case Event.actionCallEnded:
            _rtcManager.leaveRoom();
            break;
          case Event.actionCallTimeout:
            break;
          case Event.actionCallCallback:
            break;
          case Event.actionCallToggleHold:
            break;
          case Event.actionCallToggleMute:
            final isMuted = event.body['isMuted'];
            _rtcManager.toggleAudioInput(forceValue: !isMuted);
            break;
          case Event.actionCallToggleDmtf:
            break;
          case Event.actionCallToggleGroup:
            break;
          case Event.actionCallToggleAudioSession:
            break;
          case Event.actionDidUpdateDevicePushTokenVoip:
            break;
          case Event.actionCallCustom:
            break;
        }
      });
    } catch (error) {
      _logger.bug(error.toString());
    }
  }
}
