// Dart imports:
import 'dart:io';

// Package imports:
import 'package:injectable/injectable.dart';
import 'package:wakelock/wakelock.dart';

// Project imports:
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/helpers/logger/logger.dart';
import 'package:waterbus_sdk/helpers/replaykit/replaykit_helper.dart';
import 'package:waterbus_sdk/interfaces/webrtc_interface.dart';
import 'package:waterbus_sdk/method_channels/replaykit.dart';

@Singleton()
class SdkCore {
  final WaterbusWebRTCManager _rtcManager;
  final ReplayKitChannel _replayKitChannel;
  final WaterbusLogger _logger;
  SdkCore(
    this._rtcManager,
    this._replayKitChannel,
    this._logger,
  );

  bool _isListened = false;

  Future<void> joinRoom({
    required String roomId,
    required int participantId,
  }) async {
    try {
      if (!_isListened) {
        _isListened = true;
        _rtcManager.notifyChanged.listen((event) {
          WaterbusSdk.onEventChanged?.call(event);
        });
      }

      Wakelock.enable();

      await _rtcManager.joinRoom(
        roomId: roomId,
        participantId: participantId,
      );
    } catch (error) {
      _logger.bug(error.toString());
    }
  }

  Future<void> leaveRoom() async {
    try {
      await _rtcManager.dispose();
      Wakelock.disable();
    } catch (error) {
      _logger.bug(error.toString());
    }
  }

  Future<void> prepareMedia() async {
    await _rtcManager.prepareMedia();
  }

  Future<void> changeCallSettings(CallSetting setting) async {
    await _rtcManager.applyCallSettings(setting);
  }

  Future<void> switchCamera() async {
    await _rtcManager.switchCamera();
  }

  Future<void> toggleVideo() async {
    await _rtcManager.toggleVideo();
  }

  Future<void> toggleAudio() async {
    await _rtcManager.toggleAudio();
  }

  Future<void> toggleSpeakerPhone() async {
    await _rtcManager.toggleSpeakerPhone();
  }

  Future<void> startScreenSharing() async {
    if (Platform.isIOS) {
      ReplayKitHelper().openReplayKit();
      _replayKitChannel.startReplayKit();
      _replayKitChannel.listenEvents(_rtcManager);
    } else {
      await _rtcManager.startScreenSharing();
    }
  }

  Future<void> stopScreenSharing() async {
    try {
      if (Platform.isIOS) {
        ReplayKitHelper().openReplayKit();
      } else {
        await _rtcManager.stopScreenSharing();
      }
    } catch (error) {
      _logger.bug(error.toString());
    }
  }

  CallState get callState => _rtcManager.callState();
}
