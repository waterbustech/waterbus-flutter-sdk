import 'dart:async';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/internals/enums/connection_type.dart';
import 'package:waterbus_sdk/types/internals/enums/index.dart';

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
  Function()? get onFirstFrameRendered;
  RTCVideoCodec get videoCodec;
  AudioLevel get audioLevel;
  MediaSource? get cameraSource;
  MediaSource? get screenSource;
  StreamController<AudioLevel>? get audioLevelController;
  StreamController<RtcParticipantStats>? get webcamStatsController;
  StreamController<RtcParticipantStats>? get screenStatsController;
  String? get screenTrackId;
  ConnectionType get connectionType;
  RTCDataChannel? get trackQualityChannel;
  RTCPeerConnection? get backupPc;

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
  set screenTrackId(String? value);
  set trackQualityChannel(RTCDataChannel? value);
  set connectionType(ConnectionType value);
  set backupPc(RTCPeerConnection? value);

  // Abstract methods
  bool get isMe;
  Future<Participant> createTrackQualityChannel({RTCPeerConnection? pc});
  void listenTrackQualityChannel();
  Participant sinkAudioLevel(AudioLevel level);
  void sinkWebcamStats(RtcParticipantStats stats);
  void sinkScreenStats(RtcParticipantStats stats);
  Future<void> addCandidate(RTCIceCandidate candidate);
  Future<void> setRemoteDescription(RTCSessionDescription description);
  Participant get switchCamera;
  TrackType? setSrcObject(MediaStream stream,
      {String? trackId, bool isDisplayStream = false});
  Future<Participant> setScreenSharing(bool isSharing, {String? screenTrackId});
  Participant setHandRaising(bool isRaising);
  Future<void> dispose();

  // Stream getters
  Stream<AudioLevel>? get audioLevelStream;
  Stream<RtcParticipantStats>? get webcamStatsStream;
  Stream<RtcParticipantStats>? get screenStatsStream;
}
