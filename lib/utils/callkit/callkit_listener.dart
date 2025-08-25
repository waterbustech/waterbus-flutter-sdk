import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'package:waterbus_sdk/core/rtc/rtc_manager.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

@singleton
class CallKitListener {
  final RtcManager _rtcManager;

  final _logger = Logger('CallKitListener');

  CallKitListener(
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
          case Event.actionCallConnected:
            break;
        }
      });
    } catch (error) {
      _logger.severe(error.toString());
    }
  }
}
