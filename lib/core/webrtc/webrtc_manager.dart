import 'dart:typed_data';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/internals/enums/connection_type.dart';
import 'package:waterbus_sdk/types/internals/models/index.dart';

abstract class WebRTCManager {
  // ====== Room Management ======
  Future<void> joinRoom({
    required String roomId,
    required int participantId,
    required ConnectionType connectionType,
  });
  Future<void> reconnectRoom();
  void subscribeToParticipants(List<String> targetIds);
  Future<void> leaveRoom();

  // ====== Signaling / SDP / ICE ======
  Future<void> setLocalSdpAsPublisher(String sdp, [bool? isRecording]);
  Future<void> setRemoteSdpAsSubscriber(SubscribeResponsePayload payload);
  Future<void> renegotiateWithParticipant({
    required String targetId,
    required String sdp,
  });
  Future<void> addIceCandidateToPublisher(RTCIceCandidate candidate);
  Future<void> addIceCandidateToSubscriber(
    String targetId,
    RTCIceCandidate candidate,
  );

  // ====== Participant Handling ======
  Future<void> handleParticipantJoined({
    required Participant participant,
    required bool isMigrate,
  });
  Future<void> handleParticipantLeft(String targetId);

  // ====== Media & Device Control ======
  Future<void> initializeMediaDevices();
  Future<void> updateMediaConfig(MediaConfig setting);

  Future<void> toggleAudioInput({bool? forceValue});
  Future<void> toggleVideoInput();
  Future<void> toggleSpeakerOutput({bool? forceValue});
  Future<void> changeAudioInputDevice({required String deviceId});
  Future<void> changeVideoInputDevice({required String deviceId});
  Future<void> switchCameraInput();

  // ====== Screen Sharing ======
  Future<void> startScreenShare({DesktopCapturerSource? source});
  Future<void> stopScreenShare({bool stayInRoom = true});

  // ====== Virtual Background ======
  Future<void> enableVirtualBg({
    required Uint8List backgroundImage,
    double thresholdConfidence = 0.7,
  });
  Future<void> disableVirtualBg({bool reset = false});

  // ====== Raise Hand & State Toggling ======
  void toggleHandRaise();
  void setParticipantHandRaising({
    required String targetId,
    required bool isRaising,
  });
  void setRecordingStatus({required bool isRecording});
  void setParticipantCameraType({
    required String targetId,
    required CameraType type,
  });
  void setParticipantVideoEnabled({
    required String targetId,
    required bool isEnabled,
  });
  void setParticipantAudioEnabled({
    required String targetId,
    required bool isEnabled,
  });
  void setParticipantScreenSharing({
    required ParticipantScreenSharingConfig config,
  });
  void setParticipantE2ee({required ParticipantE2eeConfig config});

  // ====== State Exposure ======
  CallState getCallState();
  Stream<CallbackPayload> get onCallChanged;
  String? get currentRoomId;
  bool get isRecordingActive;
}
