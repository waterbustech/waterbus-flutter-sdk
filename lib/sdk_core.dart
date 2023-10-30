import 'package:injectable/injectable.dart';
import 'package:waterbus/interfaces/webrtc_interface.dart';
import 'package:waterbus/models/index.dart';

@Singleton()
class SdkCore {
  final WaterbusWebRTCManager _rtcManager;
  SdkCore(this._rtcManager);

  Future<void> joinRoom({
    required String roomId,
    required int participantId,
    required Function(CallbackPayload) onNewEvent,
  }) async {
    await _rtcManager.joinRoom(
      roomId: roomId,
      participantId: participantId,
    );

    _rtcManager.notifyChanged.listen((event) {
      onNewEvent(event);
    });
  }

  Future<void> leaveRoom() async {
    await _rtcManager.dispose();
  }

  Future<void> prepareMedia() async {
    await _rtcManager.prepareMedia();
  }

  Future<void> changeCallSettings(CallSetting setting) async {
    await _rtcManager.applyCallSettings(setting);
  }

  Future<void> toggleVideo() async {
    await _rtcManager.toggleVideo();
  }

  Future<void> toggleAudio() async {
    await _rtcManager.toggleAudio();
  }

  CallState get callState => _rtcManager.callState();
}
