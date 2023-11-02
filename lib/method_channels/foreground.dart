// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus_sdk/constants/method_channel_name.dart';

@injectable
class ForegroundService {
  final MethodChannel _foregroundChannel =
      const MethodChannel(foregroundChannel);

  Future<void> startForegroundService() async {
    await _foregroundChannel.invokeMethod("startForeground");
  }

  Future<void> stopForegroundService() async {
    await _foregroundChannel.invokeMethod("stopForeground");
  }
}
