import 'package:flutter/services.dart';

import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/v4.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

@injectable
class NativeService {
  final MethodChannel _nativeChannel = const MethodChannel(kNativeChannel);
  String _currentUuid = '';

  Future<double> getPlatformVersion() async {
    if (!WebRTC.platformIsMobile) return 0;

    final String? platformVersion = await _nativeChannel.invokeMethod(
      "getPlatformVersion",
    );

    return double.parse((platformVersion ?? '0').split('.').first);
  }

  Future<void> startForegroundService() async {
    if (!WebRTC.platformIsAndroid) return;

    await _nativeChannel.invokeMethod("startForeground");
  }

  Future<void> stopForegroundService() async {
    if (!WebRTC.platformIsAndroid) return;

    await _nativeChannel.invokeMethod("stopForeground");
  }

  Future<void> startCallKit(String nameCaller, {String? avatar}) async {
    if (!WebRTC.platformIsIOS) return;

    _currentUuid = UuidV4().generate();

    final CallKitParams callKitParams = CallKitParams(
      id: _currentUuid,
      nameCaller: nameCaller,
      appName: 'Waterbus',
      avatar: avatar,
      handle: '0123456789',
      type: 0,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      callingNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Calling...',
        callbackText: 'Hang Up',
      ),
      duration: 30000,
      extra: <String, dynamic>{'userId': '1a2b3c4d'},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        logoUrl: avatar,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl: avatar,
        actionColor: '#4CAF50',
        textColor: '#ffffff',
        incomingCallNotificationChannelName: "Incoming Call",
        missedCallNotificationChannelName: "Missed Call",
        isShowCallID: false,
      ),
      ios: IOSParams(
        iconName: 'AppLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);

    FlutterCallkitIncoming.startCall(callKitParams);
  }

  Future<void> endCallKit() async {
    if (!WebRTC.platformIsIOS) return;

    if (_currentUuid.isEmpty) return;

    await FlutterCallkitIncoming.endCall(_currentUuid);
  }
}
