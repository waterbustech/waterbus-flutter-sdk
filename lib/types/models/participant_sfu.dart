import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/enums/audio_level.dart';
import 'package:waterbus_sdk/types/enums/track_type.dart';
import 'package:waterbus_sdk/types/models/rtc_participant_stats.dart';
import 'package:waterbus_sdk/utils/logger/logger.dart';

// ignore: must_be_immutable
class ParticipantSFU extends Equatable {
  final String ownerId;
  bool isVideoEnabled;
  bool isAudioEnabled;
  bool isE2eeEnabled;
  bool isSpeakerPhoneEnabled;
  bool isSharingScreen;
  bool isHandRaising;
  String? screenTrackId;
  CameraType cameraType;
  MediaSource? cameraSource;
  MediaSource? screenSource;
  RTCPeerConnection peerConnection;
  final RTCVideoCodec videoCodec;
  final Function()? onFirstFrameRendered;
  AudioLevel audioLevel;
  StreamController<AudioLevel>? audioLevelController;
  StreamController<RtcParticipantStats>? webcamStatsController;
  StreamController<RtcParticipantStats>? screenStatsController;
  ParticipantSFU({
    required this.ownerId,
    this.isVideoEnabled = true,
    this.isAudioEnabled = true,
    this.isSharingScreen = false,
    this.isE2eeEnabled = false,
    this.isSpeakerPhoneEnabled = true,
    this.isHandRaising = false,
    this.cameraType = CameraType.front,
    required this.peerConnection,
    required this.onFirstFrameRendered,
    required this.videoCodec,
    this.audioLevel = AudioLevel.kSilence,
    this.cameraSource,
    this.screenSource,
    this.audioLevelController,
    this.webcamStatsController,
    this.screenStatsController,
    this.screenTrackId,
  }) {
    if (cameraSource != null || screenSource != null) return;

    cameraSource = MediaSource(onFirstFrameRendered: onFirstFrameRendered);
    screenSource = MediaSource(onFirstFrameRendered: onFirstFrameRendered);

    audioLevelController = StreamController<AudioLevel>.broadcast();
    webcamStatsController = StreamController<RtcParticipantStats>.broadcast();
    screenStatsController = StreamController<RtcParticipantStats>.broadcast();
  }

  @override
  bool operator ==(covariant ParticipantSFU other) {
    if (identical(this, other)) return true;

    return other.isVideoEnabled == isVideoEnabled &&
        other.isAudioEnabled == isAudioEnabled &&
        other.isHandRaising == isHandRaising &&
        other.isSharingScreen == isSharingScreen &&
        other.peerConnection == peerConnection &&
        other.cameraSource == cameraSource &&
        other.screenSource == screenSource;
  }

  @override
  int get hashCode {
    return isVideoEnabled.hashCode ^
        isAudioEnabled.hashCode ^
        isHandRaising.hashCode ^
        isSharingScreen.hashCode ^
        peerConnection.hashCode ^
        cameraSource.hashCode ^
        screenSource.hashCode;
  }

  @override
  List<Object> get props {
    return [
      isVideoEnabled,
      isAudioEnabled,
      isHandRaising,
      isE2eeEnabled,
      isSpeakerPhoneEnabled,
      isSharingScreen,
      cameraType,
      peerConnection,
      videoCodec,
    ];
  }

  @override
  bool get stringify => true;

  ParticipantSFU copyWith({
    String? ownerId,
    bool? isVideoEnabled,
    bool? isAudioEnabled,
    bool? isHandRaising,
    bool? isE2eeEnabled,
    bool? isSpeakerPhoneEnabled,
    bool? isSharingScreen,
    String? screenTrackId,
    CameraType? cameraType,
    AudioLevel? audioLevel,
    RTCPeerConnection? peerConnection,
    RTCVideoCodec? videoCodec,
    Function()? onFirstFrameRendered,
  }) {
    return ParticipantSFU(
      ownerId: ownerId ?? this.ownerId,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
      isHandRaising: isHandRaising ?? this.isHandRaising,
      isE2eeEnabled: isE2eeEnabled ?? this.isE2eeEnabled,
      isSpeakerPhoneEnabled:
          isSpeakerPhoneEnabled ?? this.isSpeakerPhoneEnabled,
      isSharingScreen: isSharingScreen ?? this.isSharingScreen,
      screenTrackId: screenTrackId ?? this.screenTrackId,
      cameraType: cameraType ?? this.cameraType,
      peerConnection: peerConnection ?? this.peerConnection,
      videoCodec: videoCodec ?? this.videoCodec,
      onFirstFrameRendered: onFirstFrameRendered ?? this.onFirstFrameRendered,
      cameraSource: cameraSource,
      screenSource: screenSource,
      audioLevel: audioLevel ?? this.audioLevel,
      audioLevelController: audioLevelController,
      webcamStatsController: webcamStatsController,
      screenStatsController: screenStatsController,
    );
  }
}

extension ParticipantSFUX on ParticipantSFU {
  void sinkAudioLevel(AudioLevel level) {
    if (level == audioLevel) return;

    audioLevel = level;
    audioLevelController?.sink.add(level);
  }

  void sinkWebcamStats(RtcParticipantStats stats) {
    webcamStatsController?.sink.add(stats);
  }

  void sinkScreenStats(RtcParticipantStats stats) {
    screenStatsController?.sink.add(stats);
  }

  Future<void> addCandidate(RTCIceCandidate candidate) async {
    try {
      await peerConnection.addCandidate(candidate);
    } catch (error) {
      WaterbusLogger.instance.bug("====> E: ${error.toString()}");
    }
  }

  Future<void> setRemoteDescription(RTCSessionDescription description) async {
    try {
      await peerConnection.setRemoteDescription(description);
    } catch (error) {
      WaterbusLogger.instance.bug(error.toString());
    }
  }

  void switchCamera() {
    if (cameraType == CameraType.front) {
      cameraType = CameraType.rear;
    } else {
      cameraType = CameraType.front;
    }
  }

  Future<TrackType?> setSrcObject(
    MediaStream stream, {
    String? trackId,
    bool isDisplayStream = false,
  }) async {
    if (ownerId == kIsMine) {
      if (isDisplayStream) {
        screenSource?.setSrcObject(stream);
      } else {
        cameraSource?.setSrcObject(stream);
      }
      return null;
    }

    if (screenTrackId != null && trackId == screenTrackId) {
      // Set src screen
      screenSource?.setSrcObject(stream);
      return TrackType.screen;
    } else {
      // Set src camera
      cameraSource?.setSrcObject(stream);
      return TrackType.webcam;
    }
  }

  Future<void> setScreenSharing(bool isSharing, {String? screenTrackId}) async {
    isSharingScreen = isSharing;
    this.screenTrackId = screenTrackId;

    if (!isSharing) {
      await screenSource?.dispose();
      screenSource = MediaSource(onFirstFrameRendered: onFirstFrameRendered);
    }
  }

  Future<void> setHandRaising(bool isRaising) async {
    isHandRaising = isRaising;
  }

  Future<void> dispose() async {
    setScreenSharing(false);
    cameraSource?.dispose();
    peerConnection.close();
    audioLevelController?.close();
    webcamStatsController?.close();
    screenStatsController?.close();
  }
}

extension ParticipantSFUPublic on ParticipantSFU {
  Stream<AudioLevel>? get audioLevelStream => audioLevelController?.stream;

  Stream<RtcParticipantStats>? get webcamStatsStream =>
      webcamStatsController?.stream;

  Stream<RtcParticipantStats>? get screenStatsStream =>
      screenStatsController?.stream;
}
