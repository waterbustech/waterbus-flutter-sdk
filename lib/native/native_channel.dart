import 'package:flutter/services.dart';

import 'package:injectable/injectable.dart';
import 'package:waterbus_callkit_incoming/waterbus_callkit_incoming.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

@injectable
class NativeService {
  final MethodChannel _nativeChannel = const MethodChannel(kNativeChannel);

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

  Future<void> startCallKit(String nameCaller) async {
    if (!WebRTC.platformIsIOS) return;

    await _nativeChannel.invokeMethod("startCallKit", {
      "nameCaller": nameCaller,
    });
  }

  Future<void> endCallKit() async {
    if (!WebRTC.platformIsIOS) return;

    final String uuidCaller = await _getCurrentUuid();

    if (uuidCaller.isEmpty) return;

    await FlutterCallkitIncoming.endCall(uuidCaller);
  }

  Future<String> _getCurrentUuid() async {
    if (!WebRTC.platformIsIOS) return '';

    final String uuid =
        await _nativeChannel.invokeMethod("getCurrentUuid") ?? '';

    return uuid;
  }
}
