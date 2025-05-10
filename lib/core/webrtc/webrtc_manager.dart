import 'dart:typed_data';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/models/subscribe_response.dart';

abstract class WebRTCManager {
  // Room Management
  Future<void> joinRoom({required String roomId, required int participantId});
  Future<void> reconnect();
  Future<void> subscribe(List<String> targetIds);
  Future<void> setPublisherRemoteSdp(String sdp, [bool? isRecording]);
  Future<void> setSubscriberRemoteSdp(SubscribeResponsePayload payload);
  Future<void> renegotiateSubscriber({
    required String targetId,
    required String sdp,
  });
  Future<void> addPublisherCandidate(RTCIceCandidate candidate);
  Future<void> addSubscriberCandidate(
    String targetId,
    RTCIceCandidate candidate,
  );
  Future<void> handleNewParticipant(Participant participant);
  Future<void> handleParticipantLeave(String targetId);
  Future<void> dispose();

  // Control Settings
  Future<void> applySettings(CallSetting setting);
  Future<void> prepareMedia();
  Future<void> startScreenSharing({DesktopCapturerSource? source});
  Future<void> stopScreenSharing({bool stayInRoom = true});
  Future<void> toggleAudio({bool? forceValue});
  Future<void> toggleSpeakerPhone({bool? forceValue});
  Future<void> toggleVideo();
  Future<void> switchCamera();
  void toggleRaiseHand();
  void setE2eeEnabled({
    required RTCRtpReceiver receiver,
    required String targetId,
    required bool isEnabled,
  });
  void setVideoEnabled({required String targetId, required bool isEnabled});
  void setCameraType({required String targetId, required CameraType type});
  void setAudioEnabled({required String targetId, required bool isEnabled});
  void setScreenSharing({
    required String targetId,
    required bool isSharing,
    required String? screenTrackId,
  });
  void setHandRaising({required String targetId, required bool isRaising});
  void setIsRecording({required bool isRecording});
  Future<void> enableVirtualBackground({
    required Uint8List backgroundImage,
    double thresholdConfidence = 0.7,
  });
  Future<void> disableVirtualBackground({bool reset = false});

  // Expose states
  CallState callState();
  Stream<CallbackPayload> get notifyChanged;
  String? get roomId;
  bool get isRecording;
}
