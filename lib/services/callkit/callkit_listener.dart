// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/helpers/logger/logger.dart';
import 'package:waterbus_sdk/interfaces/webrtc_interface.dart';

@singleton
class CallKitListener {
  final WaterbusLogger _logger;
  final WaterbusWebRTCManager _rtcManager;
  CallKitListener(
    this._logger,
    this._rtcManager,
  );

  void listenerEvents() {
    if (!Platform.isIOS) return;

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
            _rtcManager.dispose();
            break;
          case Event.actionCallTimeout:
            break;
          case Event.actionCallCallback:
            break;
          case Event.actionCallToggleHold:
            break;
          case Event.actionCallToggleMute:
            final isMuted = event.body['isMuted'];
            _rtcManager.toggleAudio(forceValue: !isMuted);
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
