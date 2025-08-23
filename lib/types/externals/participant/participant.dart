import 'dart:async';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

abstract class Participant {
  String get ownerId;
  bool get isVideoEnabled;
  bool get isAudioEnabled;
  bool get isSharingScreen;
  bool get isE2eeEnabled;
  bool get isSpeakerPhoneEnabled;
  bool get isHandRaising;
  CameraType get cameraType;
  RTCPeerConnection get peerConnection;
  RTCDataChannel? get dataChannel;
  Function()? get onFirstFrameRendered;
  RTCVideoCodec get videoCodec;
  AudioLevel get audioLevel;
  MediaSource? get cameraSource;
  MediaSource? get screenSource;
  StreamController<AudioLevel>? get audioLevelController;
  StreamController<RtcParticipantStats>? get webcamStatsController;
  StreamController<RtcParticipantStats>? get screenStatsController;
  String? get screenMid;
  ConnectionType get connectionType;
  RTCPeerConnection? get backupPc;
  ParticipantInfo get info;

  // Setters for mutable properties
  set peerConnection(RTCPeerConnection value);
  set isVideoEnabled(bool value);
  set isAudioEnabled(bool value);
  set isSharingScreen(bool value);
  set isE2eeEnabled(bool value);
  set isSpeakerPhoneEnabled(bool value);
  set isHandRaising(bool value);
  set cameraType(CameraType value);
  set audioLevel(AudioLevel value);
  set cameraSource(MediaSource? value);
  set screenSource(MediaSource? value);
  set screenMid(String? value);
  set connectionType(ConnectionType value);
  set backupPc(RTCPeerConnection? value);
  set info(ParticipantInfo value);

  // Abstract methods
  bool get isMe;
  Future<void> createDataChannel();
  void listenDataChannel();
  Participant sinkAudioLevel(AudioLevel level);
  void sinkWebcamStats(RtcParticipantStats stats);
  void sinkScreenStats(RtcParticipantStats stats);
  Future<void> addCandidate(RTCIceCandidate candidate);
  Future<void> setRemoteDescription(RTCSessionDescription description);
  Participant get switchCamera;
  TrackType? setSrcObject(
    MediaStream stream, {
    String? mid,
    bool isDisplayStream = false,
  });
  Future<Participant> setScreenSharing(bool isSharing, {String? screenMid});
  Participant setHandRaising(bool isRaising);
  Future<void> dispose();

  // Stream getters
  Stream<AudioLevel>? get audioLevelStream;
  Stream<RtcParticipantStats>? get webcamStatsStream;
  Stream<RtcParticipantStats>? get screenStatsStream;
}
