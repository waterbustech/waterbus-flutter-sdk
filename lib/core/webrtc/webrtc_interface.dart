import 'dart:typed_data';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

abstract class WaterbusWebRTCManager {
  Future<void> joinRoom({required String roomId, required int participantId});
  Future<void> reconnect();
  Future<void> subscribe(List<String> targetIds);
  Future<void> setPublisherRemoteSdp(String sdp, [bool? isRecording]);
  Future<void> setSubscriberRemoteSdp({
    required String targetId,
    required String sdp,
    required bool videoEnabled,
    required bool audioEnabled,
    required bool isScreenSharing,
    required bool isE2eeEnabled,
    required bool isHandRaising,
    required CameraType type,
    required WebRTCCodec codec,
  });
  Future<void> handleSubscriberRenegotiation({
    required String targetId,
    required String sdp,
  });
  Future<void> addPublisherCandidate(RTCIceCandidate candidate);
  Future<void> addSubscriberCandidate(
    String targetId,
    RTCIceCandidate candidate,
  );
  Future<void> newParticipant(Participant participant);
  Future<void> participantHasLeft(String targetId);
  Future<void> dispose();

  // MARK: control
  Future<void> applyCallSettings(CallSetting setting);
  Future<void> prepareMedia();
  Future<void> startScreenSharing({DesktopCapturerSource? source});
  Future<void> stopScreenSharing({bool stayInRoom = true});
  Future<void> toggleAudio({bool? forceValue});
  Future<void> toggleSpeakerPhone({bool? forceValue});
  Future<void> toggleVideo();
  Future<void> switchCamera();
  void toggleRaiseHand();
  void setE2eeEnabled({required String targetId, required bool isEnabled});
  void setVideoEnabled({required String targetId, required bool isEnabled});
  void setCameraType({required String targetId, required CameraType type});
  void setAudioEnabled({required String targetId, required bool isEnabled});
  void setScreenSharing({required String targetId, required bool isSharing});
  void setHandRaising({required String targetId, required bool isRaising});
  void setIsRecording({required bool isRecording});
  Future<void> enableVirtualBackground({
    required Uint8List backgroundImage,
    double thresholdConfidence = 0.7,
  });
  Future<void> disableVirtualBackground({bool reset = false});

  // Getter
  CallState callState();
  Stream<CallbackPayload> get notifyChanged;
  String? get roomId;
  bool get isRecording;
}
