// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/constants/constants.dart';

@injectable
class NativeService {
  final MethodChannel _nativeChannel = const MethodChannel(kNativeChannel);

  Future<double> getPlatformVersion() async {
    final String? platformVersion = await _nativeChannel.invokeMethod(
      "getPlatformVersion",
    );

    return double.parse((platformVersion ?? '0').split('.').first);
  }

  Future<void> startForegroundService() async {
    if (!Platform.isAndroid) return;

    await _nativeChannel.invokeMethod("startForeground");
  }

  Future<void> stopForegroundService() async {
    if (!Platform.isAndroid) return;

    await _nativeChannel.invokeMethod("stopForeground");
  }

  Future<void> startCallKit(String nameCaller) async {
    if (!Platform.isIOS) return;

    await _nativeChannel.invokeMethod("startCallKit", {
      "nameCaller": nameCaller,
    });
  }

  Future<void> endCallKit() async {
    final String uuidCaller = await _getCurrentUuid();

    if (uuidCaller.isEmpty) return;

    await FlutterCallkitIncoming.endCall(uuidCaller);
  }

  Future<String> _getCurrentUuid() async {
    if (!Platform.isIOS) return '';

    final String uuid =
        await _nativeChannel.invokeMethod("getCurrentUuid") ?? '';

    return uuid;
  }
}
